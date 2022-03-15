$outputEpoSFileCSV = "F:\reports\IaaC_Epo.csv"

(Get-Content $outputEpoSFileCSV | Select-Object -Skip 7) | Set-Content $outputEpoSFileCSV

New-PSDrive -Name Y -PSProvider FileSystem -Root "\\BC-ADPOW-102\Output" -Persist
xcopy F:\reports\IaaC_Epo.csv Y:\ /S /I /H /c /y
Start-Sleep -s 4
Remove-PSDrive -Name Y