{ config
, ...
}: {
  environment.etc.issue = {
    text = config.prefstore.slogan;
  };
}