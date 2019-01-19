# [Guide] How to build Tensorflow r1.12 with cuda 10.0 from source

## Installation Environment

### Hardware

* CPU: intel i9 9900K
* RAM: DDR4 32G
* Graphics Card: MSI ARMOR RTX 2070

### Software

* OS: ubuntu 18.04.1 LTS
* Compiler: gcc 7.3
* Shell: bash
* NVIDIA graphics driver: NVIDIA-Linux-x86_64-410.78

## Install Dependencies

1. Basic tools

    ``` shell
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install build-essential cmake git unzip zip gcc
    sudo apt-get install python python3-dev python3-pip 
    sudo apt-get install linux-headers-$(uname -r)
    ```

2. Install NVIDIA graphics driver

    You can download the driver from https://www.nvidia.com/Download/index.aspx

    ```shell
    chmod +x NVIDIA-Linux-x86_64-410.78.run
    sudo ./NVIDIA*.run
    ```

3. Install CUDA 10.0

    Remove previous cuda installations

    ```shell
    sudo apt-get purge nvidia*
    sudo apt-get autoremove
    sudo apt-get autoclean
    sudo rm -rf /usr/local/cuda*
    ```

    Download .deb packages and install

    ```shell
    sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
    
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
    
    sudo apt-get update 
    sudo apt-get -o Dpkg::Options::="--force-overwrite" install cuda-10-0 cuda-drivers
    ```

    Reboot your system

    Go to terminal and add library path

    ```shell
    echo 'export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}' >> ~/.bashrc
    
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
    ```

    Reload shell config 

    ```shell
    source ~/.bashrc
    sudo ldconfig
    ```

    Now type `nvidia-smi` and you should see your graphics card now

    ```shell
    jjlab@jjlab-i9 ~> nvidia-smi
    Thu Nov 22 13:11:46 2018
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 410.48                 Driver Version: 410.48                    |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  GeForce RTX 2070    Off  | 00000000:01:00.0  On |                  N/A |
    |  0%   37C    P0    47W / 175W |    344MiB /  7949MiB |      1%      Default |
    +-------------------------------+----------------------+----------------------+
    
    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID   Type   Process name                             Usage      |
    |=============================================================================|
    |    0      1002      G   /usr/lib/xorg/Xorg                           137MiB |
    |    0      1158      G   /usr/bin/gnome-shell                         195MiB |
    |    0      1762      G   /usr/lib/firefox/firefox                       3MiB |
    |    0      1855      G   /usr/lib/firefox/firefox                       3MiB |
    |    0     17498      G   gnome-control-center                           3MiB |
    +-----------------------------------------------------------------------------+
    ```

4. Install cuDNN 7,4,1

    Go to https://developer.nvidia.com/cudnn and download **cuDNN Library for Linux**, it should be a `.tgz` file.

    ```shell
    tar -xf cudnn-10.0-linux-x64-v7.4.1.5.tgz
    sudo cp -R cuda/include/* /usr/local/cuda-10.0/include
    sudo cp -R cuda/lib64/* /usr/local/cuda-10.0/lib64
    ```

5. Install NCCL 2.3.7

    Go to https://developer.nvidia.com/nccl/nccl-download and download **O/S agnostic local installer** 

    ```shell
    tar -xf nccl_2.3.7-1+cuda10.0_x86_64.txz
    cd nccl_2.3.7-1+cuda10.0_x86_64
    sudo cp -R * /usr/local/cuda-10.0/targets/x86_64-linux/
    sudo ldconfig
    ```

6. Install python packages

    ```shell
    pip3 install -U --user pip six numpy wheel mock
    pip3 install -U --user keras_applications==1.0.5 --no-deps
    pip3 install -U --user keras_preprocessing==1.0.3 --no-deps
    ```

7. Install bazel

    Note that you must install version 0.18.1

    ```shell
    cd ~/
    wget https://github.com/bazelbuild/bazel/releases/download/0.18.1/bazel-0.18.1-installer-linux-x86_64.sh
    chmod +x bazel-0.18.1-installer-linux-x86_64.sh
    ./bazel-0.18.1-installer-linux-x86_64.sh --user
    echo 'export PATH="$PATH:$HOME/bin"' >> ~/.bashrc
    source ~/.bashrc
    sudo ldconfig
    ```

## Download TensorFlow source code and configure build parameters

```shell
cd ~/
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout r1.12
./configure
# Given the python path in
Please specify the location of python. [Default is /usr/bin/python]: /usr/bin/python3

Do you wish to build TensorFlow with Apache Ignite support? [Y/n]: n

Do you wish to build TensorFlow with XLA JIT support? [Y/n]: n

Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: n

Do you wish to build TensorFlow with ROCm support? [y/N]: n

Do you wish to build TensorFlow with CUDA support? [y/N]: Y

Please specify the CUDA SDK version you want to use. [Leave empty to default to CUDA 9.0]: 10.0

Please specify the location where CUDA 10.0 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: /usr/local/cuda-10.0

Please specify the cuDNN version you want to use. [Leave empty to default to cuDNN 7]: 7.4.1

Please specify the location where cuDNN 7 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda-10.0]: /usr/local/cuda-10.0

Do you wish to build TensorFlow with TensorRT support? [y/N]: n

Please specify the NCCL version you want to use. If NCCL 2.2 is not installed, then you can use version 1.3 that can be fetched automatically but it may have worse performance with multiple GPUs. [Default is 2.2]: 2.3.7

Please note that each additional compute capability significantly increases your build time and binary size. [Default is: 7.5] 7.5

Do you want to use clang as CUDA compiler? [y/N]: n

Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]: /usr/bin/gcc

Do you wish to build TensorFlow with MPI support? [y/N]: n

Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]: -march=native

Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]:n
```

## Build TensorFlow using Bazel

```shell
bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
```

Note:

 	1. Add `--config=mkl` if you want Intel MKL support for newer intel cpu for faster training on cpu.
 	2. Add `--config=monolithic` if you want static monolithic build. (try this if build failed)
 	3. Add `--local_resources 2048,.5,1.0` if your PC has low RAM causing Segmentation fault or other related errors

After Compilation, build whl file and install by pip

```shell
bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg
cd tensorflow_pkg
pip3 install tensorflow*.whl
```

