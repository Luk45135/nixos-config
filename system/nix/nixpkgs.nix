{ self, pkgs, ... }: {
  
  environment.systemPackages = [pkgs.git];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ]; # Enabling nix commands and flakes
    substituters = ["https://nix-gaming.cachix.org"]; # Enabling cachix
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="]; # and the key for it
  };
  nixpkgs.config.allowUnfree = true;
  
}