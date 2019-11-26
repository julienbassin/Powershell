####################################################################################
#.Synopsis 
#    List members of a local group on a remote computer.
#
#.Parameter ComputerName 
#    Name of the local or remote computer.  Defaults to the local computer.
#    Can be an array of computer names instead of just one name.
#
#.Parameter LocalGroupName
#    Name of the local group whose membership is to be listed.  If the group
#    name contains spaces, use quotes.  Defaults to Administrators.
#
#.Parameter CommaSeparatedOutput
#    Outputs a comma-delimited string for each group member instead of one 
#    object per computer with a an array of members as a property.
#
#Requires -Version 3.0 
#
#.Notes 
#  Author: Julien Bassin 
# Version: 0.1
# Updated: 23.11.2019
####################################################################################

Param ([String[]]$ComputerName = "$env:ComputerName", $LocalGroupName = "Administrators", [Switch] $CommaSeparatedOutput) 

function Get-ADSILocalGroupMember {
    [CmdletBinding()]
    param (
        [Parameter()]
            [string[]]
            $ComputerName = "$env:ComputerName",
            
            [Parameter()]
            [string[]] 
            $LocalGroupName = "Administrators"            
    )
    
    begin {
        $ListLocalGroup = [System.Collections.ArrayList]@()
        $errorActionPreference="SilentlyContinue"
        #Check if account is disabled or not 
        #New-Variable ADS_UF_ACCOUNTDISABLE 0x0002 -Option Constant
        if ($PSBoundParameters.ContainsKey("ComputerName")) {
            $Connexion = Invoke-Command -ComputerName $ComputerName -Credential (Get-Credential)
        }
        else {
            $Connexion = [ADSI]"WinNT://$($ComputerName)"
        }
        
    }
    
    process {

        $LocalGroups = $Connexion.psbase.Children | Where-Object {$_.psbase.schemaCLassName -eq "group"}
        foreach($LocalGroup in $LocalGroups){
            $Members = @($LocalGroup.psbase.Invoke("Members"))
            foreach ($Member in $Members) {
                $Class = $Member.GetType().InvokeMember("Class", 'GetProperty', $Null, $Member, $Null)
                $Name = $Member.GetType().InvokeMember("Name", 'GetProperty', $Null, $Member, $Null)
                $Description =  $Member.GetType().InvokeMember("Description", 'GetProperty', $Null, $Member, $Null)
                <#if($flag -band $ADS_UF_ACCOUNTDISABLE){
                    $Disabled = $true
                }#>
            }
            $Object = [PSCustomObject][Ordered]@{
                ComputerName = $ComputerName
                LocalGroup = $LocalGroup.Name
                Member = $Name
                Description = $Description
                Type = $Class
            }
            $ListLocalGroup.Add($Object)
        }        
    }
    
    end{
        $ListLocalGroup
    }
}