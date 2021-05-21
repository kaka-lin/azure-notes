# iotedge-compose

Convert Docker Compose project to Azure IoT Edge deployment manifest.

## Requirements

- Make sure docker is running on your system before using this tool.
- Python version >= 3.6.0.

## Install

```bash
$ pip3 install iotedge-compose
```

## Usage

```bash
$ iotedge-compose \
    -t [file|project] \
    -i docker_compose_file_path \
    -o output_path [-r your_docker_container_registry_address]
```

### Example

1. Conver single file

```bash
$ iotedge-compose \
    -t file \
    -i examples/flask-redis/docker-compose.yml \
    -o examples/flask-redis/deployment.json
```

2. Convert project

```bash
$ iotedge-compose \
    -t project \
    -i examples/flask-redis/docker-compose.yml \
    -o examples/flask-redis-edge
```
