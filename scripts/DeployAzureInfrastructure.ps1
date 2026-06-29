# Define Variables matching your selected settings
$ResourceGroupName = "rg-automation-westus"
$Location          = "westus"
$VmSize            = "Standard_D2s_v3"
$ImageName         = "Canonical:ubuntu-24_04-lts:server:latest"
$VmList            = @("ubuntu-automation-vm")

Write-Host "🚀 Starting End-to-End Azure Automation..." -ForegroundColor Cyan

# 1. Conditional Statement: Check and Create Resource Group
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if ($null -eq $rg) {
    Write-Host "Creating Resource Group: $ResourceGroupName in $Location..." -ForegroundColor Yellow
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force
} else {
    Write-Host "Resource Group $ResourceGroupName already exists." -ForegroundColor Green
}

# 2. Automation Task: Provision Virtual Machine Infrastructure using a LOOP
foreach ($VmName in $VmList) {
    Write-Host "Loop Processing: Provisioning Network and VM ($VmName) of size $VmSize..." -ForegroundColor Yellow

    # Corrected parameters map (Removed the invalid GeneratePassword property)
    $vmParams = @{
        ResourceGroupName = $ResourceGroupName
        Location          = $Location
        Name              = $VmName
        Image             = $ImageName
        Size              = $VmSize
    }

    New-AzVM @vmParams
}

Write-Host "✅ Loop finished. Deployment Completed Successfully!" -ForegroundColor Green
