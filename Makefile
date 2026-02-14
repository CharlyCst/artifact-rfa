all: bl32_qemu.bin bl33_qemu.bin bl32_fvp.bin bl33_fvp.bin

rusted-firmware-a:
	git clone --depth 1 --branch v0.2.0 https://review.trustedfirmware.org/RF-A/rusted-firmware-a

bl32_qemu.bin bl33_qemu.bin &: rusted-firmware-a
	cd rusted-firmware-a && make PLAT=qemu build-stf
	cd rusted-firmware-a && rust-objcopy -O binary target/aarch64-unknown-none-softfloat/release/bl32 ../bl32_qemu.bin
	cd rusted-firmware-a && rust-objcopy -O binary target/aarch64-unknown-none-softfloat/release/bl33 ../bl33_qemu.bin

bl32_fvp.bin bl33_fvp.bin &: rusted-firmware-a
	cd rusted-firmware-a && make PLAT=fvp build-stf
	cd rusted-firmware-a && rust-objcopy -O binary target/aarch64-unknown-none-softfloat/release/bl32 ../bl32_fvp.bin
	cd rusted-firmware-a && rust-objcopy -O binary target/aarch64-unknown-none-softfloat/release/bl33 ../bl33_fvp.bin

.PHONY: setup
setup: rusted-firmware-a
	cd rusted-firmware-a && rustup component add llvm-tools-preview

.PHONY: clean
clean:
	rm -rf rusted-firmware-a *.bin
