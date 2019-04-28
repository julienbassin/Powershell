Function Test-ExchangeValue {
    Param(
        [Hashtable]$Test,

        [Hashtable]$Remediate
    )
    $ParamTest = $Test.Parameter
    $ParamRem = $Remediate.Parameter
    if($Test.ContainsKey('PropertyToTest') -and $Test.PropertyToTest -ne $null){
        $Result = (& $Test.Command @ParamTest).$($Test.PropertyToTest)
    }Else{
        $Result = & $Test.Command @ParamTest
    }

    if ($Result -eq $Test.TestValue) {
        Write-Host 'Success !' -foregroudcolor Green
    }Else{
        Write-Host 'Remediate' -ForegroundColor Yellow
        & $Remediate.Command @ParamRem
    }

}

$Test = @{
    Command = '(((Get-TransportConfig).MaxReceiveSize -split  "\(")[0] -replace " ","")/1KB'
    Parameter = @{
        Name='Spooler'
    }
    PropertyToTest = 'Status'
    TestValue = '1024'
}

$Remediate = @{
    Command = 'Set-Service'
    Parameter = @{
        Name='Spooler'
        Status='Restart'
    }
}

Test-ExchangeValue -Test $Test -Remediate $Remediate