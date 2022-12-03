# GTA San Andreas In LXC Container
> This is just my personal project while learning lxc and lxd.

## Setup
Download from https://download.freaks.dev/gtasa/gta-san-andreas.tar.gz . After downloading, run this command to import as lxc image.
```
$ lxc image import gta-san-andreas.tar.gz --alias gta-san-andreas
```
Then, you need to run the "gta-san-andreas.sh" script following by the container name you want to give.
```
$ ./gta-san-andreas.sh container_name_without_space
```
But the container name is optional. If you did not specify the container name, the script will create container with the default name "gta-san-andreas". After running the script, the command to run will be printed. You can add alias to that command for efficiency.

> This container is in privileged mode. GTA San Andreas needs sound card to work. To have sound card in container, the container need to be privileged.

> **NOTE**: When you open the game, after showing nvidia, you will see the black screen. At that time, you will need to tap spacebar or click once. Only after that, the game will process.
