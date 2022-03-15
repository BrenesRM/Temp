<#
.SYNOPSIS
	Get folder sizes in specified tree.  
.DESCRIPTION
	Script creates an HTML report with owner information, when created, 
	when last updated and folder size.
	
	Update the PARAM section to match your environment.
.PARAMETER Path
	Specify the path you wish to report on
.PARAMETER ReportPath
	Specify where you want the HTML report to be saved
.EXAMPLE
	.\Get-FolderSizes
	Run script and use defaults
.EXAMPLE
	.\Get-FolderSizes -Path "c:\Windows" -ReportPath "c:\Scripts"
	Run the script and report on all folers in C:\Windows.  Save the
	HTML report in C:\Scripts
.OUTPUTS
	FolderSizes.HTML in specified Report Path
.NOTES
	Author:         Martin Pugh
	Twitter:        @thesurlyadm1n
	Spiceworks:     Martin9700
	Blog:           www.thesurlyadmin.com
	
	Changelog:
        1.2         Added sort by folder size (biggest folders on top) and removed sub-
                    directory enumeration.
		1.1         Updated to use ComObject Scripting.FileSystemObject which
		            should increase performance.  Inspired by MS Scripting Guy
					Ed Wilson.
		1.0         Initial Release
.LINK
	
.LINK
	http://community.spiceworks.com/topic/286820-how-to-export-list-all-folders-from-drive-the-list-should-include
.LINK
	http://blogs.technet.com/b/heyscriptingguy/archive/2013/01/05/weekend-scripter-sorting-folders-by-size.aspx
#>	
Param (
	[string]$Path = ForEach ($Folder in (Get-ChildItem -Path $Path | Where { $_.PSisContainer })),
	[string]$ReportPath = "c:\utils"
)

Function AddObject {
	Param ( 
		$FileObject
	)
	$Size = [double]($FSO.GetFolder($FileObject.FullName).Size)
	$Script:TotSize += $Size
	If ($Size)
	{	$NiceSize = CalculateSize $Size
	}
	Else
	{	$NiceSize = "0.00 MB"
        $Size = 0
	}
	$Script:Report += New-Object PSObject -Property @{
		'Folder Name' = $FileObject.FullName
		'Created on' = $FileObject.CreationTime
		'Last Updated' = $FileObject.LastWriteTime
		Size = $NiceSize
        RawSize = $Size
		Owner = (Get-Acl $FileObject.FullName).Owner
	}
}

Function CalculateSize {
	Param (
		[double]$Size
	)
	If ($Size -gt 1000000000)
	{	$ReturnSize = "{0:N2} GB" -f ($Size / 1GB)
	}
	Else
	{	$ReturnSize = "{0:N2} MB" -f ($Size / 1MB)
	}
	Return $ReturnSize
}

cls
$Report = @()
$TotSize = 0
$FSO = New-Object -ComObject Scripting.FileSystemObject

#First get the properties of the starting path
$Root = Get-Item -Path $Path 
AddObject $Root

#Now loop through all the subfolders
ForEach ($Folder in (Get-ChildItem -Path $Path | Where { $_.PSisContainer }))
{	AddObject $Folder
}

#Create the HTML for our report
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<Title>
Folder Sizes for "$Path"
</Title>
"@

$TotSize = CalculateSize $TotSize

$Pre = "<h1>Folder Sizes for ""$Path""</h1><h2>Run on $(Get-Date -f 'MM/dd/yyyy hh:mm:ss tt')</h2>"
$Post = "<h2>Total Space Used In ""$($Path)"":  $TotSize</h2>"

#Create the report and save it to a file
$Report | Sort RawSize -Descending | Select 'Folder Name',Owner,'Created On','Last Updated',Size | ConvertTo-Html -PreContent $Pre -PostContent $Post -Head $Header | Out-File $ReportPath\FolderSizes.html

#Display the report in your default browser
& $ReportPath\FolderSizes.html