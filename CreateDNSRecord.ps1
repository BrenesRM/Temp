Remove-DnsServerResourceRecord -ZoneName terra.central.bccr.fi.cr -Name HolaPrueba -RRType A
Add-DnsServerResourceRecordA -Name HolaPrueba -ZoneName terra.central.bccr.fi.cr -IPv4Address 192.168.68.56
Get-DnsServerResourceRecord -ZoneName terra.central.bccr.fi.cr -RRType A