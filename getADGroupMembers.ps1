$adgroups = Get-ADGroup -Filter "name -like '*cumpleañeros*'" | sort name

$data = foreach ($adgroup in $adgroups) {
    $members = $adgroup | get-adgroupmember | sort name
    foreach ($member in $members) {
        [PSCustomObject]@{
            Group   = $adgroup.Name
            Members = $member
        }
    }
}

#$data | export-csv "E:\Scripts\groupinfo.csv" -NoTypeInformation
$data | Out-GridView