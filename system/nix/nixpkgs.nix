{pkgs, ...}: {
  environment.systemPackages = [pkgs.git];
  nix.settings = {
    experimental-features = ["nix-command" "flakes"]; # Enabling nix commands and flakes
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://walker.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };
  nixpkgs.config.allowUnfree = true;
}
