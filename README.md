![alt text](usbrelay.jpg "USB Relay")

USB Relay driver for Linux, Mac OS X and Windows
================================================

A cheap USB relay available from Ebay has either single or dual relay output.
The double throw relay ratings are 10A 250VAC each.

The USB device is HID compatible and comes with Windows control software.
This code can control the relay via HIDAPI which is a cross platform library. 
This code was tested under Linux both on x86 and Raspberry Pi ARM, Mac OS X 10.9 Mavericks
and Windows both 7 and 8.1.
The program is command line only as it is likely to be used by shell scripts.

The output of lsusb for the device is:
```
Bus 001 Device 003: ID 16c0:05df Van Ooijen Technische Informatica HID device except mice, keyboards, and joysticks

# lsusb -v -d 16c0:05df 

Bus 001 Device 003: ID 16c0:05df Van Ooijen Technische Informatica HID device except mice, keyboards, and joysticks
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x16c0 Van Ooijen Technische Informatica
  idProduct          0x05df HID device except mice, keyboards, and joysticks
  bcdDevice            1.00
  iManufacturer           1 www.dcttech.com
  iProduct                2 USBRelay2
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower               20mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      22
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              20
Device Status:     0x0000
  (Bus Powered)
```
Build Instructions
===================

Prerequisite
-------------
### The [HIDAPI!](http://www.signal11.us/oss/hidapi) library
You will need to install the development packages if available, or compile the sources by yourself.
The source code can be checked in from the official repository:
```
git clone https://github.com/signal11/hidapi
```
Protocol:
The relay modules does not set the USB serial number but has a unique serial when the HID device is queried, the current state of the relays is also sent with the serial.
The HID serial is matched and the ON/OFF command is sent to the chosen relay.

#### HIDAPI on Linux
HIDAPI is a fairly recent addition to Linux and is available as a package for Fedora 20 but not for Pidora (F18). 
The package was built for Pidora (Fedora 18) using the F20 hidapi source package.

On Debian/Ubuntu systems, development packages for libhidapi can be installed by running:
```
sudo apt-get install libhidapi-dev libhidapi-hidraw0 libhidapi-libusb0
```

#### HIDAPI on Mac OS X
The development packages for libhidapi can be installed by running:
```
sudo brew install hidapi
```

#### HIDAPI on Windows
You have to build the hidapi dll from the source code following the instructions
from this [link!](https://github.com/signal11/hidapi).

For your convenience, you can find the Windows x86 hidapi library binaries
in the `windows/hidapi` directory of this repository.
You have to copy the hidapi.dll in the usbrelay.exe program directory.


Build usbrelay on Linux
-----------------------
There are two options for the hidapi library: hidapi-hidraw or hidapi-libusb. Different distributions have better results with one or the other. YMMV.
```
### hidapi-hidraw 
# gcc -o usbrelay usbrelay.c -lhidapi-hidraw
### hidapi-libusb
# gcc -o usbrelay usbrelay.c -lhidapi-libusb
```


Build usbrelay on Mac OS X
--------------------------
Compile the program entering the following command:
```
# gcc -o usbrelay usbrelay.c -lhidapi
```


Build usbrelay on Windows
-------------------------
Use Visual Studio to build the .sln file in the `windows/usbrelay-vs` directory.


Usage
=====

As already stated, the program is command line only.

On Windows, PowerShell is recommended instead of the old DOS style Command Prompt.

On Linux, the code needs to access the device. This can be achieved either by running the program with root privileges (so sudo is your friend) or by putting
```
SUBSYSTEM=="usb", ATTR{idVendor}=="16c0",ATTR{idProduct}=="05df", MODE="0666"
KERNEL=="hidraw*", ATTRS{busnum}=="1", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", MODE="0666"
```
to `/etc/udev/rules.d/50-dct-tech-usb-relay-2.rules`.

Usually hidraw busnum is set to 1, but it may change in some hardware configurations, such as virtual machines.
Check the output of the `lsusb` command to get the right hidraw busnum.

On Mac OS X and Windows, it is not required to run the program with root privileges.

Running the program will display each module that matches device 16c0:05df. The debug information is sent to stderr while the state is sent to stdout for use in scripts. The only limit to the number of these relays that can be plugged in and operated at once is the number of USB ports.

### To display the debug information and relay state

On Linux and Mac OS X:
```
$ [sudo] ./usbrelay
```
On Windows Command Prompt and PowerShell:
```
> usbrelay
```
Result:
```
Device Found
  type: 16c0 05df
  path: /dev/hidraw1
  serial_number: 
  Manufacturer: www.dcttech.com
  Product:      USBRelay2
  Release:      100
  Interface:    0
PSUIS_1=1
PSUIS_2=0
```

### To get the relay state only
On Linux and Mac OS X:
```
$ [sudo] ./usbrelay 2>/dev/null
```
On Windows Command Prompt:
```
> usbrelay 2> NUL
```
On Windows PowerShell:
```
> usbrelay 2> $null
```
Result:
```
PSUIS_1=1
PSUIS_2=0
```

### To use the state in a script
On Linux and Mac OS X:
```
$ eval $([sudo] ./usbrelay 2>/dev/null)
$ echo $PSUIS_2
0
```
On Windows Command Prompt there isn't an equivalent of Linux shell eval() function.
Instead, use Windows PowerShell:
```
> Invoke-Expression ("$" + (usbrelay) 2> $null)
> $PSUIS_2
0
```

### To set the relay state of 1 or more modules at once
On Linux and Mac OS X:
```
$ [sudo] ./usbrelay PSUIS_2=0
$ [sudo] ./usbrelay PSUIS_2=1 PSUIS_1=0
$ [sudo] ./usbrelay PSUIS_2=0 PSUIS_1=1 0U70M_1=0 0U70M_2=1
```
On Windows Command Prompt and PowerShell:
```
> usbrelay PSUIS_2=0
> usbrelay PSUIS_2=1 PSUIS_1=0
> usbrelay PSUIS_2=0 PSUIS_1=1 0U70M_1=0 0U70M_2=1
```

### To change the USBID environment variable
If for some reason the USB id changes, (ie other than 16c0:05df) set the USBID environment variable to the correct ID.

On Linux and Mac OS X:
```
$ [sudo] USBID=16c0:05df ./usbrelay
```
On Windows Command Prompt (make sure your spacing is exactly as shown below):
```
> set USBID=16c0:05df
> usbrelay
```
On Windows PowerShell:
```
> $env:USBID = "16c0:05df"
> usbrelay
```

Enjoy
