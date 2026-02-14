all: bl32_qemu.bin bl33_qemu.bin bl32_fvp.bin bl33_fvp.bin

rusted-firmware-a:
	git clone --depth 1 --branch v0.2.0 https://review.trustedfirmware.org/RF-A/rusted-firmware-a

bl32_qemu.bin bl33_qemu.bin &: rusted-firmware-a
	cd rusted-firmware-a && make PLAT=qemu build-stf
	rust-objcopy -O binary rusted-firmware-a/target/aarch64-unknown-none-softfloat/release/bl32 bl32_qemu.bin
	rust-objcopy -O binary rusted-firmware-a/target/aarch64-unknown-none-softfloat/release/bl33 bl33_qemu.bin

bl32_fvp.bin bl33_fvp.bin &: rusted-firmware-a
	cd rusted-firmware-a && make PLAT=fvp build-stf
	rust-objcopy -O binary rusted-firmware-a/target/aarch64-unknown-none-softfloat/release/bl32 bl32_fvp.bin
	rust-objcopy -O binary rusted-firmware-a/target/aarch64-unknown-none-softfloat/release/bl33 bl33_fvp.bin

.PHONY: clean
clean:
	rm -rf trusted-firmware-a *.bin
