# Azure Resource Graph Collection
A collection of Azure Resource Graph queries related to capturing subscription, VNet, subnets, route tables, etc types of data

## Get all subnets sorted by subscription and location
```
Resources 
| where type == "microsoft.network/virtualnetworks"
| mv-expand addressSpaces = properties.addressSpace.addressPrefixes
| mv-expand subnets=properties.subnets
| join kind=leftouter(
Resourcecontainers
| where type == 'microsoft.resources/subscriptions'
| project subscriptionId, subscriptionName = name) on subscriptionId
| project subscriptionName, subscriptionId, location, VNetName = name, subnet_name = subnets.name, subnet_prefixes = subnets.properties.addressPrefix
| order by subscriptionName asc, location asc
```

## Get all VNet's sorted by subscription and location
```
Resources 
| where type == "microsoft.network/virtualnetworks"
| mv-expand addressSpaces = properties.addressSpace.addressPrefixes
| join kind=leftouter(
Resourcecontainers
| where type == 'microsoft.resources/subscriptions'
| project subscriptionId, subscriptionName = name) on subscriptionId
| project subscriptionName, subscriptionId, resourceGroup, name, location, addressSpaces
| order by subscriptionName asc, location asc
```

## Get all route tables associated with subnets containing "backend" in the name
```
Resources
| join kind=leftouter (
    ResourceContainers 
    | where type=='microsoft.resources/subscriptions' 
    | project SubName=name, subscriptionId) 
on subscriptionId
| where type=='microsoft.network/routetables' and split(properties['subnets'][0]['id'], "/", 10) contains '-backend'
| project SubName, subscriptionId, VNetName=split(properties['subnets'][0]['id'], "/", 8), SubnetName=split(properties['subnets'][0]['id'], "/", 10), RouteTable=name, resourceGroup, location
| mv-expand SubnetName,VNetName to typeof(string) 
| order by SubName asc
```
