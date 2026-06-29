[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
param()

$ResourceGroupName = "rg-automation-westus"
$Location          = "westus"
$VmSize            = "Standard_D2s_v3"
$ImageName         = "Canonical:ubuntu-24_04-lts:server:latest"
$VmList            = @("ubuntu-automation-vm")

Connect-AzAccount -Identity

if ($null -eq (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force
}

foreach ($VmName in $VmList) {
    $RandomPassword = ConvertTo-SecureString -String ("P@ss!" + (Get-Random -Minimum 100000 -Maximum 999999) + "Bld!") -AsPlainText -Force
    $VmCredential = New-Object System.Management.Automation.PSCredential ("azureuser", $RandomPassword)

    $vmParams = @{
        ResourceGroupName = $ResourceGroupName
        Location          = $Location
        Name              = $VmName
        ImageName         = $ImageName
        Size              = $VmSize
        Credential        = $VmCredential
    }
    New-AzVM @vmParams
}
# Testing the CI pipeline automation
