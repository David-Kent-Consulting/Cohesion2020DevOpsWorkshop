# login to Azure
az login

# set subscription context
az account \
--subscription "your subscription name goes here"

# Create the resource group
az group create --location "centralus" \
--name "TEST_rg"

# Create the vnet and subnets
az network vnet create --name "TEST_vnet" \
--address-prefix "172.16.0.0/16" \
--location "centralus" \
--resource-group "TEST_rg"

az network vnet subnet create \
--name "TEST_rg_172_16_0_0_24" \
--resource-group "TEST_rg" \
--vnet-name "TEST_vnet" \
--address-prefixes "172.16.0.0/24"

az network vnet subnet create \
--name "TEST_rg_172_16_1_0_24" \
--resource-group "TEST_rg" \
--vnet-name "TEST_vnet" \
--address-prefixes "172.16.1.0/24"

# Create the network security group and add inbound ssh
# rule
az network nsg create \
--name "TEST_nsg" \
--resource-group TEST_rg
az network nsg rule create \
--name "inboundSshFromInternet" \
--priority 100 \
--nsg-name "TEST_nsg" \
--resource-group "TEST_rg" \
--access "Allow" \
--description "Allow inbound SSH from the internet" \
--direction "Inbound" \
--protocol "Tcp" \
--source-address-prefixes "0.0.0.0/0" \
--source-port-ranges "*"

# Create a public load balancer
az network lb create \
--name "TEST_lb" \
--resource-group "TEST_rg" \
--location "centralus" \
--sku "Basic" \
--vnet-name "TEST_vnet" \
--subnet "TEST_rg_172_16_1_0_24" \
--subnet-address-prefix "172.16.1.0/24" \
--public-ip-address-allocation "Static"

# Create a storage account
az storage account create \
--name "teststgact498422" \
--resource-group "TEST_rg" \
--location "centralus" \
--sku "Standard_GRS"

# Create a managed disk from a RHEL image
az disk create \
--name "DKCESMT01_OsDisk_00" \
--resource-group "TEST_rg" \
--image-reference "RedHat:RHEL:7-LVM:latest" \
--size-gb 100

# Create the VM's NIC
az network nic create \
--name "DKCESMT01_nic01" \
--resource-group "TEST_rg" \
--subnet "TEST_rg_172_16_0_0_24" \
--vnet-name "TEST_vnet" \
--location "centralus"

az network nic update \
--name "DKCESMT01_nic01" \
--resource-group "TEST_rg" \
--network-security-group "TEST_nsg"

# Create the VM
az vm create \
--name "DKCESMT01" \
--resource-group "TEST_rg" \
--location "centralus" \
--attach-os-disk "DKCESMT01_OsDisk_00" \
--computer-name "DKCESMT01" \
--location "centralus" \
--nics "DKCESMT01_nic01" \
--os-type "Linux" \
--size "Standard_B2ms"

# Enable boot diagnostics
az vm boot-diagnostics enable \
--name "DKCESMT01" \
--resource-group "TEST_rg" \
--storage "teststgact498422"

# Create and assign a public IP to the VM
az network public-ip create \
--name "DKCESMT01_pubip" \
--resource-group "TEST_rg" \
--allocation-method "Dynamic" \
--sku "Basic"
# note ipconfig1 is the default ipconfig name Azure
# assigns to a NIC
az network nic ip-config update \
--name "ipconfig1" \
--nic-name "DKCESMT01_nic01" \
--resource-group "TEST_rg" \
--public-ip-address "DKCESMT01_pubip"

# create the vault, carefule, still in preview and flakey
# georedundant storage is the default
az backup vault create \
--name "testrgasrvault748654" \
--resource-group "TEST_rg" \
--location "centralus"

# enable backup protection for the VM, this is also in
# preview. Using diskslists will implicitly create a
# disk exclusion mask, good for database VMs.
az backup protection enable-for-vm \
--policy-name "DefaultPolicy" \
--vm "DKCESMT01" \
--diskslist "DKCESMT01_OsDisk_00" \
--vault-name "testrgasrvault748654" \
--resource-group "TEST_rg"

# Get KC versions available in region
az aks get-versions \
--location "centralus"

az aks create \
--name "DKCKBC01" \
--resource-group "TEST_rg" \
--enable-aad \
--kubernetes-version "1.18.8" \
--location "centralus" \
--node-count 3 \
--no-ssh-key \
--node-vm-size "Standard_B2ms"

# tear it down
az aks delete --name "DKCKBC01" --resource-group "TEST_rg"

# in AZ Powershell because it is easier to do

# WARNING! WARNING! WARNING! WARNING! WARNING! 
# Don't do in production, very dangerous
# WARNING! WARNING! WARNING! WARNING! WARNING! 
$myVault = Get-AzRecoveryServicesVault -ResourceGroupName test_rg
Get-AzRecoveryServicesVaultProperty -VaultId $myVault.id
Set-AzRecoveryServicesVaultProperty -VaultId $myVault.id -SoftDeleteFeatureState "Disable"
Remove-AzRecoveryServicesVault -Vault $myVault
Remove-AzResourceGroup -Name "TEST_rg"