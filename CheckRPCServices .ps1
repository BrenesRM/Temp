function importPortQry{
    if (Get-Command portqry.exe -ErrorAction SilentlyContinue){
        if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))}
        choco install portqry -y | out-null
        if (Get-Command portqry.exe -ErrorAction SilentlyContinue){return $true}else{return $false}
        }else{
        return $false;
        }
}
 
function Check-NetConnection($server, $port) {
    $session = New-Object System.Net.Sockets.TcpClient;
    $result=$false
    try {
        $session.Connect($server, $port);
        $result=$true;
    } catch {
        $result=$false;
    } finally {
        $session.Close();
        
    }
    return $result;
}
 
function testPort{
    Param(
        [string]$server,
        [int]$port=135
        )
     
    # using a workflow to test each ports in the array
    workflow testPortArray {
        # Casting parameters is better than passing arguments as that allows for switches that can be arranged in any order
        param ([string]$targetServer,[array]$arrPorts)
        $source = $env:computername
        $destination=$targetServer.toUpper()
                       
        # Test all ports using multi-threaded sessions to save time      
        foreach -parallel ($port in $arrPorts){        
            $testResult = Check-NetConnection -server $targetServer -port $port;
            If ($testResult){
                Write-Output "$port`: reachable"
                }
            Else{
                Write-Output "$port`: unreachable"
                }
        }
    }
     
    #  Check for existence of PortQry.exe
    $portQryExists=Get-Command "PortQry.exe" -ErrorAction SilentlyContinue
    while (!($portQryExists)){
        importPortQry;
        sleep 1;
        $portQryExists #refreshes the Get-Command query
        }
    $reachable=Check-NetConnection -server $server -port $port
     
    if ($reachable){
        write-host "$env:computername is able to reach $server on the primary port of $port.`r`n"
        $strInvokeCommand = "PortQry.exe -e $port -n $server";
        $arrQuryResult = Invoke-Expression $strInvokeCommand;
     
        $arrPorts = @();    #Initiates and clears the collection of ports array
        ForEach ($strResult in $arrQuryResult)
        {
          If ($strResult.Contains("ip_tcp"))
          {
          $arrSplt = $strResult.Split("[");
          $strPort = $arrSplt[1];
          $strPort = $strPort.Replace("]","");
          $arrPorts += $strPort;
          }
        }
 
        #  Remove duplicate port records from within the array
        $arrPorts = $arrPorts | select -uniq
        if ($arrPorts){            
            write-host "These are the detected dynamic ephemeral ports being used:`r`n$arrPorts"        
            testPortArray -targetServer $server -arrPorts $arrPorts #  Pass the ports array into the workflow as a parameter
            }else{
                write-host "Ephemeral ports were NOT detected.`r`n"
                }
 
        }else{
            write-host "$env:computername is NOT able to reach $server on port: $port`r`n"
            }
}
 
testPort -server honeypot.kimconnect.com -port 135
 
<# Sample Output:
JUMPBOX is able to reach HONEYPOT on the primary port of 135.
 
These are the detected dynamic ephemeral ports being used:
49664 55321 55281 49672 49670 49669 49668 49667 49673 49666 49665
49665: reachable
49667: reachable
49666: reachable
49673: reachable
49669: reachable
49668: reachable
49670: reachable
55281: reachable
49672: reachable
55321: reachable
49664: reachable
#>
