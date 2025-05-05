
# Shared Mailbox Access Report

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName admin@yourdomain.com

# Get all shared mailboxes
$mailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited

foreach ($mbx in $mailboxes) {
    $perms = Get-MailboxPermission -Identity $mbx.Identity | Where-Object {
        $_.User -notlike "NT AUTHORITY\SELF" -and $_.AccessRights -like "*FullAccess*"
    }

    foreach ($perm in $perms) {
        [PSCustomObject]@{
            SharedMailbox = $mbx.DisplayName
            UserWithAccess = $perm.User
            AccessRights = $perm.AccessRights -join ', '
        }
    }
}
