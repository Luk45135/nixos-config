{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ ungoogled-chromium ]; # https://sayodevice.com for configuration (chromium based browsers only)
  services.udev.extraRules = builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "lerh050";
      repo = "o3c";
      rev = "1ddf6ef749d70a2bcfe1d7158d0606d19a203a06";
      sha256 = "sha256-JBUvjE4siAMlSrTXkDKK4W30CjQjts519ZnV58EnbGM=";
    } + "/98-saybot.rules"
  );
}
