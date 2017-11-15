{ stdenv
, fetchFromGitHub
, darkhttpd
}:

let
  srcs = {
    revealjs = fetchFromGitHub {
      owner  = "hakimel";
      repo   = "reveal.js";
      rev    = "360bc940062711db9b8020ce4e848f6c37014481";
      sha256 = "0aj6y16d2wnncmamlqzimcnh56q755h62jw1g0i05ik79l97175w";
    };
    files = ./files;
    scripts = ./scripts;
  };
in
  stdenv.mkDerivation rec {
    version = "0.0.1";
    name = "mdslider-${version}";

    src = srcs.files;

    buildInputs = [ darkhttpd ];

    buildPhase = ''
      mkdir reveal.js
      cp -r ${srcs.revealjs}/* ./reveal.js/
      mkdir scripts
      cp -r ${srcs.scripts}/* ./scripts/
      patchShebangs ./scripts
    '';

    installPhase = ''
      mkdir -p $out/share/reveal.js
      cp -r ${srcs.revealjs}/* $out/share/reveal.js/
      cp -r ${srcs.files}/* $out/share/
      mkdir -p $out/scripts
      cp -r ./scripts/* $out/scripts/
      mkdir -p $out/bin
      ln -s $out/scripts/mdslider.sh $out/bin/mdslider
      ln -s ${darkhttpd}/bin/darkhttpd $out/bin/darkhttpd
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/kuznero/mdslider/;
      description = "Reveal.js based markdown slider tools (Nix)";
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ kuznero ];
      license = licenses.mit;
    };
  }
