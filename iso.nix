{config, pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/982457a29a0ba35d0a6d3647c0f53ce130a12866.tar.gz") {}, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  environment.systemPackages = with pkgs; [
    yubikey-manager
    pinentry
    pinentry-curses
    cryptsetup
    pwgen
    paperkey
    qrencode
    gnupg
    ctmg
    neovim
  ];

  environment.shellInit = ''
    export GNUPGHOME=/run/user/$(id -u)/gnupghome
    if [ ! -d $GNUPGHOME ]; then
      mkdir $GNUPGHOME
      cp ${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/drduh/config/75ec3f35c6977722d4dba17732d526f704f256ff/gpg.conf";
        sha256 = "sha256-LK29P4+ZAvy9ObNGDNBGP/8+MIUY3/Uo4eJtXhwMoE0=";
      }} "$GNUPGHOME/gpg.conf"
      echo "pinentry-program $(which pinentry-curses)" > "$GNUPGHOME/gpg-agent.conf"
    fi
    cp ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/drduh/YubiKey-Guide/master/README.md";
      sha256 = "9ffe70c51529682aedf21050e47819857714498864fe6717666ab56975b3eae0";
    }} "$HOME/README.md"
    echo "Documentation will be in $HOME/README.md."
  '';

  services.pcscd.enable = true;
  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  # make sure we are air-gapped
  networking.wireless.enable = false;
  networking.dhcpcd.enable = false;
}
