{ lib, ...}:

# Transforms a simplified keymap definition into a full keymap definition
#
# [
#   n = [
#         ["<esc>" "<cmd>noh<CR>" "Clear search highlight" { silent = true; raw = false;}]
#       ]
# ]
keymapdefs:

lib.lists.flatten (
    lib.attrValues (
      builtins.mapAttrs (mode: deflist: (
        builtins.map (def:

          assert lib.asserts.assertMsg (lib.lists.length def >= 3) "Keymap definition must have at least 3 elements";

          let
            def' = if lib.lists.length def >= 4 then def else def ++ [{}];
            at = lib.lists.elemAt def';
            has = (p: lib.attrsets.hasAttrByPath [p] (at 3));
            silent = has "silent";
            raw = has "raw";
          in
          {
            inherit mode;
            key = (at 0);
            action = if !raw then (at 1) else { __raw = (at 1); };
            options = {
              inherit silent;
              desc = (at 2);
            };
          })
          deflist)
        )
        keymapdefs
      )
    )
