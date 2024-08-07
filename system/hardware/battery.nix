{
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false; # Clashes with auto-cpu-freq
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };
}
