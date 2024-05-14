{ pkgs
, ...
}:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
      # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
      # (only supported by chromium/chrome at this time, not electron)
      "--gtk-version=4"
      # enable hardware acceleration - vulkan api
      "--enable-features=Vulkan"
    ];
  };

  home = {
    global-persistence.directories = [ ".config/chromium" ];
  };
}
