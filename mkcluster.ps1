# Script to (re)create the k8s cluster in Vagrant
param ([Switch] $recreate = $false)

if ($recreate -eq $true) {
    Write-Host "Destroying controllers and workers" -ForegroundColor Cyan
    vagrant destroy --force control-1 worker-1 worker-2
}

Write-Host "Creating cluster" -ForegroundColor Cyan
vagrant up
