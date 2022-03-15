#Exporta el contenido del ReceiveConnector atributo remoteipranges al archivo c:\relayIPs.txt
#Get-ReceiveConnector “Default Frontend PAZ” | select -ExpandProperty remoteipranges | fl > c:\relayIPs.txt
#Crea Variable para el conector
$RecvConn = Get-ReceiveConnector "Default Frontend PAZ"
#Carga el contenido de cada IPRange del archivo
Get-Content .\relayIPs.txt | foreach {$RecvConn.RemoteIPRanges += "$_"}
#Seta el receiveConnector con los datos del archivo
Set-ReceiveConnector "Default Frontend PAZ" -RemoteIPRanges $RecvConn.RemoteIPRanges