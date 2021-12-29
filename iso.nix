{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    cryptsetup
    pwgen
    paperkey
    qrencode
    gnupg
    ctmg
    neovim
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    export GNUPGHOME=/run/user/$(id -u)/gnupghome
    if [ ! -d $GNUPGHOME ]; then
      mkdir $GNUPGHOME
    fi
    cp ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/drduh/config/75ec3f35c6977722d4dba17732d526f704f256ff/gpg.conf";
      sha256 = "sha256-LK29P4+ZAvy9ObNGDNBGP/8+MIUY3/Uo4eJtXhwMoE0=";
    }} "$GNUPGHOME/gpg.conf"
    cp ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/drduh/YubiKey-Guide/master/README.md";
      sha256 = "9ffe70c51529682aedf21050e47819857714498864fe6717666ab56975b3eae0";
    }} "$HOME/README.md"
    echo "Documentation will be in $HOME/README.md."
  '';

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services.pcscd.enable = true;
  programs.gnupg.agent.pinentryFlavor = "curses";

  # make sure we are air-gapped
  networking.wireless.enable = false;
  networking.dhcpcd.enable = false;
}
