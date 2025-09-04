# ZipZap around directories

### Usage

`zi <key>` takes you to the directory associated with `<key>`.

`zi <directory>` changes to `<directory>`

plain `zi` changes to the home directory.

`za` changes to the previous directory.

`zi -a <key> <directory>`:

- adds this map to data base
- changes to `<directory>`

### Error handling

`zi pic` with pic not mapped yet will give
```
zz: No such key or directory: pic
```

`zi -a pic` with pic not mapped yet will give
```
zz: Invalid target directory []
```

`zi -a` will give
```
zz: Option -a requires an argument.
```
handled by `getopts` loop

note that double quotes are needed in `[ -n "$there" ]`, cuz `test -n ` will return true but `test -n ""` will return false

and other

### TODOs

- function `zl` to load data after file is modified by user
- za should not allow arguments
- `zi -l` to list all mappings
- `zi -d <key>` to delete a mapping
