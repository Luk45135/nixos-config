{pkgs, ...}: {
  environment.systemPackages = [pkgs.git];
  nix.settings = {
    experimental-features = ["nix-command" "flakes"]; # Enabling nix commands and flakes
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://walker-git.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };
  nixpkgs.config.allowUnfree = true;
  nix.optimise.automatic = true;
}
