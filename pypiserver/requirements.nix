# generated using pypi2nix tool (version: 2.0.0)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -W https://travis.garbas.si/wheels_cache/ -v -V 3.7 -O ../overrides.nix -s setuptools-git -r requirements.txt
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python37;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            if [ -e $out/${pkgs.python37.sitePackages}/pip/req/req_install.py ]; then
              sed -i \
                -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"  \
                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"  \
                $out/${pkgs.python37.sitePackages}/pip/req/req_install.py
            fi
          '';
        });
      };
  };

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python37-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "passlib" = python.mkDerivation {
      name = "passlib-1.7.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz";
        sha256 = "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/ecollins/passlib";
        license = licenses.bsdOriginal;
        description = "comprehensive password hashing framework supporting over 30 schemes";
      };
    };

    "pypiserver" = python.mkDerivation {
      name = "pypiserver-1.2.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f8/50/fdb53daad3eeac92f447b74289fad68e625f0b09cfb54ad9b76de823cce2/pypiserver-1.2.5.zip";
        sha256 = "7785e6bd2b8593722a6e40b8c25a9f67c2c3502ebbdff399c3d48deb92e0e7fa";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."passlib"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypiserver/pypiserver";
        license = "UNKNOWN";
        description = "A minimal PyPI server for use with pip/easy_install.";
      };
    };

    "setuptools-git" = python.mkDerivation {
      name = "setuptools-git-1.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d9/c5/396c2c06cc89d4ce2d8ccf1d7e6cf31b33d4466a7c65a67a992adb3c6f29/setuptools-git-1.2.tar.gz";
        sha256 = "ff64136da01aabba76ae88b050e7197918d8b2139ccbf6144e14d472b9c40445";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/wichert/setuptools-git";
        license = licenses.bsdOriginal;
        description = "Setuptools revision control system plugin for Git";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
        (import ../overrides.nix { inherit pkgs python ; })
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )