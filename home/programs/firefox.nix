{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.lukasd = {
      search = {
        force = true;
        default = "SearXNG";
        engines = {
          "SearXNG" = {
            urls = [{ template = "https://searxng.local.lukastech.top/?q={searchTerms}"; }];
            iconMapObj."16" = "https://searxng.local.lukastech.top/favicon.ico";
            definedAliases = ["@sx"];
          };
        };
      };
      settings = {
        "browser.startup.homepage" = "https://homepage.local.lukastech.top";
      };
      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        # enhancer-for-youtube
        fastforwardteam
        return-youtube-dislikes
        sponsorblock
        greasemonkey
        ublock-origin
      ];
    };
  };
}
