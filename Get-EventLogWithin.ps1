<#
.Synompses: Recolecta Eventos:
.Example: .\Get-EventLogWithin.ps1 -StartTimesStamp '09-18-20 17:30' -EndTimesStamp '09-18-20 17:40'
.Parameters: .\Get-EventLogWithin.ps1 -ComputerName $(Get-WmiObject Win32_Computersystem).name -StartTimesStamp '04-16-15 04:00' -EndTimesStamp '04-16-15 05:00'
.Alias:
.Notas:
#>

param ([string]$ComputerName = 'HostName', [datetime]$StartTimesStamp, [datetime]$EndTimesStamp)
$Computername = $(Get-WmiObject Win32_Computersystem).name
$Logs = (Get-WinEvent -ListLog * -ComputerName $Computername | where {$_.RecordCount}).LogName
$FilterTable = @{
    '$StartTime' = $StartTimesStamp
    '$EndTime' = $EndTimesStamp
    'LogName' = $Logs
}
$FilterTable
Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable -ErrorAction 'SilentlyContinue'