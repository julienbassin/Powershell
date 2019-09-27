Function Get-AccountName{
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$Principal
    )

    if($Principal -eq "*"){
        $sid = New-Object System.Security.Principal.SecurityIdentifier($principal.Substring(1))
        $sid.Translate([Security.Principal.NTAccount])
    }
    else{$Principal}
}

function Out-Object{
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Collections.Hashtable[]]
        $Hashtable
    )

    $order = @()
    $result = @{}
    $Hashtable | ForEach-Object {
        $order += ($_.Keys -as [array])[0]
        $result += $_
    }

    New-Object -TypeName psobject -Property $result | Select-Object $order
}

[String]$TemplateFilename = "C:\policies.cfg"
$StdOut = & SecEdit.exe /export /cfg $TemplateFilename /areas USER_RIGHTS
if($LASTEXITCODE -eq 0){
    Select-String '^(Se\S+) = (\S+)' $TemplateFilename | ForEach-Object{
            $Privilege = $_.Matches[0].Groups[1].Value
            $SIDs = $_.Matches[0].Groups[2].Value -split ","
            foreach($SID in $SIDs){
                Out-Object `
                @{"privilege"=$Privilege},
                @{"principal" = Get-AccountName $SID}
            }
    }
}
else {
    Write-Host "You do not have sufficient permissions to perform this command." -ForegroundColor Red
    Write-Host "Make sure that you are running as the local administrator or have opened the command prompt using the 'Run as administrator' option" -ForegroundColor red
}