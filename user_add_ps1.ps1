# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv  C:\script\newusers.csv ";"

$password = 'Welkom2024!'

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {
    # Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $firstname = $User.voornaam
    $lastname = $User.achternaam
    $SecurityGroup = $User.SecurityGroep
    $OU = $User.ou

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "Er bestaat al een gebruiker genaamt: $username"
    }
    else {
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName "$firstname, $lastname" `
            -Path $OU `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        # als de gebruiker is aangemaakt zeg dit.
        Write-Host "De Gebruiker: $username is aangemaakt." 
    }
}
