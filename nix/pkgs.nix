{ config, inputs, ... }: {
  imports = [
    inputs.my-lib.flakeModules.pkgs
  ];
  pkgsConfig = {
    overlays = [
      inputs.my-lib.overlays.default
    ];
    # systems = [ "x86_64-linux" ];
  };
  # makes available `config.pkgsFor`
}
