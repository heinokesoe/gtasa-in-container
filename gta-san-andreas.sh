#!/bin/bash
set -e

# You can change the container name here
container_name=${1:-"gta-san-andreas"}

# Create its own storage for gtasa if it doesn't exist
# Btrfs-progs is required for this
if ! lxc storage list | grep gtasa &>/dev/null; then
    lxc storage create gtasa btrfs size=10GB
fi

# Download image and creat container
lxc launch local:gta-san-andreas $container_name --storage gtasa

# Sound card is needed to run gta. To get access to sound card, the container need to be privileged.
lxc config set $container_name security.privileged true

# Add gpu to container
lxc config device add $container_name mygpu gpu

# Add sound card to container
for i in $(find /dev/snd -type c | cut -d'/' -f4); do
	lxc config device add $container_name $i unix-char path=/dev/snd/"$i"
done
lxc config set $container_name raw.lxc "lxc.cgroup.devices.allow = c 116:* rwm"
lxc config set $container_name raw.lxc "lxc.mount.entry = /dev/snd dev/snd none bind,optional,create=dir 0 0"

# Give display access to container
if ! grep -E "SI" <<< $(xhost) > /dev/null ; then
        xhost +si:localuser:$(id -un) > /dev/null
fi
lxc config device add $container_name X0 proxy listen=unix:@/tmp/.X11-unix/$(ls /tmp/.X11-unix) connect=unix:@/tmp/.X11-unix/X0 bind=container security.uid=$(id -u) security.gid=$(id -g)

lxc restart $container_name

user_shell=$(echo $SHELL)
echo 
echo "GTA San Andreas is ready to play."
echo "Run this command: >>> lxc exec --user 1000 --env TERM=linux --env DISPLAY=:0 --env QT_X11_NO_MITSHM=1 $container_name -- start-gta <<<"
echo "You can add alias to that command in your .${user_shell##*/}rc file."
