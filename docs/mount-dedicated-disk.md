# Mount disks.

Using a dedicated disk for the node database is highly recommended. The installation process assumes that there is a `/data` directory that will contain the executables, configuration files and data for the node.

First we identify the disks available in the system:

```sh
$ lsblk
```
If it does not appear you should check if it was created correctly in your infrastructure provider.

Format the disk, for example, in `ext4` filesystem, and add the `alastria-b` label for the data disk.

```sh
$ sudo mkfs.ext4 -L alastria-b /dev/xvd__X__
```

Create the `/data` directory where the disk will be mounted.

```sh
$ sudo mkdir /data
```

Add this line at the end of `/etc/fstab` file so that the `alastria-b` disk is always mounted on restart in `/data` directory. The number `0` in the next column indicates that the filesystem does not use the dump utility (nobody uses _that_ nowadays! :upside_down_face:) and the number `2` in the last column indicates that this filesystem should be checked after the system partition.

```sh
$ sudo vi /etc/fstab 

[...]
LABEL=alastria-b        /data   ext4    defaults,discard        0 2
```

Mount the disk in the designated path.

```sh
$ sudo mount /data
```

Test if the partition has been mounted correctly.

```sh
$ df -h

Filesystem      Size  Used Avail Use% Mounted on
udev            2.0G     0  2.0G   0% /dev
tmpfs           394M  752K  393M   1% /run

[...]
/dev/sd__X__        32G  2.3G   28G   8% /data
```