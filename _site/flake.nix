{
  description = "The blog Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: {

    packages.aarch64-darwin = {
      defaultPackage = let
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
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

    # Define a development shell for 'aarch64-darwin'
    devShell.aarch64-darwin = let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        # List of packages for development
        git
        jekyll
        ruby
        chruby
        xz
      ];
    };
  };
}
