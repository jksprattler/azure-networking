Get-AzSubscription | Foreach-Object {
    $sub = Set-AzContext -SubscriptionId $_.SubscriptionId
    $vnets = Get-AzVirtualNetwork

    foreach ($vnet in $vnets) {
        [PSCustomObject]@{
            SubName = $sub.Subscription.Name
            SubID = $sub.Subscription.SubscriptionId
            ResourceGroup = $vnet.ResourceGroupName
            Location = $vnet.Location
            VnetName = $vnet.Name
            VnetPrefix = $vnet.AddressSpace.AddressPrefixes -join ', '
            SubnetName = $vnet.Subnets.Name -join ', '
            SubnetPrefix = $vnet.Subnets.AddressPrefix -join ', '            
        }
    }
} | Export-Csv -Delimiter "," -Path "AzureVnetSubnets.csv"