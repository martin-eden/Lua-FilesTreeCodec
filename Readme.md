This can be considered an archiver

(Archiver is program that combines several files into one.
Don't mistake it with "compressor" -- program that encodes data stream
in hope that output data will be shorter.)

Beauty here (as usual) in what features are absent:

  * Data format

    * No magic tags

      No signature for file type. You have to know what it is.

    * No length fields

      Data is processed as stream of bytes. So we don't need
      checks that data span is inside file span.

    * No integrity fields

      We don't see point in storing fixed-length value of data
      (aka "hash").

    * No file attributes except name

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

-- Martin, 2026-10-02
