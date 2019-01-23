# RISCV Toolchain & ISS evaluation

## Toolchain

* RISCV GNU (riscv64-linux-gnu-gcc)
    * Installation: ```apt install gcc-riscv64-linux-gnu g++-riscv64-linux-gnu```
    * ABI: UNIX - System V
    * Status: Use ```-static``` option during compilation to run on ISA simulator. Have problem compiling spike proxy kernel.
* SiFive LLVM (riscv64-unknown-elf-gcc)
    * Installation: Built from [source](https://github.com/sifive/riscv-llvm.git) commit ID: 2793f1b0682d37fd773c648ba9cd99c2a08acfad
    * ABI: UNIX - System V
    * Status: Compilation takes time.
* SiFive prebuilt. 
    * Installation: Download from SiFive [website](https://www.sifive.com/boards).
    * ABI: UNIX - System V
    * Status: Easy to install! 

## ISS

* Spike

    * Dependencies:
        1. [riscv-fesvr](https://github.com/riscv/riscv-fesvr.git) commit ID: 8d108a0a647901550d95925549337c2c3aec9ac8 
        2. [riscv-pk](https://github.com/riscv/riscv-pk.git) commit ID: 66c13fd4a9c1c2eda51df35ddc13e095469faec7
    * Installation: Download from [GitHub](https://github.com/riscv/riscv-isa-sim.git), commit ID: c544846020608d8ae471b53c8558c61e1702671f
    * Notes: riscv-pk build failed via RISCV GNU toolchain, issue [here](https://github.com/riscv/riscv-pk/issues/141).
    * Status: Hello World & Lenet_CPP okay.

* OVPsim

    * Installation: Download from [GitHub](https://github.com/riscv/riscv-ovpsim.git), commit ID: 0b8b51a744082ecacdcfa544e441328c65a9690d

    * Status: 

        * SiFive LLVM: Doesn't support single precision instruction, Lenet failed, Hello World okay.

        ```shell
        flw     fa5,0(a3): Illegal instruction - extension F (single-precision floating point) absent or inactive
        ```

        * RISCV GNU: Processor Exception when running Lenet.

        ```shell
        Processor Exception (PC_PRX) Processor 'riscvOVPsim/cpu' 0x0: 0000     illegal
        Processor Exception (PC_FIX) Executing at uninitialized address 0x0
        Processor Exception (PC_FUM) NOTE: simulated exceptions are not enabled on processor riscvOVPsim/cpu. To continue execution when fetching from uninitialized memory, please ensure simulated exceptions are enabled.
        ```

        