# Ethminer Inactivity Auto Start Service

A simple script for waiting inactivity and then launch ethminer.

## Requirements

* Systemd (I know)
* Geth
* Ethminer
* A Gnome base desktop environments (Gnome, Cinnamon, Unity)

## Setup

1. Copy all unit services files and .sh files in
   `~/.config/systemd/user` `cp *.{service,sh} ~/.config/systemd/user`
1. Reload user unit files with `systemctl --user daemon-reload`
1. Setup your ethminer options with `systemctl --user edit ethminer` a
   sample is provided in `ethminer.service.d/override.conf`
1. Reload config with `systemctl --user daemon-reload`
1. Enable services `systemctl --user enable geth ethminer-auto-start`

## How it works

The `ethminer-auto-start.sh` script listen for `*.ScreenSaver` event on D-bus and then start the systemd unit `ethminer.service`.
When it receive the release `*.ScreenSaver` event it stop the service `ethminer.service`.
Currently all stuff run with your user using --user option of systemd.
