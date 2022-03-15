#
#.SYNOPSIS
#Creates SP Dispose report on all WSP's
#
#.EXAMPLE
#.\Get-SPDisposeReport.ps1 
#

Add-PSSnapin Microsoft.SharePoint.PowerShell  -erroraction SilentlyContinue


#Variables
$wspdir = "D:\WSP\WSPReport1" #Location to export all WSP's
$exportdir = "$wspdir\Export-$((get-date).toString('yyyyMMdd'))\"
$CSVLocation = "$wspdir\SPDisposeResults.csv"

#create directory
[IO.Directory]::CreateDirectory($wspdir)


#Function to export all WSP's
function Export-AllWSPs
{
	Write-Host Exporting solutions to $wspdir 
	foreach ($solution in Get-SPSolution) 
	{ 
	    $id = $Solution.SolutionID 
	    $title = $Solution.Name 
	    $filename = $Solution.SolutionFile.Name
	    Write-Host "Exporting $title to ¦\$filename" -nonewline 
	    try { 
	        $solution.SolutionFile.SaveAs("$wspdir\$filename") 
	        Write-Host "– done" -foreground green 
	    } 
	    catch 
	    { 
	        Write-Host "– error : $_" -foreground red 
	    } 
	}

}

#Function to extract all WSP Packages
function Extract-AllWSPs
{
	#Retrieve the wsp files in this folder and subfolders
	$s = [system.IO.SearchOption]::AllDirectories
	$fileEntries = [IO.Directory]::GetFiles($wspdir,"*.wsp",$s); 
	foreach($fullFileName in $fileEntries) 
	{ 
		$fileName = $(Get-Item $fullFileName).Name;
	 	$dirName =  $fileName.Replace(".wsp","");
		$extractPath = $exportdir + $dirName;
	 	$dir = [IO.Directory]::CreateDirectory($extractPath) 

		#uncab
		Write-Host "Export $fileName started" -ForegroundColor Red
		$destination = $extractPath
		C:\Windows\System32\extrac32.exe $fullFileName /e /Y /L $destination
	}

}


#Function to get Assembly details
function Get-AssemblyCustomProperty
    {
        param
        (
            $assembly,
            $TypeNameLike,
            $Property = $null
        )
        
        $value = $null
        foreach ($attribute in $assembly.GetCustomAttributes($false))
        {
            if ($attribute.GetType().ToString() -like "*$TypeNameLike*")
            {
                if ($Property -ne $null)
                {
                    # Select-Object -ExpandProperty fails if property value is $null
                    try {
                        $value = $attribute | Select-Object -ExpandProperty $Property
                    }
                    catch {
                        $value = $null
                    }
                }
                else
                {
                    $value = $attribute
                }
                break;
            }
        }
        
        $value
    }


#Function to report SP Dispose check results
Function Get-SPDisposeResults()
{

	#Pause for 5 secs to ensure extract is complete
	Start-Sleep -s 5
	$Dir = get-childitem $wspdir -recurse
	$List = $Dir | where {$_.extension -eq ".dll"}
	$List | ForEach-Object {
		
		 [string]$report = & "C:\Program Files (x86)\Microsoft\SharePoint Dispose Check\SPDisposeCheck.exe" $_.fullname 
		 #remove repetitive strings
		 $report = $report -replace "Note: This tool may report errors which are not actually memory leaks, otherwise known as false positives. Further investigation should be done to identify and correct real errors. It is designed to assist developers in making sure their code adheres to best practices for memory allocation when using SharePoint APIs. Please see the following for more information: http://blogs.msdn.com/rogerla/ http://msdn2.microsoft.com/en-us/library/aa973248.aspx http://msdn2.microsoft.com/en-us/library/bb687949.aspx", ""
		 $build = "RELEASE";
		 try {
		 		$info = @{}
				$assembly = [Reflection.Assembly]::LoadFile($_.FullName)
     			$attr = $assembly.GetCustomAttributes([Diagnostics.DebuggableAttribute], $false)
				$info.IsJITTrackingEnabled = Get-AssemblyCustomProperty -Assembly $assembly -TypeNameLike 'System.Diagnostics.DebuggableAttribute' -Property 'IsJITTrackingEnabled'
        		#$info.IsJITOptimizerDisabled = Get-AssemblyCustomProperty -Assembly $assembly -TypeNameLike 'System.Diagnostics.DebuggableAttribute' -Property 'IsJITOptimizerDisabled'
        		#$info.DebuggingFlags = Get-AssemblyCustomProperty -Assembly $assembly -TypeNameLike 'System.Diagnostics.DebuggableAttribute' -Property 'DebuggingFlags'
     			#Write-Host $_.FullName: +" IsJITTrackingEnabled "+ $info.IsJITTrackingEnabled
				#Write-Host $_.FullName: +" IsJITOptimizerDisabled "+ $info.IsJITOptimizerDisabled
				#Write-Host $_.FullName: +" DebuggingFlags "+ $info.DebuggingFlags
				
       		 } catch {
			 throw $_
			 }
		 
		 Write-Host $report
		
		# Create a hash table with all the data
			     $hash = @{
			        "Solution" = $_.Directory.Name
					"Assembly" =  $_.name
					"Report"  = $report
					"Debug Mode enabled" = $info.IsJITTrackingEnabled
				
			            } 
			    # Convert the hash to an object and output to the pipeline 
				New-Object PSObject -Property $hash
	}
}


#Function calls
Export-AllWSPs
Extract-AllWSPs
Get-SPDisposeResults | Export-Csv -NoTypeInformation -Path $CSVLocation