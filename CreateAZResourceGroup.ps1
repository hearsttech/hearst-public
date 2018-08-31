<#
	.NOTES
	Version:        1.0
	Author:         Rick Delserone

	This is a function so in order to execute within a PowerShell session it will need to be dot sourced.
	
	.SYNOPSIS
	This functioned is designed to create a new resource group with the necessary tags within a single target subscription.
  
	.DESCRIPTION
	This functioned is designed to create a new resource group with the necessary tags within a single target subscription.  If executed against a pre-existing resource group, the tags will be updated to reflect the new values but contained resources and provisioned RBAC will remain intact.

	.EXAMPLE
	CreateAZResourceGroup -SubscriptionName azure-sub -ResourceGroupName azr-bun-centralus-test-rg -GeoLocation "Central US" -CostCenter 123 -BusinessUnit "Azure Global" -Product "Universal Test App" -Environment "test"
	
	.PARAMETER SubscriptionName
	The subscription containing Virtual Machines that need the BGInfo extension enabled.

	.PARAMETER ResourceGroupName
	The name of the new resource group to be created.

	.PARAMETER GeoLocation
	The azure region where the new resource group is to reside.

	.PARAMETER CostCenter
	Unique three-digit financial number code assigned to each company (e.g. 883)

	.PARAMETER Business Unit
	Specific name assigned to a business unit (e.g. Fitch Learning)

	.PARAMETER Product
	Name of the product the resource will be supporting (e.g. Newsgate)

	.PARAMETER Environment
	Used to distinguish between development, test, and production infrastructure (e.g. Dev, Prod, QA, UAT)

  #>

	[Cmdletbinding()]
	Param(
		[parameter(mandatory=$True)]
		[string]$SubscriptionName,
		[parameter(mandatory=$True)]
		[string]$ResourceGroupName,
		[parameter(mandatory=$True)]
		[string]$GeoLocation,
		[parameter(mandatory=$True)]
		[string]$CostCenter,
		[parameter(mandatory=$True)]
		[string]$BusinessUnit,
		[parameter(mandatory=$True)]
		[string]$Product,
		[parameter(mandatory=$True)]
		[string]$Environment
		)


	# Set Azure Subscription Context
    $AZContext = Get-AzureRmContext
    If ($AZContext.Subscription.Name -ne $SubscriptionName){
	Get-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext}

	#Create Site Recovery Resource Group
	$ResourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $GeoLocation
	Set-AzureRmResourceGroup -Name $ResourceGroup.ResourceGroupName `
		-Tag @{ CostCenter=$CostCenter; BusinessUnit=$BusinessUnit; Product=$Product; Environment=$Environment }
