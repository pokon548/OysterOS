{ config
, options
, ...
}: {
  time.timeZone = config.prefstore.timeZone;
  networking.timeServers = [ "cn.pool.ntp.org" "cn.ntp.org.cn" "ntp1.nim.ac.cn" "ntp.ntsc.ac.cn" ] ++ options.networking.timeServers.default;
}
