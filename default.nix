{ stdenv
, fetchFromGitHub
, darkhttpd
}:

stdenv.mkDerivation rec {
  version = "0.0.1";
  name = "mdslider-${version}";

  srcs = {
    revealjs = fetchFromGitHub {
      owner  = "hakimel";
      repo   = "reveal.js";
      rev    = "360bc940062711db9b8020ce4e848f6c37014481";
      sha256 = "0aj6y16d2wnncmamlqzimcnh56q755h62jw1g0i05ik79l97175w";
    };
    index = ./index.html;
  };

  buildPhase = ''
  '';

  installPhase = ''
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kuznero/mdslider/;
    description = "Reveal.js based markdown slider tools (Nix)";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kuznero ];
    license = licenses.mit;
  };
}
