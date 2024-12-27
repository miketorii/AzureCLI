export RES_GRP="MikeResGrp402"
export OPENAI_RES_NAME1="OpenAIResName402"
export DEPLOY_NAME="MyModel"

#export RESION="japaneast"
export REGION="eastus"

#export MODEL_NAME="text-embedding-ada-002"
#export MODEL_VERSION="1"
#export MODEL_NAME="gpt-35-turbo"
#export MODEL_VERSION="0125"
export MODEL_NAME="gpt-4"
export MODEL_VERSION="0613"

#export GREEN_COMMIT_ID=100ffff


##########################################
# Set subscription
az account set --subscription 'Visual Studio Enterprise サブスクリプション'

#################################
# Create Resource Group
az group create --name $RES_GRP --location $REGION

#################################
# Create OpenAI Resource
az cognitiveservices account create --name $OPENAI_RES_NAME1 --resource-group $RES_GRP --location $REGION --kind OpenAI --sku s0

#################################
# Deploy model
az cognitiveservices account deployment create --name $OPENAI_RES_NAME1 --resource-group $RES_GRP --deployment-name $DEPLOY_NAME --model-name $MODEL_NAME --model-version $MODEL_VERSION --model-format OpenAI --sku-capacity "1" --sku-name "Standard"





#################################
# Show resource info

# show endpoint URL
az cognitiveservices account show --name $OPENAI_RES_NAME1 --resource-group $RES_GRP | jq -r .properties.endpoint

# show access key
az cognitiveservices account keys list --name $OPENAI_RES_NAME1 --resource-group  $RES_GRP | jq -r .key1








