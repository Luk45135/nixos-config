{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukasd = {
    isNormalUser = true;
    description = "Lukas Dorji";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel" 
    ];
  };
  programs.zsh.enable = true;
}