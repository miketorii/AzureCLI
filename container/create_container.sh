#################################
# Create Resource Group
az group create --name ContainerResGrp --location japaneast

#################################
# Create App Environment
az containerapp env create --name my-environment --resource-group ContainerResGrp --location japaneast

az containerapp create --name my-container-app --resource-group ContainerResGrp --environment my-environment --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest --target-port 80 --ingress 'external' --query properties.configuration.ingress.fqdn


#################################
# Delete resource group

#az group delete --name ContainerResGrp


