{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["JetBrainsMono" "DroidSansMono"];})
    roboto
    source-sans
    source-sans-pro
  ];
}
