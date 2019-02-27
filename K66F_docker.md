# Using K66F in macOS environment

27, Feb, 2019 Jerry ZJ

## Preface

This is an advanced tutorial, if you don't know to use Google appropriately, please follow the steps in our website.

## Install docker

Assume you already have Homebrew installed, use the following command to install docker

```shell
brew cask install docker
```

After docker is installed, you can see a new app **Docker** in ``/Applications`` , Click it and start docker daemon, it'll ask for root permission in the first time.

## Mount K66F in docker

1. Open the terminal.

2. Enter the following command:

    ```shell
    mount
    ```

    This command will display all mounted drives on your machine. Find the identifier that corresponds to your USB drive, for example `/dev/disk2` (It may be different in your computer).

3. Unmount the drive:

    ```shell
    diskutil unmount /dev/disk2
    ```

4. Create the folder that will serve as the new mount point on macOS:

    ```shell
    sudo mkdir -p /mnt/usb
    ```

5. Mount the USB drive to the newly created mount point.

    ```shell
    sudo diskutil mount -mountPoint /mnt/usb /dev/disk2
    ```

6. Verify that the drive has been properly mounted:

    ```shell
    ls /mnt/usb
    ```

    Before you can mount your USB drive in a Docker container, you need to add the `/mnt` folder to the list of shared directories in Docker for Mac:

    1. On the main menu bar click the Docker for Mac icon
    2. Select **Preferences**.
    3. Open the **File Sharing** tab.
    4. Click **+** in the bottom-left corner of the list.
    5. Navigate to the `/mnt` directory and click **Open**.
    6. Click **Apply & Restart**.

## Run a new container

Run a container with the following command. K66F will be mounted at ``/mnt/usb`` inside the container.

```shell
docker run -it -v /mnt/usb:/mnt/usb  ubuntu:18.04 /bin/bash
```

## Notes

1. In docker environment, you are login as root, so you don't need ``sudo``anymore. 

2. When adding ppa (apt package source), you will face ``add-apt-repository`` command not found problem. Just use the following command to fix it.

    ```
    apt install software-properties-common
    ```

3. After compiling project via ``mbed-cli``, it'll show the following message

    ```shell
    Image: ./BUILD/K66F/GCC_ARM/mbed-os-example-blinky.bin
    [1551198654.67][mbedls.platform_database]Error loading database /root/.local/share/mbedls/platforms.json: Platform Database is out of date; Recreating
    [1551198654.67][mbedls.lstools_linux]Could not get disk devices by id. This could be because your Linux distribution does not use udev, or does not create /dev/disk/by-id symlinks. Please submit an issue to github.com/armmbed/mbed-ls.
    [1551198654.67][mbedls.lstools_linux]Could not get serial devices by id. This could be because your Linux distribution does not use udev, or does not create /dev/serial/by-id symlinks. Please submit an issue to github.com/armmbed/mbed-ls.
    [mbed] ERROR: The target board you compiled for is not connected to your system.
           Please reconnect it and retry the last command.
    ---
    [mbed] WARNING: Using Python 3 with Mbed OS 5.8 and earlier can cause errors with compiling, testing and exporting
    ---
    ```

    Just copy the ``mbed-os-example-blinky.bin`` to the mount point.

    ```shell
    cp ./BUILD/K66F/GCC_ARM/mbed-os-example-blinky.bin /mnt/usb/
    ```

4. If you want to know some basic operations related to docker, you may visit the [link](https://github.com/jerryzj/Documents/blob/master/Docker.md).

