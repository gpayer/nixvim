# Modular nixvim repository

The goal of this nixvim configuration is to have a simple way to add
a specialized instance of nixvim to your devshell.
This can be accomplished by adding a list of predefined modules according
to the specific needs.

## Modules and custom-package function

Included in this flake in `lib.${system}.nixvimModules`:

* [`default`](./config/default.nix)
* [`base`](./config/base.nix)
* ...

Function to build your custom named nixvim package:
* `custom-modules <nixvim derivation> "name-of-executable"`
