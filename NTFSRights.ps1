Function Get-NTFSRights{
    [cmdletbinding()]

    #[OutputType(PSCustomObject)]
    Param(

        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({Test-Path -Path $PSItem -PathType Container -IsValid})]
        [string[]]$Folder,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({{Test-Path -Path $PSItem -IsValid}})]
        [string[]]$File,
        [switch]$Recurse,
        [switch]$Audit
    )

    #Si tu tentes d'accéder au répertoire, a-t-on les droits ? sinon renvoyer un message disant que tu n as pas les droits
    #choix entre l'API DOTNET ou import-module ?
    #Construire un splatting en fonction des informations qu'on a
    #Récupérer les ACLs
    #les afficher en console
    #Exporter le résultat dans un fichier excel avec ImportExcel ou CSV pour les linuxiens
    #splatting à tester si c'est un folder ou fichier
    $ACLCustom = [System.Collections.ArrayList]@()
    $Directories = Get-ChildItem -Path $Folder
    foreach($Directory in $Directories){
        $Acls = Get-Acl -Path $Directory.FullName
        foreach ($Acl in $Acls) {
            $obj = [PSCustomObject]@{
                FolderPath = $Directory.FullName
                Owner = $Acl.Owner
                NTFSRights = $Acl.AccessToString
            }
            $ACLCustom +=$obj
        }
        $ACLCustom | Export-Csv -Path C:\Users\fdofj\Desktop\report-acl.csv -NoTypeInformation
    }
}

Function Set-NTFSRights{
    [Cmdletbinding()]

    Param(
        #Vérification des droits en remote sur une machine
        #vérificaiton des droits en remote via jobs, runspaces ?
        # Parameter help description
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({Test-Path -Path $PSItem -PathType Container -IsValid})]
        [string[]]$Folder,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({{Test-Path -Path $PSItem -IsValid}})]
        [string[]]$File,
        #[Parameter()]
        [string[]]$Account,
        #[Parameter()]
        [string[]]$Rights = "Read",
        #[Parameter()]
        [string[]]$Permission = "Allow",
        [switch]$Recurse,
        [switch]$Audit
    )

    #splatting à tester si c'est un folder ou fichier
    $Acl = Get-Acl -Path $Folder
    $ACE =  New-Object Security.AccessControl.FileSystemAccessRule($Account, $Rights,"ContainerInherit, ObjectInherit","None",$Permission)
    $Acl.SetAccessRule($ACE)
    Set-Acl -Path $Folder -AclObject $Acl

}

Function Add-NTFSRights{
    [Cmdletbinding()]

    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        # Parameter help description
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({Test-Path -Path $PSItem -PathType Container -IsValid})]
        [string[]]$Folder,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({{Test-Path -Path $PSItem -IsValid}})]
        [string[]]$File,
        [switch]$Recurse,
        [switch]$Audit
    )

}

Function Remove-NTFSRights{
    [Cmdletbinding()]

    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        # Parameter help description
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({Test-Path -Path $PSItem -PathType Container -IsValid})]
        [string[]]$Folder,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({{Test-Path -Path $PSItem -IsValid}})]
        [string[]]$File,
        [switch]$Recurse,
        [switch]$Audit
    )


}
