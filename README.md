# Lane Basic Library

This directory contains the Lane Basic library source.

`builtins.lane` defines the `Basic.Builtins` module with basic builtin
wrappers.
`ops.lane` defines the `Basic.Ops` module with basic operation values and
default contextual offers.
`io.lane` defines the `Basic.Io` module with conventional runtime effect
shapes such as `Write`, `Console`, and `Io`.

All modules are ordinary Lane modules. Tooling does not inject them implicitly;
users pass the needed source, interface, or object artifacts explicitly.

Example manual compilation:

```sh
lane compile builtins.lane -t Basic.Builtins.lmi -o Basic.Builtins.lmo
lane compile ops.lane -i Basic.Builtins.lmi -t Basic.Ops.lmi -o Basic.Ops.lmo
lane compile io.lane -t Basic.Io.lmi -o Basic.Io.lmo
lane compile main.lane -i Basic.Io.lmi
lane link main.lmo Basic.Io.lmo
```

Example use:

```lane
module Main

import Basic.Io.*

pub fn main() -> Unit ! Io {
  Write::println!("hello")
}
```
