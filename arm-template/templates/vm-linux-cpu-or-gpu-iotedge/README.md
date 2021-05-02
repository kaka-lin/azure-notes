# Deploy a CPU or NVIDIA GPU-backed VM with IoT Edge

This will deploy a CPU or `NVIDIA GPU-backed` with IoT Edge pre-installed

## Reference: [Azure/iotedge-vm-deploy](https://github.com/Azure/iotedge-vm-deploy)

## Guideline

Change the config in `cloud-init.txt`,
and use `genoneline.py` to genert the one line string that can copy into `customData` as below:

```bash
$ python3 genoneline.py cloud-init.txt
```

azuredeploy.json
```json
{
    "type": "Microsoft.Compute/virtualMachines",
    "apiVersion": "2020-06-01",
    "properties": {
        "osProfile": {
            "customData": "<YOUR STRINGT>"
        }
    }
}
```

### Install NVIDIA Driver

azuredeploy.json
```json
{
  "name": "<myExtensionName>",
  "type": "extensions",
  "apiVersion": "2015-06-15",
  "location": "<location>",
  "dependsOn": [
    "[concat('Microsoft.Compute/virtualMachines/', <myVM>)]"
  ],
  "properties": {
    "publisher": "Microsoft.HpcCompute",
    "type": "NvidiaGpuDriverLinux",
    "typeHandlerVersion": "1.3",
    "autoUpgradeMinorVersion": true,
    "settings": {
    }
  }
}
```

Reference:
  - [NVIDIA GPU Driver Extension for Linux](https://docs.microsoft.com/zh-tw/azure/virtual-machines/extensions/hpccompute-gpu-linux)
  - [baptisteohanes/Demo_AzureNseriesVMAutomation](https://github.com/baptisteohanes/Demo_AzureNseriesVMAutomation)
  - [michhar/darknet-azure-vm-ubuntu-18.04 ](https://github.com/michhar/darknet-azure-vm-ubuntu-18.04)

### Specific version of `IoT Edge`

Install `1.0.10.4` as a example

1. change `apt install iotedge` to `apt install -y --allow-downgrades iotedge=1.0.10.4-1 libiothsm-std=1.0.10.4-1`

    ```bash
    $ apt install -y --allow-downgrades iotedge=1.0.10.4-1 libiothsm-std=1.0.10.4-1
    ```

2. Run `genoneline.py` to generate new string

    ```bash
    $ python3 genoneline.py cloud-init.txt
    ```

3. Debug

    In the VM
    ```bash
    $ cat /var/log/cloud-init-output.log
    ```
