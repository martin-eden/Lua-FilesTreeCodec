<table>
  <tr>
    <th colspan=3>Files tree codec</th>
  </tr>
  <tr>
    <td>
      <table>
        <tr>
          <th>Input</th>
          <th>Output</th>
        </tr>
        <tr>
          <td>directory</td>
          <td>file</td>
        </tr>
        <tr>
          <td>file</td>
          <td>directory</td>
        </tr>
      </table>
    </td>
    <td align=center>
      Codec between directory and file<br>
      <br>
      Stores files in directory as one file. Restores back.
      Minimalistic format: only file names and data are stored.
    </td>
    <td>
      <table>
        <tr>
          <th>Code size</th>
          <th>💾</th>
        </tr>
        <tr>
          <td align=right>60 K &gt;</td>
          <td>
            <a href="deploy/files_tree"><code>files_tree</code></a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <table>
      <tr>
        <th>Updated</th>
        <td>2026-10-03</td>
      </tr>
      <tr>
        <th>Created</th>
        <td>2026-10</td>
      </tr>
      <tr>
        <th>License</th>
        <td>LGPL3</td>
      </tr>
      <tr>
        <td colspan=2 align=center>
          <a href="https://deepwiki.com/martin-eden/Lua-FilesTreeCodec">
            <img src="https://deepwiki.com/badge.svg">
          </a>
        </td>
      </tr>
    </table>
  </tr>
</table>


## Usage

```
Codec between several files and one file

Usage: <action> <input_name> <output_name>

  <action> -- what to do. One of:

    export -- combine files
      from <input_name> directory to <output_name> file

    import -- decombine files
      from <input_name> file to <output_name> directory

-- Martin, 2026-10
```


## Shipment

Repository contains

  * Compiled code in [`deploy/`](deploy/)
  * Sample input and output in [`test/`](test/)
  * Complete source code in [`src/`](src/)
  * Rebuild script and tools in [`builder/`](builder/)


## Requirements

* Linux
* Lua 5.5 (5.4, 5.3) (`$ sudo apt install lua`)


## Notes

This can be considered an archiver

(Archiver is program that combines several files into one.
Don't mistake it with "compressor" -- program that encodes data stream
in hope that output data will be shorter.)

Beauty here in features that are absent:

  * Data format

    * No magic tags

      No signature for file type. You have to know what it is.

    * No length fields

      Data is processed as stream of bytes. So we don't need
      checks that data span is inside file span.

    * No integrity fields

      We don't see point in storing fixed-length value of data
      (aka "hash").

    * No file attributes (except name)

      No storage of access rights, owners, creation/modification dates
      etc.

  * Silence

    No cries like: "Mommy, mommy! Data here is not what we're expected!".
    Or: "Look mom, we started decoding data!".

* What is actually stored

  File name and file data. As sequence of pairs.
  Encoded in Itness (strings tree) format.

  For example files `input/dad.txt` and `input/mom.txt` with contents
  `Hey dad!` and `Hi mommy!\n` may be encoded as
  ```
  ( input/dad.txt Hey[ dad!] )
  ( input/mom.txt Hi[ mommy!
  ] )
  ```

* Practically it means that you can..

  * View "archive" in text editor (maybe even modify it)
  * Write your own format codec under one hour (if you can program)
  * Write this tool under one hour (if you have suitable framework)


## See also

* [`file_as_img`][file_as_img] -- my codec between file and image
* [`meld`][meld] -- my encoder to combine Lua files
* [`workshop`][workshop] -- my personal Lua framework
* [My other projects][contents]

[file_as_img]: https://github.com/martin-eden/Lua-BinToImg
[meld]: https://github.com/martin-eden/lua_code_melder
[workshop]: https://github.com/martin-eden/workshop
[contents]: https://github.com/martin-eden/contents
