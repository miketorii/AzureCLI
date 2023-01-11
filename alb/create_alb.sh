#################################
# Create Resource Group
az group create --name PubLBResGrp --location japaneast

#################################
# Create Virtual Network
echo "create vnet"
az network vnet create --resource-group PubLBResGrp --location japaneast --name myVNet --address-prefixes 10.1.0.0/16 --subnet-name myBackendSubnet --subnet-prefixes 10.1.0.0/24 

#################################
# Create Public IP

echo "create public-ip"
az network public-ip create --resource-group PubLBResGrp --name myPublicIP --sku Standard --zone 1 2 3
#az network public-ip create --resource-group PubLBResGrp --name myPublicIP --sku Standard --zone 1

#################################
# Create Load Balancer
echo "create lb"
az network lb create --resource-group PubLBResGrp --name myLoadBalancer --sku Standard --public-ip-address myPublicIP --frontend-ip-name myFrontEnd --backend-pool-name myBackEndPool

echo "create lb probe"
az network lb probe create --resource-group PubLBResGrp --lb-name myLoadBalancer --name myHealthProbe --protocol tcp --port 80

echo "create lb rule"
az network lb rule create --resource-group PubLBResGrp --lb-name myLoadBalancer --name myHTTPRule --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name myFrontEnd --backend-pool-name myBackEndPool --probe-name myHealthProbe --disable-outbound-snat true --idle-timeout 15 --enable-tcp-reset true

#################################
# Create Network Security Group
echo "create nsg"
az network nsg create --resource-group PubLBResGrp --name myNSG

echo "create nsg rule"
az network nsg rule create --resource-group PubLBResGrp --nsg-name myNSG --name myNSGRuleHTTP --protocol '*' --direction inbound --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 --access allow --priority 200

#################################
# Create bastion
echo "create public ip zone123"
az network public-ip create --resource-group PubLBResGrp --name myBastionIP --sku Standard --zone 1 2 3
#az network public-ip create --resource-group PubLBResGrp --name myBastionIP --sku Standard --zone 1

echo "create vnet subnet"
az network vnet subnet create --resource-group PubLBResGrp --name AzureBastionSubnet --vnet-name myVNet --address-prefixes 10.1.1.0/27

echo "create basion"
az network bastion create --resource-group PubLBResGrp --name myBastionHost --public-ip-address myBastionIP --vnet-name myVNet --location japaneast

#################################
# Create backend server
echo "create 2 nic"

array=(myNicVM1 myNicVM2)
for vmnic in "${array[@]}"
do
    az network nic create --resource-group PubLBResGrp --name $vmnic --vnet-name myVNet --subnet myBackendSubnet --network-security-group myNSG
done

echo "create vm1"
az vm create --resource-group PubLBResGrp --name myVM1 --nics myNicVM1 --image win2019datacenter --admin-username azureuser --zone 1 --no-wait
echo "create vm2"
az vm create --resource-group PubLBResGrp --name myVM2 --nics myNicVM2 --image win2019datacenter --admin-username azureuser --zone 2 --no-wait

echo "2 nic add address pool"
array=(myNicVM1 myNicVM2)
for vmnic in "${array[@]}"
do
    az network nic ip-config address-pool add --address-pool myBackEndPool --ip-config-name ipconfig1 --nic-name $vmnic --resource-group PubLBResGrp --lb-name myLoadBalancer
done

#################################
# Create NAT gateway

echo "create public-ip"
az network public-ip create --resource-group PubLBResGrp --name myNATgatewayIP --sku Standard --zone 1 2 3
#az network public-ip create --resource-group PubLBResGrp --name myNATgatewayIP --sku Standard --zone 1

echo "create nat gateway"
az network nat gateway create --resource-group PubLBResGrp --name myNATgateway --public-ip-addresses myNATgatewayIP --idle-timeout 10

echo "update vnet subnet"
az network vnet subnet update --resource-group PubLBResGrp --vnet-name myVNet --name myBackendSubnet --nat-gateway myNATgateway

#################################
# Install IIS
echo "install IIS to 2 vm"
array=(myVM1 myVM2)
for vm in "${array[@]}"
do
    az vm extension set --publisher Microsoft.Compute --version 1.8 --name CustomScriptExtension --vm-name $vm --resource-group PubLBResGrp --settings '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
done

#array=(myVM1 myVM2)
#for vm in "${array[@]}"
#do
#    az vm extension set --publisher Microsoft.Compute --version 1.8 --name CustomScriptExtension --vm-name $vm --resource-group PubLBResGrp --settings '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
#done

#################################
# Test Load Balancer
echo "show public-ip"
az network public-ip show --resource-group PubLBResGrp --name myPublicIP --query ipAddress --output tsv

#################################
# Delete resource group

#az group delete --name PubLBResGrp

