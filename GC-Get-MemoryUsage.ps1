#requires -Version 2

$script:last_memory_usage_byte = 0

function Get-MemoryUsage
{
  $memusagebyte = [System.GC]::GetTotalMemory('forcefullcollection')
  $memusageMB = $memusagebyte / 1MB
  $diffbytes = $memusagebyte - $script:last_memory_usage_byte
  $difftext = ''
  $sign = ''
  if ( $script:last_memory_usage_byte -ne 0 )
  {
    if ( $diffbytes -ge 0 )
    {
      $sign = '+'
    }
    $difftext = ", $sign$diffbytes"
  }
  Write-Host -Object ('Memory usage: {0:n1} MB ({1:n0} Bytes{2})' -f  $memusageMB, $memusagebyte, $difftext)

  # save last value in script global variable
  $script:last_memory_usage_byte = $memusagebyte
}