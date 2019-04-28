if(-not(find-module -Name pester)){
    "Installer Pester en premier !"
    return 0
}
try {
    [PSCredential]$LiveCred = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://ex1/powershell/ -Credential $LiveCred -Authentication Kerberos
    Import-PSSession $Session
}
catch {
    Write-Output "Connexion impossible $($error.Exception.Message)"
}



[string[]]$ExchangeServers = (Get-ExchangeServer).Name
[string]$MailBoxDatabase = (Get-MailboxDatabase).Name


Describe -name '1.2 Maximum Receive size - connector level'{
    Context -Name "Testing size Receive connector"{
        it -Name "Check if connector level is to 10240"{
            (((Get-TransportConfig).MaxReceiveSize -split  "\(")[0] -replace " ","")/1KB | Should be 10240
        }
}

Describe -name '1.5 Configure Sender Filtering'{
    Context -Name "Testing Sender Filtering" {
        it -Name "Checking if Sender Filtering is enabled"{
            (Get-SenderFilterConfig).enabled | should be $true
        }
}

Describe -name '1.7 Maximum number of recipients - organization level'{
    Context -Name "Testing Maximum number of recipients - organization level" {
        it -Name "Checking Maximum number of recipients - organization level is set to 5000"{
            (Get-TransportService -Identity $EXSRV).PickupDirectoryMaxRecipientsPerMessage | should be 5000
        }
}

Describe -name '1.9 Configure login authentication for POP3'{
    Context -Name "Testing login authentication for POP3" {
        it -Name "Checking login authentication for POP3 is set to Secure Login"{
            (Get-PopSettings).LoginType | should be 'SecureLogin'
        }
    }

<#
Describe -name '1.12 External send connector authentication: Domain Security'{
    Context -Name "Testing External send connector authentication: Domain Security" {
        it -Name "Checking External send connector authentication: Domain Security is enabled"{
            (get-sendconnector -Identity $exsrv).DomainSecureEnabled | should be $true
        }
    }


Describe -name '1.13 Message tracking logging - Transport'{
    Context -Name "Testing Message tracking logging - Transport" {
        it -Name "Checking ig Message tracking logging - Transport is enabled"{
            (Get-TransportService $EXSRV).MessageTrackingLogEnabled | should be $true
        }
    }


Describe -name '1.14 Message tracking logging - Mailbox'{
    Context -Name "Testing Message tracking logging - Mailbox" {
        it -Name "Checking if Message tracking logging - Mailbox is enabled"{
            (Get-TransportService $EXSRV).MessageTrackingLogEnabled | should be $true
        }
    }

Describe -name '1.15 Configure login authentication for IMAP4'{
    Context -Name "Testing login authentication" {
        it -Name "Checking if login authentication is enabled"{
            (Get-ImapSettings).LoginType | should be 'SecureLogin'
        }
    }


Describe -name '1.17 Maximum send size - organization level '{
    Context -Name "Testing Maximum send size" {
        it -Name "Checking if Maximum send size is set to 10240"{
            (((Get-TransportConfig ).MaxSendSize -split  "\(")[0] -replace " ","")/1KB | Should be 10240
        }
    }


Describe -name '1.18 Maximum receive size - connector level'{
    Context -Name "Testing Maximum receive size" {
        it -Name "Checking if Maximum receive size is set to 10240"{
            (((Get-ReceiveConnector "Connection from Contoso.com").MaxMessageSize -split  "\(")[0] -replace " ","")/1KB | should be 10240
        }
    }

                <#
Describe -name '1.19 Mailbox quotas: Issue warning at to 1991680'{
    Context -Name "Testing Mailbox quotas: Issue warning" {
        it -Name "Checking if Mailbox quotas: Issue warning is set to 1991680 "{
            (((Get-MailboxDatabase $mailBoxDatabase).IssueWarningQuota -split  "\(")[0] -replace " ","")/1KB | should be 1991680
        }
    }
} #>

<#
Describe -name '1.20 Mailbox quotas: Prohibit send and receive at to 2411520'{
    Context -Name "Testing Mailbox quotas: Prohibit send and receive" {
        it -Name "Checking if Mailbox quotas: Prohibit send and receive"{
            (((Get-MailboxDatabase $mailBoxDatabase).ProhibitSendReceiveQuota -split  "\(")[0] -replace " ","")/1KB | Should be 2411520
        }
    }
} #>

Describe -name '1.21 Mailbox quotas: Prohibit send at to 2097152 '{
    Context -Name "Testing Mailbox quotas: Prohibit send" {
        it -Name "Checking if Mailbox quotas: Prohibit send"{
            (((Get-MailboxDatabase $mailBoxDatabase).ProhibitSendQuota -split  "\(")[0] -replace " ","")/1KB | should be 2097152
        }
    }

Describe -name '1.22 Keep deleted mailboxes for the specified number of days to 30'{
    Context -Name "Testing deleted mailboxes for the specified number of days to 30" {
        it -Name "Checking if deleted mailboxes for the specified number of days to 30"{
            (Get-Mailboxdatabase $mailBoxDatabase).MailboxRetention | should be '30.00:00:00'
        }
    }

Describe -name '1.23 Do not permanently delete items until the database has been backed up'{
    Context -Name "Testing delete items until the database has been backed up" {
        it -Name "Checking if delete items until the database has been backed up to True"{
            (Get-MailboxDatabase $mailBoxDatabase).RetainDeletedItemsUntilBackup | should be $true
        }
    }

Describe -name '1.24 Allow simple passwords'{
    Context -Name "Testing Allow simple passwords" {
        it -Name "Checking if Allow simple passwords is disabled"{
            (Get-MobileDeviceMailboxPolicy).AllowSimplePassword | should be $false
        }
    }


Describe -name '1.25 Enforce Password History'{
    Context -Name "Testing Enforce Password History" {
        it -Name "Checking if Enforce Password History is set to 4 or greater"{
            (Get-MobileDeviceMailboxPolicy).PasswordHistory
        }
    }

Describe -name '1.26 Password Expiration to 90'{
    Context -Name "Testing Password Expiration to 90" {
        it -Name "Checking if Password Expiration to 90"{
            (Get-MobileDeviceMailboxPolicy).PasswordExpiration | Should be '90.00:00:00'
        }
    }

Describe -name '1.27 Minimum password length to 4 or greater'{
    Context -Name "Testing Minimum password length to 4 or greater" {
        it -Name "Checking if Minimum password length to 4 or greater"{
            (Get-MobileDeviceMailboxPolicy).MinPasswordLength | should be 4
        }
    }
Describe -name '1.29 Refresh interval to 1'{
    Context -Name "Testing Refresh interval" {
        it -Name "Checking Refresh interval to 1"{
            (Get-MobileDeviceMailboxPolicy -Identity default).DevicePolicyRefreshInterval | should be '01:00:00'
        }
    }

Describe -name '1.32 Retain deleted items for the specified number of days to 14'{
    Context -Name "Testing deleted items for the specified number of days to 14" {
        it -Name "Checking if deleted items for the specified number of days to 14"{
            (Get-MailboxDatabase -Identity $mailBoxDatabase).DeletedItemRetention | should be '14.00:00:00'
        }
    }

Describe -name '1.33 Allow unmanaged devices'{
    Context -Name "Testing Allow unmanaged devices" {
        it -Name "Checking if unmanaged devices is disabled"{
            (Get-MobileDeviceMailboxPolicy -Identity default).AllowNonProvisionableDevices | should be $false
        }
    }


Describe -name '1.34 Require encryption on device'{
    Context -Name "Testing Require encryption on device" {
        it -Name "Checking if encryption on device is enabled"{
            (Get-MobileDeviceMailboxPolicy -Identity default).RequireDeviceEncryption | should be $true
        }
    }

Describe -name '1.35 Time without user input before password must be re-entered to 15'{
    Context -Name "Time without user input before password must be re-entered to 15" {
        it -Name "Checking if time without user input before password must be re-entered to 15"{
            (Get-MobileDeviceMailboxPolicy -Identity Default).MaxInactivityTimeLock | should be '00:15:00'
        }
    }

Describe -name '1.36 Require alphanumeric password'{
    Context -Name "Testing alphanumeric password" {
        it -Name "Checking alphanumeric password is enabled"{
            (Get-MobileDeviceMailboxPolicy -Identity Default).AlphanumericPasswordRequired
        }
    }

Describe -name '1.37 Require client MAPI encryption '{
    Context -Name "Testing client MAPI encryption" {
        it -Name "Checking if client MAPI encryption"{
            (Get-RpcClientAccess).EncryptionRequired | should be $true
        }
    }


Describe -name '1.38 Number of attempts allowed to 10 '{
    Context -Name "Testing Number of attempts allowed" {
        it -Name "Checking if Number of attempts allowed is set to 10"{
            (Get-MobileDeviceMailboxPolicy -Identity Default).MaxPasswordFailedAttempts
        }
    }

Describe -name '1.39 Require password'{
    Context -Name "Testing Require password" {
        it -Name "Checking if Require password is enabled"{
            (Get-MobileDeviceMailboxPolicy -Identity Default).PasswordEnabled | should be $true
        }
    }

Describe -name '1.41 Require Client Certificates'{
    Context -Name "Testing Require Client Certificates" {
        it -Name "Checking if Require Client Certificates set to Required"{
            'Please refer to the URL in the References provide in CIS Guide'
        }
    }

Describe -name '1.42 script execution to RemoteSigned'{
    Context -Name "Testing script execution" {
        it -Name "Checking if script execution is set to RemoteSigned"{
            Get-ExecutionPolicy |should be 'RemoteSigned'
        }
    }

Describe -name '1.43 Turn on Administrator Audit Logging'{
    Context -Name "Testing Administrator Audit Logging" {
        it -Name "Checking if Administrator Audit Logging is enabled"{
            (Get-AdminAuditLogConfig).AdminAuditLogEnabled | should be $true
        }
    }

Describe -name '1.44 automatic replies to remote domains'{
    Context -Name "Testing automatic replies to remote domains" {
        it -Name "Checking if automatic replies to remote domains is enabled"{
            (Get-RemoteDomain -Identity Default).AutoReplyEnabled | should be $false
        }
    }

<#Describe -name '1.46 non-delivery reports to remote domains'{
    Context -Name "Testing non-delivery reports to remote domains" {
        it -Name "Checking if non-delivery reports to remote domains"{
            (Get-RemoteDomain -Identity $domain).NDREnabled | should be $false
        }
    }
}#>

<#Describe -name '1.47 OOF messages to remote domains '{
    Context -Name "Testing OOF messages to remote domains" {
        it -Name "Checking if OOF messages to remote domains is set to None"{
            (Get-RemoteDomain "RemoteDomain").AllowedOOFType | should be 'None'
        }
    }
}#>

<#Describe -name '1.48 automatic forwards to remote domains'{
    Context -Name "Testing automatic forwards to remote domains" {
        it -Name "Checking if automatic forwards to remote domains is disabled"{
            (Get-RemoteDomain -Identity $domain).AutoForwardEnabled | should be $false
        }
    }
}#>