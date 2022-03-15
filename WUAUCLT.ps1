# Create the Object
$Obj = [PSCustomObject]@{    
    UpdateOrchestrator_LastSync = $null
    UpdateOrchestrator_LastSyncText = $null
    UpdateOrchestrator_LastInstall = $null
    UpdateOrchestrator_LastInstallText = $null
    UpdateOrchestrator_LastFailure = $null
    UpdateOrchestrator_LastFailureText = $null
    LogEntry = New-Object "System.Collections.Generic.List[psobject]"
    ObjTimeStamp = (get-date)
}
## Set the Log File
$LogFile = "C:\Windows\SoftwareDistribution\ReportingEvents.Log"
## Read the log and process it
$LogFileContents = Get-Content $LogFile
# Loop through each line in the file
foreach ($i in $LogFileContents) {
    # Process the each log line
    if ($i.StartsWith("{")) {
        $LogEntryObj = [PSCustomObject]@{
        Field1 = $i.Split("`t")[0]
        Field2 = $i.Split("`t")[1]
        Field3 = $i.Split("`t")[2]
        Field4 = $i.Split("`t")[3]
        Field5 = $i.Split("`t")[4]
        Field6 = $i.Split("`t")[5]
        Field7 = $i.Split("`t")[6]
        ErrorCode = $i.Split("`t")[7]
        Component = $i.Split("`t")[8] #  UpdateOrchestrator, Windows Defender Antivirus, etc.
        ActionResult = $i.Split("`t")[9] # Success, Failure
        Action = $i.Split("`t")[10] # Content Download, Content Install, Software Synchronization, etc.
        ActionResultText = $i.Split("`t")[11]
        Field13 = $i.Split("`t")[12]
        Date = $null
        }
        # Parse out the date with a regex
        if ($LogEntryObj.Field2 -match "(?<DateTime>\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d:\d\d\d).*") {
            $LogEntryObj.Date = [datetime]::ParseExact($Matches.DateTime,"yyyy-MM-dd HH:mm:ss:fff",$null)
        }
        # Get the last UpdateOrchestrator Sync
        if ($LogEntryObj.Component -eq "UpdateOrchestrator" -and $LogEntryObj.Action -eq "Software Synchronization" -and $LogEntryObj.ActionResult -eq "Success") {
            $Obj.UpdateOrchestrator_LastSync = $LogEntryObj.Date
            $Obj.UpdateOrchestrator_LastSyncText = $LogEntryObj.ActionResultText
        }
        # Get the last UpdateOrchestrator Last Install
        if ($LogEntryObj.Component -eq "UpdateOrchestrator" -and $LogEntryObj.Action -eq "Content Install" -and $LogEntryObj.ActionResult -eq "Success") {
            $Obj.UpdateOrchestrator_LastInstall = $LogEntryObj.Date
            $Obj.UpdateOrchestrator_LastInstallText = $LogEntryObj.ActionResultText
        }
        # Get the last UpdateOrchestrator Last Failure
        if ($LogEntryObj.Component -eq "UpdateOrchestrator" -and $LogEntryObj.Action -eq "Content Install" -and $LogEntryObj.ActionResult -eq "Failure") {
            $Obj.UpdateOrchestrator_LastFailure = $LogEntryObj.Date
            $Obj.UpdateOrchestrator_LastFailureText = $LogEntryObj.ActionResultText
        }
        # Add the Log Entry Object to the list
        $Obj.LogEntry.Add($LogEntryObj)
    }
}
# Return the Object
$Obj
