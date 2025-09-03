### Usage

cd-like features:

`z <key>` takes you to the directory associated with `<key>`.

`z <directory>` changes to `<directory>`

plain `z` changes to the home directory.

`zz` changes to the previous directory.

`z -a <key> <directory>`:

- adds this map to data base
- changes to `<directory>`

### Error handling

`z pic` with pic not mapped yet will give
```
no such key or directory: pic
```

`z -a pic` with pic not mapped yet will give
```
z: invalid target directory []
```

`z -a` will give
```
z: Option -a requires an argument.
```
handled by `getopts` loop

note that double quotes are needed in `[ -n "$there" ]`, cuz `test -n ` will return true but `test -n ""` will return false

TODO: modify exiting mapping

currently, `-a` an existing key does nothing
which means it doesn't check if followed by a directory either

because it doesn't enter the if block
should add else

TODO: rename to zi and za

TODO: zz should now allow arguments
