Function Get-NTFSRights{
    [cmdletbinding()]

    #[OutputType(PSCustomObject)]
    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        # Parameter help description
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({Test-Path -Path $PSItem -PathType Container -IsValid})]
        [string[]]$Folder,
        #tester la presence du fichier et vérifier que c'est bien un fichier
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({{Test-Path -Path $PSItem -PathType Container -IsValid}})]
        [string[]]$File,
        #recurse ?
        [switch]$Recurse,
        #Récupère les SACL
        [switch]$Audit
    )

    #vérifier en amont que c'est un dossier ou un fichier
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
    [cmdletbinding()]

    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        #Vérification des droits en local sur une machine
        #Vérification des droits en remote sur une machine
        #vérificaiton des droits en remote via jobs, runspaces ?
        # Parameter help description
        [Parameter()]
        [ValidateScript()]
        [string]$Folder,
        [Parameter()]
        [ValidateScript()]
        [string[]]$Folders,
        #tester la presence du fichier et vérifier que c'est bien un fichier
        [Parameter()]
        [ValidateScript()]
        [string[]]$Files,
        [Parameter()]
        [ValidateScript()]
        [string]$File,
        #Récupère les SACLs
        [switch]$Audit
    )

}

Function Add-NTFSRights{
    [cmdletbinding()]

    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        # Parameter help description
        [Parameter()]
        [ValidateScript()]
        [string]$Folder,
        [Parameter()]
        [ValidateScript()]
        [string[]]$Folders,
        #tester la presence du fichier et vérifier que c'est bien un fichier
        [Parameter()]
        [ValidateScript()]
        [string[]]$Files,
        [Parameter()]
        [ValidateScript()]
        [string]$File,
        [switch]$Audit
    )

}

Function Remove-NTFSRights{
    [cmdletbinding()]

    Param(
        #tester la presence du repertoire et vérifier que c'est bien un repertoire
        # Parameter help description
        [Parameter()]
        [ValidateScript()]
        [string]$Folder,
        [Parameter()]
        [ValidateScript()]
        [string[]]$Folders,
        #tester la presence du fichier et vérifier que c'est bien un fichier
        [Parameter()]
        [ValidateScript()]
        [string[]]$Files,
        [Parameter()]
        [ValidateScript()]
        [string]$File,
        [switch]$Audit
    )


}
