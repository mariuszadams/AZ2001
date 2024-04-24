## run the following commands to retrieve the values of the Azure subscription ID and subscription name attributes:
subscriptionName=$(az account show --query name --output tsv)
   subscriptionId=$(az account show --query id --output tsv)
   echo $subscriptionName
   echo $subscriptionId

## run the following command to create a Service Principal:
az ad sp create-for-rbac --name sp-eshoponweb-azdo --role contributor --scopes /subscriptions/$subscriptionId > sp.json
### mariusz [ ~ ]$ cat sp.json 
###{
###  "appId": "48934cf5-debc-4ed0-8f79-6e02dab3d055",
###  "displayName": "sp-eshoponweb-azdo",
###  "password": "XXXXXXXXXXXXXXXXXXX",
###  "tenant": "b707cb3a-128f-4664-8f69-d5737d485b05"
###}