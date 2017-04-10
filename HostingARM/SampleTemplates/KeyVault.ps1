$Secret = ConvertTo-SecureString -String 'Caviar!60062' -AsPlainText -Force





Set-AzureKeyVaultSecret -VaultName 'parks65keyvault' -Name ITSecret2 -SecretValue $Secret

$secret = Get-AzureKeyVaultSecret -VaultName parks65keyvault -Name ITSecret2

$secret.SecretValueText

$secret = Get-AzureKeyVaultSecret -VaultName parks65keyvault -Name adminPassword
$secret.SecretValueText




$key = Add-AzureKeyVaultKey -VaultName parks65keyvault -Name test1 -Destination Software


$secrets = Set-AzureKeyVaultSecret -VaultName parks65keyvault -Name test1 -SecretValue $Secret

$secret = Get-AzureKeyVaultSecret -VaultName parks65keyvault -Name test1

$secret.SecretValueText
