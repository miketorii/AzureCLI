export RES_GRP="MikeResGrp4"
export OPENAI_RES_NAME1="OpenAIResName4"
export DEPLOY_NAME="MyModel"

az cognitiveservices account deployment delete --name $OPENAI_RES_NAME1 --resource-group  $RES_GRP --deployment-name $DEPLOY_NAME

az group delete --name $RES_GRP



