$webclient = New-Object net.webclient
$Json = $webclient.DownloadString("https://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json") | ConvertFrom-Json
($Json.members.Count -1) | ForEach-Object {
    $Json.members
    $key+= @{"Name"=$Json.members.Item($_).Name
             "Age"=$Json.members.Item($_).Age}
    }