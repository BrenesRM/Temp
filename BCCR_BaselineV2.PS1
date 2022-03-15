function Handler($context, $inputs) {
    $inputsString = $inputs | ConvertTo-Json -Compress
    $tmpl_pass = $context.getSecret($inputs.Guest_User_Pwd)
    $tmpl_user = $inputs.customProperties.template_usr
    $vcuser = $inputs.customProperties.vc_user
    $vcpassword = $context.getSecret($inputs.vcPassword)
    $vcfqdn = $inputs.customProperties.vcfqdn
    $vrss =  $inputs.customProperties.vrss

    $name = $inputs.resourceNames[0]
    $hostname = $name
    
    Connect-VIServer $vcfqdn -User $vcuser -Password $vcpassword -Force
    write-host "Waiting for VM Tools to Start"
    do {
    $toolsStatus = (Get-vm -name $name | Get-View).Guest.ToolsStatus
    write-host $toolsStatus
    sleep 3
    } until ( $toolsStatus -eq 'toolsOk' -or $toolsStatus -eq 'toolsOld')
    $vm = Get-vm -name $name
    #output = $inputs.customProperties.softwareName
    #$output = $inputs.customProperties.osType
    $output = "WINDOWS"
    Write-Host "VM OS Type is "$output
    
    #$windowsString = 'Microsoft Windows Server 2016 or later (64-bit)'
    $windowsString = 'WINDOWS'
    $MasterScript = @"
    `$ipFilters = `"^(192\.168|10\.240)\.(7[2-7]|8[4-9]|9[02-9]|124|125)\..*`";
    `$OObb = Get-NetIPAddress | Where-Object { `$_.IPAddress -match `$ipFilters} | select IPAddress;
    `$REDADM = `"192.168.68.0`"; 
    route delete `$REDADM; 
    If(`$OObb.IPAddress -ne `$null ) {
        `$IPOoBReal = `$OObb.IPAddress;             
        `$OCTETOS = `$IPOoBReal.Split(`".`");           
        `$ROUTE = `$OCTETOS[0] + (`".`") + `$OCTETOS[1] + (`".`") + `$OCTETOS[2] + (`".1`");             
        route add -p `$REDADM MASK 255.255.255.0 `$ROUTE;
        }
    <#Cambiamos a la unidad y directorio para la creacion del temporal en el servidor
    cd c:\
    #Se crea el directorio temporal baseline para copiar los artefactos que le corresponden 
    mkdir BaseLine
    #Se manda a mapear el repositorio 
    net use z: \\192.168.68.212\BCCR.VRA.Provisioning.Baseline `"`$An2ibleDmn`" /USER:pdc-atlantida\usr_VMMaquinas_Adm 
    #Cambiamos a la unidad y directorio para la creacion del temporal en el servidor 
    #Se obtiene la version de Sistema operativo. Esto nos va a decir que tipo de scripts e instaladores deben ejecutarse
    `$WinVersion = [System.Environment]::OSVersion.Version
    `$WinVersion.Major
    `$SOVersion = `"{0}.{1}`" -f `$WinVersion.Major, `$WinVersion.Minor

    #Se obtienen los artefactos filtrados que le corresponden segun el tipo de servidor
    `$folders = Get-ChildItem -Directory `"z:\`"  -Recurse | Where-Object { `$_.Name -eq `"ALL`" -or `$_.Name -eq `$SOVersion } | select fullname
    `$folders#>
"@
    if ($output.Equals($windowsString)) {
        #$os_type = "Minion installed on Windows"
       
        $script = "Invoke-WebRequest http://bc-adwsu-102.central.bccr.fi.cr/BCCR.VRA.Provisioning.Baseline/Utilitarios/SaltStack/Salt-Minion-Latest-Py3-AMD64-Setup.exe -UseBasicParsing -OutFile ~\Downloads\minion.exe"
        $script2 = "~\Downloads\minion.exe /S /master=$vrss /minion-name=$hostname; Set-Content -Path C:\salt\conf\minion_id -Value `$env:COMPUTERNAME; C:\salt\salt-call.bat service.restart salt-minion"
        Start-Sleep -s 60
        Write-Host "%%%%%%%%%%%%%%"
        Write-Host $MasterScript
        Write-Host "%%%%%%%%%%%%%%"
        Write-Host $script
        Write-Host "%%%%%%%%%%%%%%"
        Write-Host $script2
        Write-Host "%%%%%%%%%%%%%%"
        $runscript = Invoke-VMScript -VM $vm -ScriptText $MasterScript -GuestUser $tmpl_user -GuestPassword $tmpl_pass -ToolsWaitSecs 300
        $runscript = Invoke-VMScript -VM $vm -ScriptText $script -GuestUser $tmpl_user -GuestPassword $tmpl_pass -ToolsWaitSecs 300
        <#Write-Host $runscript.ScriptOutput#>
        $runscript2 = Invoke-VMScript -VM $vm -ScriptText $script2 -GuestUser $tmpl_user -GuestPassword $tmpl_pass -ToolsWaitSecs 300
        <#Write-Host $runscript2.ScriptOutput#>
        Write-Host "Minion installed on Windows using EXE"
    } else {
        Write-Host = "Linux N/A"
        #$os_type = "Minion installed on Linux"
        #$script = "echo $tmpl_pass | sudo -S curl -L https://bootstrap.saltstack.com -o install_salt.sh && echo $tmpl_pass | sudo -S hostnamectl set-hostname $hostname && echo $tmpl_pass | sudo -S chmod 777 install_salt.sh && echo $tmpl_pass | sudo -S sh install_salt.sh -A $vrss"
        <#Write-Host $script#>
        #Start-Sleep -s 60
        #$runscript = Invoke-VMScript -VM $vm -ScriptText $script -GuestUser $tmpl_user -GuestPassword $tmpl_pass -ToolsWaitSecs 300
        <#Write-Host $runscript.ScriptOutput#>
        #Write-Host = "Used bootstrap"
    }

}