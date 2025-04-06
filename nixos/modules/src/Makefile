'CONFIG_MODULE_SIG = n

# Make it possible to override the kernel src tree location from Nix derivation.
KERNEL ?= $(shell uname -r)
KERNELDIR ?= /lib/modules/$(KERNEL)/build/
PWD := $(shell pwd)

.PHONY: default
default: modules

# -m: Build as module.
obj-m := ch341.o

.PHONY: modules
modules:
	@#"M=": Module source. Special variable of the kernel's main Makefile.
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

.PHONY: modules_install
modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

.PHONY: clean
clean:
	rm -rf *.mk .tmp_versions Module.symvers *.mod.c *.o *.ko .*.cmd Module.markers modules.order *.a *.mod

.PHONY: load
load:
	insmod ch341.ko

.PHONY: unload
unload:
	rmmod ch341

.PHONY: install
install: modules
	rmmod ch341 || true
	insmod ch341.ko || true
	mkdir -p /lib/modules/$(shell uname -r)/kernel/drivers/usb/serial/ || true
	cp -f ./ch341.ko /lib/modules/$(shell uname -r)/kernel/drivers/usb/serial/ || true
	depmod -a

.PHONY: uninstall
uninstall:
	rmmod ch341 || true
	rm -rf /lib/modules/$(shell uname -r)/kernel/drivers/usb/serial/ch341.ko || true
	depmod -a
