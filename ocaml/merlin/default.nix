{ lib
, substituteAll
, ocaml
, dune_2
, buildDunePackage
, dot-merlin-reader
, yojson
, csexp
, result
}:

let
  merlinVersion = "4.4";

  ocamlVersionShorthand = lib.concatStrings
    (lib.take 2 (lib.splitVersion ocaml.version));

  version = "${merlinVersion}-${ocamlVersionShorthand}";

in

buildDunePackage {
  pname = "merlin";
  version = version;
  src =
    if (lib.versionOlder "4.13" ocaml.version) then
      builtins.fetchurl
        {
          url = https://github.com/ocaml/merlin/releases/download/v4.4-413/merlin-4.4-413.tbz;
          sha256 = "1ilmh2gqpwgr51w2ba8r0s5zkj75h00wkw4az61ssvivn9jxr7k0";
        }
    else
      if (lib.versionOlder "4.12" ocaml.version)
      then
        builtins.fetchurl
          {
            url = https://github.com/ocaml/merlin/releases/download/v4.4-412/merlin-4.4-412.tbz;
            sha256 = "18xjpsiz7xbgjdnsxfc52l7yfh22harj0birlph4xm42d14pkn0n";
          }
      else if (lib.versionOlder "4.11" ocaml.version)
      then
        builtins.fetchurl
          {
            url = https://github.com/ocaml/merlin/releases/download/v4.1-411/merlin-v4.1-411.tbz;
            sha256 = "0zckb729mhp1329bcqp0mi1lxxipzbm4a5hqqzrf2g69k73nybly";
          }
      else
        builtins.fetchurl {
          url = https://github.com/ocaml/merlin/releases/download/v3.4.2/merlin-v3.4.2.tbz;
          sha256 = "109ai1ggnkrwbzsl1wdalikvs1zx940m6n65jllxj68in6bvidz1";
        };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_2}/bin/dune";
    })
  ] ++ lib.optional (lib.versionOlder "4.12" ocaml.version) ./camlp-streams.patch;

  buildInputs = [ dot-merlin-reader yojson csexp result ];

}
