# Lane Standard Library

This directory contains Lane standard library source.

`builtins.lane` defines the `Builtins` module with standard builtin wrappers.
`ops.lane` defines the `Ops` module with standard operation values and default
contextual offers.
`stdlib.lane` defines the `Stdlib` module with conventional runtime effect
shapes such as `Write`, `Console`, and `Io`.

All modules are ordinary Lane modules. Tooling does not inject them implicitly;
users pass the needed source, interface, or object artifacts explicitly.

Example manual compilation:

```sh
lane compile stdlib.lane -t Stdlib.lmi -o Stdlib.lmo
lane compile main.lane -i Stdlib.lmi
lane link main.lmo Stdlib.lmo
```
