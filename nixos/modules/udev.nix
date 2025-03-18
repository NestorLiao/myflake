{pkgs, ...}: {
  services.udev.packages = [
    # pkgs.via

    (pkgs.writeTextFile {
      name = "50-i2c.rules";
      text = ''
        SUBSYSTEM=="i2c-dev", GROUP="users", MODE="0660"
      '';
      destination = "/etc/udev/rules.d/50-i2c.rules";
    })
    (pkgs.writeTextFile {
      name = "52-xilinx-digilent-usb.rules";
      text = ''
        ATTR{idVendor}=="1443", MODE:="666"
        ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
      '';

      destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
    })
    (pkgs.writeTextFile {
      name = "52-xilinx-ftdi-usb.rules";
      text = ''
        ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
      '';

      destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
    })
    (pkgs.writeTextFile {
      name = "52-xilinx-pcusb.rules";
      text = ''
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
      '';

      destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
    })
  ];
}
