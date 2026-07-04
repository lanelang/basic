# Lane Standard Library

This directory contains Lane standard library source.

`builtins.lane` defines the `Stdlib.Builtins` module with standard builtin
wrappers.
`ops.lane` defines the `Stdlib.Ops` module with standard operation values and
default contextual offers.
`io.lane` defines the `Stdlib.Io` module with conventional runtime effect
shapes such as `Write`, `Console`, and `Io`.

All modules are ordinary Lane modules. Tooling does not inject them implicitly;
users pass the needed source, interface, or object artifacts explicitly.

Example manual compilation:

```sh
lane compile builtins.lane -t Stdlib.Builtins.lmi -o Stdlib.Builtins.lmo
lane compile ops.lane -i Stdlib.Builtins.lmi -t Stdlib.Ops.lmi -o Stdlib.Ops.lmo
lane compile io.lane -t Stdlib.Io.lmi -o Stdlib.Io.lmo
lane compile main.lane -i Stdlib.Io.lmi
lane link main.lmo Stdlib.Io.lmo
```

Example use:

```lane
module Main

import Stdlib.Io.*

pub fn main() -> Unit ! Io {
  Write::println!("hello")
}
```
