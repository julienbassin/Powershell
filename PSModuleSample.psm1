Function Test-Module{
    [CmdletBinding()]
    # Parameter help description
    Param(
        [Parameter(Mandatory=$false)]
        [string]
        $name = "world"
    )

    return "hello $name"
}

Export-ModuleMember -Function Test-Module