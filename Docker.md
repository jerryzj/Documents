# Docker Tutorial

### 19, Jan. 2019. Jerry ZJ

## Installation

* Mac: Install via homebrew

    ```shell
    $ brew install docker
    ```

* Linux: Install via apt

    ```shell
    $ sudo apt update && sudo apt install docker-io
    ```

## Post installation

### Run docker without sudo

1. Create the ```docker``` user group

    ```shell
    $ sudo groupadd docker
    ```

2. Add current user to the ```docker``` group

    ```shell
    $ sudo usermod -aG docker $USER
    ```

3. Log out and log back in so that your group membership is re-evaluated.

### Start docker on boot

```shell
$ sudo systemctl enable docker
```

## Create a ubuntu docker container with bash

```shell
docker run -it --name $Name_of_the_container ubuntu /bin/bash
```

## Leave docker

* Leave and stop the container

    ```shell
    $ exit
    ```

* Leave without stopping the container

    ```
    Ctrl + P & Ctrl + Q
    ```

## Restart container

* Restart an exited container 

    ```shell
    docker start #CONTAINER_ID
    ```

* Attach to the container

    ```shell
    docker attach #CONTAINER_ID
    ```

    