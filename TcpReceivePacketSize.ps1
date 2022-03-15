get-psdrive
cd HKLM:\
set-location -path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters
Get-Item -path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters" -Name "TcpReceivePacketSize" -Value ”0xFF00”  -PropertyType "DWORD"
net stop dns
net start dns