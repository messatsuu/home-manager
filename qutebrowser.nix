{ pkgs, ... }:
{
  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      from qutebrowser.api import interceptor
      import os


      def filter_yt(info: interceptor.Request):
          """Block the given request if necessary."""
          url = info.request_url
          if (
              url.host() == "www.youtube.com"
              and url.path() == "/get_video_info"
              and "&adformat=" in url.query()
          ):
              info.block()
      interceptor.register(filter_yt)

      from urllib.request import urlopen

      # load your autoconfig, use this, if the rest of your config is empty!
      config.load_autoconfig()

      if not os.path.exists(config.configdir / "theme.py"):
          theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
          with urlopen(theme) as themehtml:
              with open(config.configdir / "theme.py", "a") as file:
                  file.writelines(themehtml.read().decode("utf-8"))

      if os.path.exists(config.configdir / "theme.py"):
          import theme
          theme.setup(c, 'macchiato', True)

      c.tabs.padding = {"bottom": 10, "left": 10, "right": 10, "top": 10}
    '';

    searchEngines = {
      DEFAULT =  "https://google.com/search?hl=en&q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      hm = "https://home-manager-options.extranix.com/?query={}&release=release-25.05";
      no = "https://search.nixos.org/options?channel=25.05&from=0&size=50&sort=relevance&type=packages&query={}";
    };

    settings = {
      # General
      tabs = {
        position = "left";
      };

      statusbar.position = "top";
      # Fonts
      fonts.default_size = "15pt";
      fonts.default_family = "JetBrainsMono Nerd Font";
      colors.webpage.darkmode.enabled = true;
    };

    keyBindings = {
      normal = {
        "e" = "cmd-set-text -s :open -t";
        "E" = "cmd-set-text -s :open -p";
        "i" = "hint --first inputs";
        "I" = "hint inputs";
        "." = "mode-enter insert";
        # URL shortcuts
        "<Space>c" = "open https://chatgpt.com";
        "<Space>g" = "open https://github.com/messatsuu";
        ">" = "tab-move +";
        "<" = "tab-move -";
        "w" = "open -w";
        "W" = "tab-give";
      };
    };
  };
}
