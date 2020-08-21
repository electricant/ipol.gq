# Netis WF2419I Router Haking Diary

## Introduction

I had an old (2014-ish) Netis WF2419I [\[1\]][1] router collecting dust in a cabinet at
home. Its performance has always been lackluster with the WiFi connection
dropping and restarting every few minutes. I bought it to serve as a guest AP
for my dorm while I was studying in Padova. After I moved I've never used it any
more and switched to a whole different setup (which I hope to describe in
another post).

This router was almost forgotten, until I read an excellent artcle by George
Hilliard [\[2\]][2] about hacking Reolink cameras. This was enough to spark my
interest in trying to reverse engineer and add as much new functionality as
possible to this old (and somewhat crappy) piece of hardware.

First off let's set some goals to keep us on track:
 * Open the router and identify chipset, RAM, FLASH size and serial port
 * Dump the flash contents and inspect them
 * Rebuild a bootable image from the extracted contents and flash it
 * Setup a working buildroot image and compile a statically-linked busybox
 * Compile a (hopefully working) custom kernel for the device 

As you can see some of those goals are not easy. Moreover, Murphy's law gets you
every time and many roadblocks were encountered during this journey. I will not
spare any of the detials, including the __MANY__ failed attempts. That's why I'm 
calling this page a diary.

At the time of writing I'm quite far from completion. Depending how long this
grows I might decide to split this post into a series.

## Opening up the Device & Talking to the Serial Port

