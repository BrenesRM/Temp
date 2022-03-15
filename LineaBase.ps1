C:\PS> [void][System.Console]::ReadKey($FALSE)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-Service RpcSs -StartupType Automatic
\\192.168.68.217\AppServidores\Instaladores\Scripts\WinRM\WinrmConf.ps1
winrm/config/listener
rute print
CMD /c PAUSE
slmgr.vbs -skms 192.168.68.128:1688
slmgr.vbs -ato