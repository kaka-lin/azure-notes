# Create a smiple Linux MV

## Linux Ubuntu VM

- [速入門：使用 ARM 範本建立 Ubuntu Linux 虛擬機器](https://docs.microsoft.com/zh-tw/azure/virtual-machines/linux/quick-create-template)
- [Very simple deployment of a Linux Ubuntu VM](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-simple-linux)
- [Microsoft.Compute virtualMachines](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines?tabs=json)

## Guidline

### Export the specific port

```json
{
    "type": "Microsoft.Network/networkSecurityGroups",
    "apiVersion": "2020-06-01",
    "location": "[parameters('location')]",
    "properties": {
        "securityRules": [
            "name": "<NAME>",
            "properties": {
                ...
            }
        ]
    }
}
```
