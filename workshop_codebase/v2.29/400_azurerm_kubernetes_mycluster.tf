resource "azurerm_kubernetes_cluster" "my_cluster" {
    name                    = var.kbcluster_DKCKBCT01.kb_name
    location                = var.azure_region
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    dns_prefix              = var.kbcluster_DKCKBCT01.dns_prefix

    default_node_pool {
        name                = var.kbcluster_DKCKBCT01.np_name
        node_count          = var.kbcluster_DKCKBCT01.node_count
        vm_size             = var.kbcluster_DKCKBCT01.vm_size
    }

# first create a service principal, here is an example
# az ad sp create-for-rbac --skip-assignment --name myAKSClusterServicePrincipal
# grab the client_id and client_secret and paste in the azure.tf object structure for
# kbcluster_DKCKBCT01

# you can remove the service principal with the following in PowerShell AZ
# Remove-AzADServicePrincipal -DisplayName myAKSClusterServicePrincipal

# The following is important, and IS NOT properly documented at
# https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html 
    service_principal {
        client_id           = var.kbcluster_DKCKBCT01.client_id
        client_secret       = var.kbcluster_DKCKBCT01.client_secret
    }
}