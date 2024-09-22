# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv Z:\Data\NewUsers\newusers.csv ";"

$password = 'Welcome@2023!'
$basePath = "\\WVDOMP01\HomeFolders$"

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
            -HomeDirectory \\WVDOMP01\HomeFolders$\$Username -homedrive 'H:' `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        Add-ADGroupMember -Identity $SecurityGroup -Members $username

        # Create the home folder for the user
        $homeFolderPath = "$basePath\$username"
        New-Item -ItemType Directory -Path $homeFolderPath

        # Set permissions on the home folder to allow the user full control
        $Acl = Get-Acl $homeFolderPath
        $Ar = New-Object  System.Security.AccessControl.FileSystemAccessRule($username,"FullControl","Allow")
        $Acl.SetAccessRule($Ar)
        Set-Acl $homeFolderPath $Acl

        # als de gebruiker is aangemaakt zeg dit.
        Write-Host "De Gebruiker: $username is aangemaakt." 
    }
}