{
  programs.mpv = {
    enable = true;
    config = {
      ytdl-format = "bestvideo+bestaudio";
      ao = "pulse";
      audio-device = "auto";
      hwdec = "auto-safe";
      vo = "gpu";
      profile = "gpu-hq";
      gpu-context = "wayland";
    };
  };
}
