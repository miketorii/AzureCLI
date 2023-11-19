##########################################
# Set subscription
##########################################

#az account set --subscription 'Visual Studio Enterprise サブスクリプション'

##########################################
# Create resource group
##########################################

#az group create --location japaneast --name MyRG

##########################################
# Create VM
##########################################

#az vm create -n myVM -g MyRG --image UbuntuLTS --generate-ssh-keys

##########################################
# Delete resource group
##########################################

#az group delete -n MyRG
az group delete -n NetworkWatcherRG




