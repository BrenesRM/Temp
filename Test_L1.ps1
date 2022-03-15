$ErrorActionPreference = 'SilentlyContinue'
cd D:\
MD Test_L1
Test-NetConnection -ComputerName "central.bccr.fi.cr" -TraceRoute -InformationLevel "Detailed" > D:\Test_L1\Computer_Red.txt
Test-NetConnection -ComputerName "central.bccr.fi.cr" -Port 135 -InformationLevel "Detailed" > D:\Test_L1\Computer_ActDirec.txt
Test-NetConnection -ComputerName "Intranet" -Port 80 -InformationLevel "Detailed" > D:\Test_L1\Computer_Intra.txt
Test-NetConnection -ComputerName "LIBRA1" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_Libra1.txt
Test-NetConnection -ComputerName "LIBRA2" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_Libra2.txt
Test-NetConnection -ComputerName "LIBRA3" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_Libra3.txt
Test-NetConnection -ComputerName "LIBRA4" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_Libra4.txt
Test-NetConnection -ComputerName "LIBRA5" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_Libra5.txt
Test-NetConnection -ComputerName "LIBRA6" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_Libra6.txt
Test-NetConnection -ComputerName "VALLE" -Port 445 -InformationLevel "Detailed" > D:\Test_L1\Computer_VALLE.txt
Test-NetConnection -ComputerName "canea.central.bccr.fi.cr" -Port 8443 -InformationLevel "Detailed" > D:\Test_L1\Computer_Jabber.txt
Test-NetConnection -ComputerName "MAGALLANES.central.bccr.fi.cr" -Port 5000 -InformationLevel "Detailed" > D:\Test_L1\Computer_MonitorApp.txt

