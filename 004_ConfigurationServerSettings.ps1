 [Cmdletbinding()]

 Param(
    [Parameter()]
    [string]$SourcePath = "C:\DSC\Certificates",
    [Parameter()]
    [string]$DestinationPath = "C:\DSC\Certificates" 
 
 )
 
 Configuration ConfigurationExchangerServerSettings {

    #copy certificates .PFX source to destination path



 }