{
  modules',
  ...
}:
{
  imports = [
    modules'.global-persistence
    modules'.homestore
    modules'.inventor
  ];

  homestore.niri.outputConfig = {
    output = [
      {
        _args = [ "eDP-1" ];
        mode = "2880x1800@120.000";
        scale = 1.7;
        position._props = {
          x = 0;
          y = 0;
        };
      }
      {
        _args = [ "HDMI-A-1" ];
        mode = "1920x1080@60.000";
        scale = 1;
        position._props = {
          x = -1920;
          y = 0;
        };
      }
    ];
  };
}
