{pkgs, ...}: {
  environment.systemPackages = [pkgs.git];
  nix.settings = {
    trusted-users = [ "root" "@wheel" ];
    experimental-features = ["nix-command" "flakes"]; # Enabling nix commands and flakes
    substituters = [
      "https://cache.nixos.org?priority=10"

      "https://nix-gaming.cachix.org"
      "https://cosmic.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "dotnet-runtime-7.0.20"
      "dotnet-sdk-wrapped-7.0.410"
      "dotnet-sdk-7.0.410"
    ];
  };
  nix.optimise.automatic = true;
}
