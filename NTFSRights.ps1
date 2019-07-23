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

    $Directories = Get-ChildItem -Path $Folders
    foreach($Directory in $Directories){
        $Acls = Get-Acl -Path $Directory.FullName
        foreach ($Acl in $Acls) {
            $obj = [PSCustomObject]@{
                FolderPath = $Directory.FullName
                Owner = $Acl.Owner
                NTFSRights = $Acl.AccessToString
            }
        }
        $obj
    }
}

Function Set-NTFSRights{
    [Cmdletbinding()]

    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        #Vérification des droits en local sur une machine
        #Vérification des droits en remote sur une machine
        #vérificaiton des droits en remote via jobs, runspaces ?
        # Parameter help description
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({Test-Path -Path $PSItem -PathType Container -IsValid})]
        [string[]]$Folder,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({{Test-Path -Path $PSItem -IsValid}})]
        [string[]]$File,
        [switch]$Recurse,
        #Récupère les SACLs
        [switch]$Audit
    )

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
