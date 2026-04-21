# My NixOS flake

### Install sops

```bash
nix profile install nixpkgs#sops nixpkgs#age nixpkgs#ssh-to-age
```

### Create your sops secret

```bash
# macOS path for sops; on Linux, it will be ~/.config/sops/age
mkdir -p "$HOME/Library/Application Support/sops/age"
age-keygen -o "$HOME/Library/Application Support/sops/age/keys.txt"
chmod 600 "$HOME/Library/Application Support/sops/age/keys.txt"
```

Make note of the public key, this will be put in `.sops.yaml`.

### Create host sops secret

```bash
mkdir -p "$HOME/Library/Application Support/sops/age/hosts"
age-keygen -o "$HOME/Library/Application Support/sops/age/hosts/foo.txt"
chmod 600 "$HOME/Library/Application Support/sops/age/hosts/foo.txt"
```

### Add it to .sops.yaml

```
keys:
  - &will YOUR_SOPS_PUBLIC_KEY
  - &foo FOO_SOPS_PUBLIC_KEY

creation_rules:
  - path_regex: secrets/common\.yaml$
    key_groups:
      - age:
          - *will
          - *foo

  - path_regex: secrets/foo\.yaml$
    key_groups:
      - age:
          - *will
          - *foo
```

### Deploy the host sops secret to the new host

Copy the `foo.txt` to your new NixOS container as `/var/lib/sops-nix/foo.txt` (`mkdir -p /var/lib/sops-nix` first), or use `--extra-dirs` with `nixos-anywere`. Make sure it's file mode is `0400` and owned by user `root` and group `root`.

### Add your secrets

Add any secrets to `secrets/foo.yaml` by running:

```bash
mkdir -p secrets # if it didn't exist already
sops secrets/foo.yaml
```

### Make sure it's all committed to git

```bash
git add -A && git commit -m "Add host foo"
```

### Run `nixos-rebuild` to deploy

If you've cloned the `nix-config` on the host already, then perform:

```bash
cd nix-config
nixos-rebuild switch --flake .#foo
```

If you're using another computer to orchestrate:

```bash
cd nix-config
nixos-rebuild switch --flake .#foo \
  --target-host root@foo.home.johansson.io \
  --build-host nixbuilder@playground.home.johansson.io
```

`--build-host` is only needed if the computer you're running `nixos-rebuild` does not match the CPU architecture and OS of the target, as I am doing with my M3 MacBook Pro. `playground` is my `linux-x86_64` NixOS builder.