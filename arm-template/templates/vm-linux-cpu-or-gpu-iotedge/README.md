# Deploy a CPU or GPU based VM with IoT Edge

This will deploy a CPU or GPU based VM with IoT Edge pre-installed

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
