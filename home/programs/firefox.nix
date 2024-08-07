{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      Preferences = {
        "browser.startup.homepage" = "https://homepage.local.lukastech.xyz";
      };
    };
    profiles.lukasd = {
      search = {
        force = true;
        # default = "Startpage - English";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
        };
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        buster-captcha-solver
        clearurls
        decentraleyes
        #enhancer-for-youtube
        fastforwardteam
        mal-sync
        omnivore
        return-youtube-dislikes
        sponsorblock
        startpage-private-search
        greasemonkey
        translate-web-pages
        ublock-origin
        user-agent-string-switcher
      ];
    };
  };
}