This is the easy part. Just remove the two screws on the bottom side (one is
hidden by the mandatory 'warranty void if seal is broken' stiker, about which I
couldn't care less) and pop open the case.

The following components appear before us onto the sea of green of the board:
 * Realtek RTL8196C - the main router chipset
 * Realtek RTL8192CE - WiFi chipset
 * Winbond W25Q32FV - 32Mbit (4MB) SPI FLASH memory
 * ESMT M12L128168A - 2M x 16 Bit x 4 Banks (16MB) SDRAM
 * A few testpoints, probably for JTAG and UART access

As a first step let's look up on our favourite search engine for the main router
chipset datasheet. And sure enough somebody (thank you!) released a confidential
copy for us to read [\[3\]][3]. Let's scroll right-ahead to the pinout, shall
we? Let's neglect all the other details for the moment. Remember we are looking
for a serial port!

[figura col pinout]

And sure enough here it is! Look at the above picture. In the bottom-right part
we have two pins (pin 36 and 37) labelled `UART_RX/GPIOA7` and
`UART_TX/GPIOB0`. With a multimeter those two pins are tracked to the
unpopulated header labelled `J1`. Time to solder a pin header and connect a
TTL to USB adapter. But HEI! Wait! What's the baud rate? A quck check with an
oscilloscope (some trial and error works too) revealed it's `38400bps`.

[figura pin header saldato]

After connecting a TTL to serial adapter and issuing
	
	$ screen -L /dev/ttyUSB0 38400
	
when we start the router we get the following messages:
	
	=============================
	
	<Probe SPI #0 >
	
	1.Manufacture ID=0xef
	
	2.Device ID=0x40
	
	3.Capacity ID=0x16

	4.Winbond SPI (4 MByte)!

	5.Total sector-counts = 1024(sector=4KB)

	6.spi_flash_info[0].device_size = 22

	01_8198_SFCR(b8001200) =1f800000

	01_8198_SFCR2(b8001204) =bb08000

	01_8198_SFCSR(b8001208) =d8350000
	
		
	---RealTek(RTL8196C)at 2014.08.29-12:43+0800 version v1.1c [16bit](390MHz)

	no sys signature at 00010000!

	no sys signature at 00020000!

	Jump to image start=0x80500000...

	decompressing kernel:
	Uncompressing Linux... done, booting the kernel.
	done decompressing kernel.
	RTL8192C-RTL8188C driver version 1.5 (2012-05-04)

	serial console detected.  Disabling virtual terminals.

	init started:  BusyBox v1.00-pre8 (2015.01.23-06:46+0000) multi-call binary



	BusyBox v1.00-pre8 (2015.01.23-06:46+0000) Built-in shell (msh)
	Enter 'help' for a list of built-in commands.

	cp: /etc/tmp/pics*: No such file or directory
	WARNING [factory_args.c:check_and_restore_factory_args:623]: current: [0x2adb521c], the length is zero!
	50
	 4.8d.38.c2.74.9c.0.0.0.0.0.0.
	save_param load /var/ppp/.pppoe.session 
	len = 0
	wlan_check.sh: do nothing......
	===================================================================================
	dnrd --cache=off  &
	WWW:netiscc, len:9

	domain:netis.cc, len:8

	WWW2:wwwnetiscc, len:13

	domain2:www.netis.cc, len:12

	killall: xhcatv: no process killed
	killall: multi_ppp: no process killed
	killall: igmpproxy: no process killed
	killall: udhcpc: no process killed
	wlanapp_sh:2042:@@@@@@@####;wlan0
	MIB_HW_TX_POWER_CCK_A=302f2f2f2f2e2e2e2e2d2d2d2d2c
	MIB_HW_TX_POWER_CCK_A_new=302f2f2f2f2e2e2e2e2d2d2d2d2c
	MIB_HW_TX_POWER_HT40_1S_A=302f2f2f2f2e2e2e2e2d2d2d2d2c
	MIB_HW_TX_POWER_HT40_1S_An=302f2f2f2f2e2e2e2e2d2d2d2d2c
	MIB_HW_TX_POWER_HT20=ffffffffffffffffffffffffffff
	MIB_HW_TX_POWER_HT20n=ffffffffffffffffffffffffffff
	MIB_HW_TX_POWER_DIFF_OFDM=6161616161616161616161616161
	MIB_HW_TX_POWER_DIFF_OFDMn=6161616161616161616161616161
	SIOCGIFFLAGS: No such device
	bridge br0 doesn't exist; can't delete it
	SIOCDELRT: No such process
	SIOCDELRT: No such process
	dhcp is dis----------------------------------------------
	wlanapp_sh:2042:@@@@@@@####;wlan0 wlan0-va0 wlan0-va1 wlan0-va2 wlan0-va3 wlan0-vxd
	iapp: not found
	wlanapp_sh:2334:wlan0:wlan0:wlan0-va3
	ip:192.168.1.1 mask:255.255.255.0 gw:192.168.1.254
	SIOCDELRT: No such process
	iwcontrol RegisterPID to (wlan0)
	* Setup Firewall
	port trigger stop.
	port trigger init, wan is eth1.
	port trigger start.
	doamin=3
	* Start NTP daemon
	/proc/sys/net/ipv4/conf/all/arp_ignore: cannot create
	/proc/sys/net/ipv4/conf/default/arp_ignore: cannot create
	iwpriv wlan0 set_mib bcnint=25--
	netis(WF2419I)-V2.12.36123,2015.06.30 16:47.
	time.windows.com: Unknown host
	========================END init.sh===============================
	321
	348
	/bin/ota_init.sh: not found
	351
	/bin/cdrom_wizard: not found
	killall: boa: no process killed
	365
	366
	telnetd.sh: not found
	# killall: boa: no process killed
	[run_webs_server_by_execv:46:restart_webs.c]
	Starting Protocol Module: HTTP Server                      ... OK
	create_server_socket-357:Bind err!caught SIGTERM, starting shutdown
	exiting Boa normally (uptime 1 seconds)
	Starting Protocol Module: HTTP Server                      ... OK

	#

Looks like we have a root command prompt. Let's try some commands:

	# ls
	bin		etc		media		sbin		tmp		var
	dev		lib		proc		sys			usr		web

	# mount
	/dev/mtdblock1 on / type squashfs (ro)
	none on /proc type proc (rw)
	tmpfs on /var type tmpfs (rw)

	# df
	Filesystem           1k-blocks      Used Available Use% Mounted on
	/dev/mtdblock1            2048      2048         0 100% /
	tmpfs                     6144       176      5968   3% /var

	# cat /proc/cmdline
	root=/dev/mtdblock1 console=0 single

	# cat /proc/cpuinfo
	system type		: Philips Nino
	processor		: 0
	cpu model		: R3000 V0.0
	BogoMIPS		: 389.12
	wait instruction	: yes
	microsecond timers	: no
	tlb_entries		: 32
	extra interrupt vector	: no
	hardware watchpoint	: no
	VCED exceptions		: not available
	VCEI exceptions		: not available
	ll emulations		: 0
	sc emulations		: 0

	# cat /proc/version
	Linux version 2.4.18-MIPS-01.00 (root@netcore) (gcc version 3.4.6-1.3.6) #1 Tue Jun 30 16:56:20 CST 2015

	# busybox
	BusyBox v1.00-pre8 (2015.01.23-06:46+0000) multi-call binary

	Usage: busybox [function] [arguments]...
	   or: [function] [arguments]...

		BusyBox is a multi-call binary that combines many common Unix
		utilities into a single executable.  Most people will create a
		link to busybox for each function they wish to use, and BusyBox
		will act like whatever it was invoked as.

	Currently defined functions:
		[, adduser, arping, bunzip2, busybox, bzcat, cat, chmod, cp, cut,
		date, df, echo, egrep, expr, false, ftpget, grep, head, ifconfig,
		init, kill, killall, klogd, ln, logger, login, ls, mkdir, mknod,
		mount, msh, passwd, ping, ps, reboot, rm, route, sh, sleep, syslogd,
		tail, test, tftp, traceroute, true, umount, vconfig, wc, wget

Quite an ancient software stack. Isn't it?

Now that we have grabbed some basic information about the system let's move on
and see what we obtain by dumping the contents of the flash.

## Dumping The Flash Contents

The flash chip was already identified by visual inspection. Time to download its 
datasheet [\[4]][4] to get the pinout and connect it to our beloved Bus Pirate 
[\[5]][5].

[figura pinout flash]

Now that we know the pinout let's figure out how to connect the chip for using
`flashrom` [\[6]][6] on it. I'll try In-System Programming (ISP) [\[7]][7]
first since it is much quicker. If this won't work the only solution is to 
desolder and resolder the flash chip from the board every time we have to read 
or program it. This is time consuming and I'd like to avoid it at all cost.

A quick reverse engineering of the traces around the chip revealed that pin 3 
and pin 7 (`/WP` and `/HOLD` respectively) which, according to [\[6]][6] should
be connected to 3.3V on the bus pirate, are already tied to the VCC pin (pin 8).
Therefore, only 6 out of 8 wires have to be connected.

Let's get back to our trusty soldering iron. Twenty minutes later, with a piece
of an old ATA cable (the 80-wire version which uses smaller conductors) we have
a nice little connector ready to be plugged into the Bus Pirate socket.

[figura adapter cable connesso to bus pirata]

To check for a successful connection the following command was issued:

	$ sudo flashrom -p buspirate_spi:dev=/dev/ttyUSB0,spispeed=2M
	[sudo] password for pol: 
	flashrom v1.2 on Linux 5.7.0-2-amd64 (x86_64)
	flashrom is free software, get the source code at https://flashrom.org

	Using clock_gettime for delay loops (clk_id: 1, resolution: 1ns).
	Found Winbond flash chip "W25Q32.V" (4096 kB, SPI) on buspirate_spi.
	No operations were specified.

Hurray! The flash chip was recognized correctly. Time to dump its contents.
	
	$ sudo flashrom -p buspirate_spi:dev=/dev/ttyUSB0,spispeed=2M -r firmware_orig.bin

Let's now extract the contents of the dump recursively to see what's inside. At
the end of the process we should have a folder named `_firmware_orig.bin.extracted`.

	$ binwalk -e firmware_orig.bin 

	DECIMAL       HEXADECIMAL     DESCRIPTION
	--------------------------------------------------------------------------------
	4976          0x1370          LZMA compressed data, properties: 0x5D, dictionary size: 8388608 bytes, uncompressed size: 68320 bytes
	207888        0x32C10         LZMA compressed data, properties: 0x5D, dictionary size: 8388608 bytes, uncompressed size: 2338816 bytes

	WARNING: Extractor.execute failed to run external extractor 'sasquatch -p 1 -le -d 'squashfs-root' '%e'': [Errno 2] No such file or directory: 'sasquatch', 'sasquatch -p 1 -le -d 'squashfs-root' '%e'' might not be installed correctly

	WARNING: Extractor.execute failed to run external extractor 'sasquatch -p 1 -be -d 'squashfs-root' '%e'': [Errno 2] No such file or directory: 'sasquatch', 'sasquatch -p 1 -be -d 'squashfs-root' '%e'' might not be installed correctly
	851968        0xD0000         Squashfs filesystem, big endian, version 2.0, size: 2076096 bytes, 389 inodes, blocksize: 65536 bytes, created: 2015-06-30 08:57:47

What are those warnings and why is my folder `squashfs-root` empty? Apparently
sasquatch is not installed in my system and `$ sudo apt search sasquatch` does
not return any result. Allright it's not the first time I have to compile and
install something from source on my system. It's strange however that the Debian
repos are missing this useful piece of software. Sasquatch is downloaded from
[\[8\]][8] and `build.sh` does all the requisite stuff for building and
installing.

Obviously this is not so easy. The building fails with a ton of messages like 
the following:

	/usr/bin/ld: unsquashfs_xattr.o:/tmp/article/sasquatch/squashfs4.3/squashfs-tools/error.h:34: multiple definition of `verbose'; unsquashfs.o:/tmp/article/sasquatch/squashfs4.3/squashfs-tools/error.h:34: first defined here
	collect2: error: ld returned 1 exit status
	make: *** [Makefile:298: sasquatch] Error 1

By looking at the issues and pull requests
[pull request #34](https://github.com/devttys0/sasquatch/pull/34) is found. We
apply it to our copy of the code and the compilation is successful. We are ready
to go ahead with our extraction.

	$ binwalk -eM firmware_orig.bin 

	Scan Time:     2020-08-21 10:55:58
	Target File:   /tmp/article/firmware_orig.bin
	MD5 Checksum:  f03a657d0fd666ef7b281b178160aa6f
	Signatures:    391

	DECIMAL       HEXADECIMAL     DESCRIPTION
	--------------------------------------------------------------------------------
	4976          0x1370          LZMA compressed data, properties: 0x5D, dictionary size: 8388608 bytes, uncompressed size: 68320 bytes
	207888        0x32C10         LZMA compressed data, properties: 0x5D, dictionary size: 8388608 bytes, uncompressed size: 2338816 bytes
	851968        0xD0000         Squashfs filesystem, big endian, version 2.0, size: 2076096 bytes, 389 inodes, blocksize: 65536 bytes, created: 2015-06-30 08:57:47


	Scan Time:     2020-08-21 10:55:59
	Target File:   /tmp/article/_firmware_orig.bin.extracted/1370
	MD5 Checksum:  b11f1fa953d791774f180b80c290370e
	Signatures:    391

	DECIMAL       HEXADECIMAL     DESCRIPTION
	--------------------------------------------------------------------------------


	Scan Time:     2020-08-21 10:55:59
	Target File:   /tmp/article/_firmware_orig.bin.extracted/32C10
	MD5 Checksum:  db44ecba377a764a82135b385d6711cd
	Signatures:    391

	DECIMAL       HEXADECIMAL     DESCRIPTION
	--------------------------------------------------------------------------------
	674704        0xA4B90         Certificate in DER format (x509 v3), header length: 4, sequence length: 31
	1517048       0x1725F8        Certificate in DER format (x509 v3), header length: 4, sequence length: 130
	1939552       0x1D9860        Linux kernel version 2.4.18
	1947112       0x1DB5E8        Unix path: /usr/lib/libc.so.1

Great. The image contains some LZMA compressed data, probably kernel and
bootlader, and a squashfs filesystem. Conveniently binwalk will extract those
files for us and sure enough we get a kernel (version 2.4.18 of course), some
certificates and the contents of our root filesystem which we are now able to
inspect and modify. The expert reader may already have noticed the first mistake
here. If nothing above looks wrong fasten your seat belt we're going deep down a
rabbit hole.

## Rebuilding the Flash Image and First Roadblocks

## Blah Blah and even More Roadblocks


## References

1. [Netis WF2419I][1]
[1]: http://www.netis-systems.com/Suppory/de_details/id/1/de/181.html

2. [Hacking Reolink Cameras For Fun and Profit][2]
[2]: https://www.thirtythreeforty.net/posts/2020/05/hacking-reolink-cameras-for-fun-and-profit/

3. [RTL8196C Datasheet][3]
[3]: https://lost-contact.mit.edu/afs/sur5r.net/service/drivers+doc/Realtek/RTL8196C%20Datasheet.pdf

4. [W25Q32FV Datasheet][4]
[4]: https://www.winbond.com/resource-files/w25q32fv%20revi%2010202015.pdf

5. [Bus_Pirate - Dangerous Prototypes][5]
[5]: http://dangerousprototypes.com/docs/Bus_Pirate

6. [Bus Pirate - flashrom][6]
[6]: https://www.flashrom.org/Bus_Pirate

7. [ISP - flashrom][7]
[7]: https://www.flashrom.org/ISP

8. [GitHub - devttys0/sasquatch][8]
[8]: https://github.com/devttys0/sasquatch
