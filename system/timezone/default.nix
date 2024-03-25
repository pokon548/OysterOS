{ config
, ...
}: {
  time.timeZone = config.prefstore.timeZone;
}
