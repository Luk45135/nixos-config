{pkgs, ...}: {
  environment.systemPackages = [pkgs.git];
  nix.settings = {
    experimental-features = ["nix-command" "flakes"]; # Enabling nix commands and flakes
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://cosmic.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };
  nixpkgs.config.allowUnfree = true;
}
