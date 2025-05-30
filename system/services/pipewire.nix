{pkgs, ...}: {
  # Install pwvucontroll for pipewire management
  environment.systemPackages = with pkgs; [
    pwvucontrol
    qpwgraph
  ];

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
  };
}
