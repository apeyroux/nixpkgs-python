# generated using pypi2nix tool (version: 2.0.0)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -W https://travis.garbas.si/wheels_cache/ -v -V 3.7 -O ../overrides.nix -s pytest-runner -s setuptools-scm -s versiontools -r requirements.txt
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
    "Chameleon" = python.mkDerivation {
      name = "Chameleon-3.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d0/59/ad925b5d098117fd6f339e6f7f29f98400ea11c5377f531ac55625909a5e/Chameleon-3.5.tar.gz";
        sha256 = "cb0f97211faf03b46bf30e517c0e589bdc4a6cf678a9d1d68312d710849303a9";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://chameleon.readthedocs.io";
        license = "BSD-like (http://repoze.org/license.html)";
        description = "Fast HTML/XML Template Compiler.";
      };
    };

    "Jinja2" = python.mkDerivation {
      name = "Jinja2-2.10";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz";
        sha256 = "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."MarkupSafe"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://jinja.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A small but fast and easy to use stand-alone template engine written in pure python.";
      };
    };

    "Mako" = python.mkDerivation {
      name = "Mako-1.0.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz";
        sha256 = "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."MarkupSafe"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.makotemplates.org/";
        license = licenses.mit;
        description = "A super-fast templating language that borrows the  best ideas from the existing templating languages.";
      };
    };

    "MarkupSafe" = python.mkDerivation {
      name = "MarkupSafe-1.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ac/7e/1b4c2e05809a4414ebce0892fe1e32c14ace86ca7d50c70f00979ca9b3a3/MarkupSafe-1.1.0.tar.gz";
        sha256 = "4e97332c9ce444b0c2c38dd22ddc61c743eb208d916e4265a2a3b575bdccb1d3";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.palletsprojects.com/p/markupsafe/";
        license = licenses.bsdOriginal;
        description = "Safely add untrusted strings to HTML/XML markup.";
      };
    };

    "PasteDeploy" = python.mkDerivation {
      name = "PasteDeploy-2.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/19/a0/5623701df7e2478a68a1b685d1a84518024eef994cde7e4da8449a31616f/PasteDeploy-2.0.1.tar.gz";
        sha256 = "d423fb9d51fdcf853aa4ff43ac7ec469b643ea19590f67488122d6d0d772350a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [
        self."pytest-runner"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pylonsproject.org/";
        license = licenses.mit;
        description = "Load, configure, and compose WSGI applications and servers";
      };
    };

    "Pygments" = python.mkDerivation {
      name = "Pygments-2.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/69/413708eaf3a64a6abb8972644e0f20891a55e621c6759e2c3f3891e05d63/Pygments-2.3.1.tar.gz";
        sha256 = "5ffada19f6203563680669ee7f53b64dabbeb100eb51b61996085e99c03b284a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };

    "SQLAlchemy" = python.mkDerivation {
      name = "SQLAlchemy-1.2.15";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0c/7d/769c5fc22c0cdefd097b91cc525b6d8c88bf2afd8b0315b1e7ca088956b4/SQLAlchemy-1.2.15.tar.gz";
        sha256 = "809547455d012734b4252081db1e6b4fc731de2299f3755708c39863625e1c77";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.sqlalchemy.org";
        license = licenses.mit;
        description = "Database Abstraction Library";
      };
    };

    "WebOb" = python.mkDerivation {
      name = "WebOb-1.8.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e4/6c/99e322c3d4cc11d9060a67a9bf2f7c9c581f40988c11fffe89bb8c36bc5e/WebOb-1.8.4.tar.gz";
        sha256 = "a48315158db05df0c47fbdd061b57ba0ba85bdd0b6ea9dca87511b4b7c798e99";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://webob.org/";
        license = licenses.mit;
        description = "WSGI request and response object";
      };
    };

    "colander" = python.mkDerivation {
      name = "colander-1.5.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ec/d1/fcca811a0a692c69d27e36b4d11a73acb98b4bab48323442642b6fd4386d/colander-1.5.1.tar.gz";
        sha256 = "d86b9e1fb42c80c68b26040e32dad584aa168abf3175133b36f5dace392350a1";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."iso8601"
        self."translationstring"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.pylonsproject.org/projects/colander/en/latest/";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "A simple schema-based serialization and deserialization library";
      };
    };

    "deform" = python.mkDerivation {
      name = "deform-2.0.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cf/a1/bc234527b8f181de9acd80e796483c00007658d1e32b7de78f1c2e004d9a/deform-2.0.7.tar.gz";
        sha256 = "2ff29c32ebe544c0f0a77087e268b2cd9cb4b11fa35af3635d5b42913f88d74a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Chameleon"
        self."Pygments"
        self."colander"
        self."iso8601"
        self."peppercorn"
        self."pyramid"
        self."translationstring"
        self."zope.deprecation"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.pylonsproject.org/projects/deform/en/latest/";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "Form library with advanced features like nested forms";
      };
    };

    "gevent" = python.mkDerivation {
      name = "gevent-1.3.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/10/c1/9499b146bfa43aa4f1e0ed1bab1bd3209a4861d25650c11725036c731cf5/gevent-1.3.7.tar.gz";
        sha256 = "3f06f4802824c577272960df003a304ce95b3e82eea01dad2637cc8609c80e2c";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."greenlet"
        self."zope.event"
        self."zope.interface"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.gevent.org/";
        license = licenses.mit;
        description = "Coroutine-based network library";
      };
    };

    "gevent-socketio" = python.mkDerivation {
      name = "gevent-socketio-0.3.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/57/8f/16b508f602cff2dd506636b8d415e39cacb3400d49e885f002bf6436a777/gevent-socketio-0.3.6.tar.gz";
        sha256 = "53394ab93fbd84d9dbbb2bef85349f6a503bfc53d86a9be8653250f1a0412aff";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."gevent"
        self."gevent-websocket"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/abourget/gevent-socketio";
        license = licenses.bsdOriginal;
        description = "SocketIO server based on the Gevent pywsgi server, a Python network library";
      };
    };

    "gevent-websocket" = python.mkDerivation {
      name = "gevent-websocket-0.10.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/98/d2/6fa19239ff1ab072af40ebf339acd91fb97f34617c2ee625b8e34bf42393/gevent-websocket-0.10.1.tar.gz";
        sha256 = "7eaef32968290c9121f7c35b973e2cc302ffb076d018c9068d2f5ca8b2d85fb0";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."gevent"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.gitlab.com/noppo/gevent-websocket";
        license = "Copyright 2011-2017 Jeffrey Gelens <jeffrey@noppo.pro>";
        description = "Websocket handler for the gevent pywsgi server, a Python network library";
      };
    };

    "greenlet" = python.mkDerivation {
      name = "greenlet-0.4.15";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f8/e8/b30ae23b45f69aa3f024b46064c0ac8e5fcb4f22ace0dca8d6f9c8bbe5e7/greenlet-0.4.15.tar.gz";
        sha256 = "9416443e219356e3c31f1f918a91badf2e37acf297e2fa13d24d1cc2380f8fbc";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python-greenlet/greenlet";
        license = licenses.mit;
        description = "Lightweight in-process concurrent programming";
      };
    };

    "hupper" = python.mkDerivation {
      name = "hupper-1.4.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f1/75/1915dc7650b4867fa3049256e24ca8eddb5989998fcec788cf52b9812dfc/hupper-1.4.2.tar.gz";
        sha256 = "eb3778398658a011c96e620adcd73175f306f880a6d86b2ebb6d2a15a74b6b9b";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Pylons/hupper";
        license = licenses.mit;
        description = "Integrated process monitor for developing and reloading daemons.";
      };
    };

    "iso8601" = python.mkDerivation {
      name = "iso8601-0.1.12";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz";
        sha256 = "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/micktwomey/pyiso8601";
        license = licenses.mit;
        description = "Simple module to parse ISO 8601 dates";
      };
    };

    "peppercorn" = python.mkDerivation {
      name = "peppercorn-0.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e4/77/93085de7108cdf1a0b092ff443872a8f9442c736d7ddebdf2f27627935f4/peppercorn-0.6.tar.gz";
        sha256 = "96d7681d7a04545cfbaf2c6fb66de67b29cfc42421aa263e4c78f2cbb85be4c6";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.pylonsproject.org/projects/peppercorn/en/latest/";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "A library for converting a token stream into a data structure for use in web form posts";
      };
    };

    "plaster" = python.mkDerivation {
      name = "plaster-1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/37/e1/56d04382d718d32751017d32f351214384e529b794084eee20bb52405563/plaster-1.0.tar.gz";
        sha256 = "8351c7c7efdf33084c1de88dd0f422cbe7342534537b553c49b857b12d98c8c3";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.pylonsproject.org/projects/plaster/en/latest/";
        license = "UNKNOWN";
        description = "A loader interface around multiple config file formats.";
      };
    };

    "plaster-pastedeploy" = python.mkDerivation {
      name = "plaster-pastedeploy-0.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3f/e7/6a6833158d2038ec40085433308a1e164fd1dac595513f6dd556d5669bb8/plaster_pastedeploy-0.6.tar.gz";
        sha256 = "c231130cb86ae414084008fe1d1797db7e61dc5eaafb5e755de21387c27c6fae";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."PasteDeploy"
        self."plaster"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Pylons/plaster_pastedeploy";
        license = "UNKNOWN";
        description = "A loader implementing the PasteDeploy syntax to be used by plaster.";
      };
    };

    "pyramid" = python.mkDerivation {
      name = "pyramid-1.10.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0a/3e/22e3ac9be1b70a01139adba8906ee4b8f628bb469fea3c52f6c97b73063c/pyramid-1.10.1.tar.gz";
        sha256 = "37c3e1c9eae72817e0365e2a38143543aee8b75240701fa5cb3a1be86c01a1c0";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."WebOb"
        self."hupper"
        self."plaster"
        self."plaster-pastedeploy"
        self."translationstring"
        self."venusian"
        self."zope.deprecation"
        self."zope.interface"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://trypyramid.com";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "The Pyramid Web Framework, a Pylons project";
      };
    };

    "pyramid-chameleon" = python.mkDerivation {
      name = "pyramid-chameleon-0.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8a/cd/ae2f1f2c547884bc6fa16aa607d21f8e85a0b7997b0ba6426e35212b1e2d/pyramid_chameleon-0.3.tar.gz";
        sha256 = "d176792a50eb015d7865b44bd9b24a7bd0489fa9a5cebbd17b9e05048cef9017";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Chameleon"
        self."pyramid"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Pylons/pyramid_chameleon";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "pyramid_chameleon";
      };
    };

    "pyramid-debugtoolbar" = python.mkDerivation {
      name = "pyramid-debugtoolbar-4.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/14/28/1f240239af340d19ee271ac62958158c79edb01a44ad8c9885508dd003d2/pyramid_debugtoolbar-4.5.tar.gz";
        sha256 = "74c5f52ce33765423810e156949b0f97852c66056c97de8c35a6db9b00195774";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Pygments"
        self."pyramid"
        self."pyramid-mako"
        self."repoze.lru"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.pylonsproject.org/projects/pyramid-debugtoolbar/en/latest/";
        license = licenses.bsdOriginal;
        description = "A package which provides an interactive HTML debugger for Pyramid application development";
      };
    };

    "pyramid-deform" = python.mkDerivation {
      name = "pyramid-deform-0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f3/92/707f6e725aa9585179fc4919f7ef710815732bc54885a209b584d903c3c3/pyramid_deform-0.2.tar.gz";
        sha256 = "09a73ceb0d351a20b3b85ded31fbf417b4756bafefd620cfd488202e2ad0fb7c";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."deform"
        self."pyramid"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.pylonshq.com";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "Bindings to the Deform form library for the Pyramid web framework";
      };
    };

    "pyramid-exclog" = python.mkDerivation {
      name = "pyramid-exclog-1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c5/a8/96449fdda3abfd2eb4dad075b25b9252856be84040f35c8194d55c80f345/pyramid_exclog-1.0.tar.gz";
        sha256 = "d05ced5c12407507154de6750036bc83861b85c11be70b3ec3098c929652c14b";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyramid"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.pylonsproject.org";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "A package which logs to a Python logger when an exception is raised by a Pyramid application";
      };
    };

    "pyramid-jinja2" = python.mkDerivation {
      name = "pyramid-jinja2-2.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d8/80/d60a7233823de22ce77bd864a8a83736a1fe8b49884b08303a2e68b2c853/pyramid_jinja2-2.7.tar.gz";
        sha256 = "5c21081f65a5bec0b76957990c2b89ed41f4fd11257121387110cb722fd0e5eb";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Jinja2"
        self."MarkupSafe"
        self."pyramid"
        self."zope.deprecation"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Pylons/pyramid_jinja2";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "Jinja2 template bindings for the Pyramid web framework";
      };
    };

    "pyramid-mako" = python.mkDerivation {
      name = "pyramid-mako-1.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f1/92/7e69bcf09676d286a71cb3bbb887b16595b96f9ba7adbdc239ffdd4b1eb9/pyramid_mako-1.0.2.tar.gz";
        sha256 = "6da0987b9874cf53e72139624665a73965bbd7fbde504d1753e4231ce916f3a1";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Mako"
        self."pyramid"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Pylons/pyramid_mako";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "Mako template bindings for the Pyramid web framework";
      };
    };

    "pyramid-socketio" = python.mkDerivation {
      name = "pyramid-socketio-0.9";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f3/e8/47482965df3757ff629bd356f41e0ff7f090dabeb7da745688791ff12ecc/pyramid_socketio-0.9.tar.gz";
        sha256 = "b4ec2ca36d8f423cffde85887d266af3b84cdf4d2fd54b7f58c476d9329756ec";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."gevent"
        self."gevent-socketio"
        self."gevent-websocket"
        self."greenlet"
        self."pyramid"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/abourget/pyramid_socketio";
        license = "UNKNOWN";
        description = "Gevent-based Socket.IO pyramid integration and helpers";
      };
    };

    "pyramid-sqlalchemy" = python.mkDerivation {
      name = "pyramid-sqlalchemy-1.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f8/ef/1a7350be383d58efb806f1192ff09a8b2764082ef69719a20d2424d213b4/pyramid_sqlalchemy-1.6.tar.gz";
        sha256 = "377a18834e15ff59ba89c882be7d40bdc92ab5ad39a881ff2eba111b84f2418b";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."SQLAlchemy"
        self."zope.sqlalchemy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pyramid-sqlalchemy.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "SQLAlchemy integration for pyramid";
      };
    };

    "pyramid-tm" = python.mkDerivation {
      name = "pyramid-tm-2.2.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f3/06/bd2a87e1af0653a4f1800c508f5a9e63b822ddea8eb38d52628a27e78c1b/pyramid_tm-2.2.1.tar.gz";
        sha256 = "fde97db9d92039a154ca6afffdd2485874c7d3e7a6432adb51b7a60810bad422";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyramid"
        self."transaction"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.pylonsproject.org/projects/pyramid-tm/en/latest/";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "A package which allows Pyramid requests to join the active transaction";
      };
    };

    "pyramid-who" = python.mkDerivation {
      name = "pyramid-who-0.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2e/09/664840034d88a3e68a6c4256723da769e7a18a2edcde99b304340ca3e43b/pyramid_who-0.3.tar.gz";
        sha256 = "ab682af0bd1c105184ad2fd417f3557c36e7bf803b1b290fa8325ce1ff83302d";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyramid"
        self."repoze.who"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.pylonshq.com";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "Pyramid authentication policies based on repoze.who";
      };
    };

    "pyramid-zcml" = python.mkDerivation {
      name = "pyramid-zcml-1.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/af/d7/57102753dd1731e17b8b038733ba1ab8237e0b55c8898d434133fcb4cae7/pyramid_zcml-1.1.0.tar.gz";
        sha256 = "94cdb26ab1db58d20c405af48fb7ac00d7a68eb8b3089d242be1b05fb82239fb";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyramid"
        self."pyramid-mako"
        self."venusian"
        self."zope.configuration"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docs.pylonsproject.org/projects/pyramid_zcml/en/latest/";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "Zope Config Markup Language support for Pyramid";
      };
    };

    "pytest-runner" = python.mkDerivation {
      name = "pytest-runner-4.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9e/b7/fe6e8f87f9a756fd06722216f1b6698ccba4d269eac6329d9f0c441d0f93/pytest-runner-4.2.tar.gz";
        sha256 = "d23f117be39919f00dd91bffeb4f15e031ec797501b717a245e377aee0f577be";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [
        self."setuptools-scm"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pytest-runner";
        license = "UNKNOWN";
        description = "Invoke py.test as distutils command with dependency resolution";
      };
    };

    "repoze.lru" = python.mkDerivation {
      name = "repoze.lru-0.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/12/bc/595a77c4b5e204847fdf19268314ef59c85193a9dc9f83630fc459c0fee5/repoze.lru-0.7.tar.gz";
        sha256 = "0429a75e19380e4ed50c0694e26ac8819b4ea7851ee1fc7583c8572db80aff77";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.repoze.org";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "A tiny LRU cache implementation and decorator";
      };
    };

    "repoze.who" = python.mkDerivation {
      name = "repoze.who-2.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/19/ae/94cdd6ea2d3f79a1430993ee044da1ea6fb547675e0d0ca958c71009ddde/repoze.who-2.3.tar.gz";
        sha256 = "b95dadc1242acc55950115a629cfb1352669774b46d22def51400ca683efea28";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."WebOb"
        self."zope.interface"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.repoze.org";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "repoze.who is an identification and authentication framework for WSGI.";
      };
    };

    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-3.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/09/b4/d148a70543b42ff3d81d57381f33104f32b91f970ad7873f463e75bf7453/setuptools_scm-3.1.0.tar.gz";
        sha256 = "1191f2a136b5e86f7ca8ab00a97ef7aef997131f1f6d4971be69a1ef387d8b40";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.12.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz";
        sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "transaction" = python.mkDerivation {
      name = "transaction-2.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9d/7d/0e8af0d059e052b9dcf2bb5a08aad20ae3e238746bdd3f8701a60969b363/transaction-2.4.0.tar.gz";
        sha256 = "726059c461b9ec4e69e5bead6680667a3db01bf2adf901f23e4031228a0f9f9f";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."zope.interface"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/transaction";
        license = licenses.zpl21;
        description = "Transaction management for Python";
      };
    };

    "translationstring" = python.mkDerivation {
      name = "translationstring-1.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5e/eb/bee578cc150b44c653b63f5ebe258b5d0d812ddac12497e5f80fcad5d0b4/translationstring-1.3.tar.gz";
        sha256 = "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pylonsproject.org";
        license = "BSD-like (http://repoze.org/license.html)";
        description = "Utility library for i18n relied on by various Repoze and Pyramid packages";
      };
    };

    "venusian" = python.mkDerivation {
      name = "venusian-1.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/38/24/b4b470ab9e0a2e2e9b9030c7735828c8934b4c6b45befd1bb713ec2aeb2d/venusian-1.1.0.tar.gz";
        sha256 = "9902e492c71a89a241a18b2f9950bea7e41d025cc8f3af1ea8d8201346f8577d";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pylonsproject.org";
        license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
        description = "A library for deferring decorator actions";
      };
    };

    "versiontools" = python.mkDerivation {
      name = "versiontools-1.9.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/37/a0/2de15402f69bc054fd57d1ef7278a52a9be474682e374d6bc60abde27f8f/versiontools-1.9.1.tar.gz";
        sha256 = "a969332887a18a9c98b0df0ea4d4ca75972f24ca94f06fb87d591377e83414f6";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://launchpad.net/versiontools";
        license = "UNKNOWN";
        description = "Smart replacement for plain tuple used in __version__";
      };
    };

    "zope.configuration" = python.mkDerivation {
      name = "zope.configuration-4.3.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5c/59/46de8bdebaed1dd10bdfc2f089509994d2acf4d9860e3422219077b7247f/zope.configuration-4.3.0.tar.gz";
        sha256 = "ddd162b7b9379c0f5cc060cbf2af44133396b7d26eaee9c7cf6e196d87e9aeb3";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."zope.i18nmessageid"
        self."zope.interface"
        self."zope.schema"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.configuration";
        license = licenses.zpl21;
        description = "Zope Configuration Markup Language (ZCML)";
      };
    };

    "zope.deprecation" = python.mkDerivation {
      name = "zope.deprecation-4.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/34/da/46e92d32d545dd067b9436279d84c339e8b16de2ca393d7b892bc1e1e9fd/zope.deprecation-4.4.0.tar.gz";
        sha256 = "0d453338f04bacf91bbfba545d8bcdf529aa829e67b705eac8c1a7fdce66e2df";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.deprecation";
        license = licenses.zpl21;
        description = "Zope Deprecation Infrastructure";
      };
    };

    "zope.event" = python.mkDerivation {
      name = "zope.event-4.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4c/b2/51c0369adcf5be2334280eed230192ab3b03f81f8efda9ddea6f65cc7b32/zope.event-4.4.tar.gz";
        sha256 = "69c27debad9bdacd9ce9b735dad382142281ac770c4a432b533d6d65c4614bcf";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/zopefoundation/zope.event";
        license = licenses.zpl21;
        description = "Very basic event publishing system";
      };
    };

    "zope.i18nmessageid" = python.mkDerivation {
      name = "zope.i18nmessageid-4.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d8/0b/2b09daacbe377581125e181b5db32156db1dc4accbeb6efbbdcdb22377f0/zope.i18nmessageid-4.3.1.tar.gz";
        sha256 = "e511edff8e75d3a6f84d8256e1e468c85a4aa9d89c2ea264a919334fae7081e3";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.i18nmessageid";
        license = licenses.zpl21;
        description = "Message Identifiers for internationalization";
      };
    };

    "zope.interface" = python.mkDerivation {
      name = "zope.interface-4.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4e/d0/c9d16bd5b38de44a20c6dc5d5ed80a49626fafcb3db9f9efdc2a19026db6/zope.interface-4.6.0.tar.gz";
        sha256 = "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."zope.event"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.interface";
        license = licenses.zpl21;
        description = "Interfaces for Python";
      };
    };

    "zope.schema" = python.mkDerivation {
      name = "zope.schema-4.9.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/42/eb/23663ac53661641340f74cb27647f5dcdde63fc4629b4a4c1a0a29c049dc/zope.schema-4.9.3.tar.gz";
        sha256 = "2d971da8707cab47b1916534b9929dcd9d7f23aed790e6b4cbe3103d5b18069d";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."zope.event"
        self."zope.interface"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.schema";
        license = licenses.zpl21;
        description = "zope.interface extension for defining data schemas";
      };
    };

    "zope.sqlalchemy" = python.mkDerivation {
      name = "zope.sqlalchemy-1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/75/13/b88b597ef6027b5480f68e022206e4b3ee2310a59bbc85bd3e9eca9566b6/zope.sqlalchemy-1.0.tar.gz";
        sha256 = "9316a1a8bb9e4f9f59332acf1ad2cc8b664f19a4bde5f68be7f61f3e11f80514";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."SQLAlchemy"
        self."transaction"
        self."zope.interface"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pypi.python.org/pypi/zope.sqlalchemy";
        license = licenses.zpl21;
        description = "Minimal Zope/SQLAlchemy transaction integration";
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