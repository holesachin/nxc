
## build nixos
```shell
sudo nixos-rebuild switch --impure --flake ~/nixos#nixos
```

## list older genrations
```shell
nixos-rebuild list-generations 
```
or
```shell
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
```

## delete older genrations but keep latest x.
```shell
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +21
```

# wifi hardware
04:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8852BE-VT PCIe 802.11ax Wireless Network Controller

# nbfc-linux config
https://raw.githubusercontent.com/nbfc-linux/configs/refs/heads/main/1.0/configs/HP%20Victus%2015-fb0xxx.json
