{
  description = "The blog Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    packages."aarch64-darwin".defaultPackage = let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [
        # general tools
        git
        jekyll
        ruby
        chruby
        xz
      ];
    };
  };
}
