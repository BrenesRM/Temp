$webclient = New-Object net.webclient
#$Json = $webclient.DownloadString("https://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json") | ConvertFrom-Json
$Json = $webclient.DownloadString("https://www.reddit.com/.json") | ConvertFrom-Json
$key=@()
(0..($Json.data.children.Count -1)) | ForEach-Object {
    $key+= @{
    "title"=$Json.data.children.Item($_).data.title
    "url"=$Json.data.children.Item($_).data.url
    "Permalink"=$Json.data.children.Item($_).data.permalink
    }
}

($key.Count -1) | ForEach-Object {
    $key | select Values
    }

#$DatoFinal = $key | select Values
#$DatoFinal