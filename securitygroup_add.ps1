# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$groups = Import-Csv  C:\script\group.csv ";"

# Loop through each row containing user details in the CSV file
foreach ($group in $groups) {
    # Read user data from each field in each row and assign the data to a variable as below
    $name = $Group.Name
    $groupscope = $Group.GroupScope
    $groupcategory = $Group.GroupCategory
    $OU = $Group.OU

    New-ADGroup `
         -Name $name `
         -GroupScope $groupscope `
         -GroupCategory $groupcategory `
         -Path $OU `

        
    }
