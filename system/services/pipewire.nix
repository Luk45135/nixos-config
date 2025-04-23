{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  # Install pwvucontroll for pipewire management
  environment.systemPackages = with pkgs; [pwvucontrol];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = false;
    # alsa.support32Bit = false;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    lowLatency = {
      enable = true;
      quantum = 32;
      rate = 48000;
    };
  };
}
