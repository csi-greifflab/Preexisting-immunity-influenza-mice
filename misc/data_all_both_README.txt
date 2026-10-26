data_all_both.xz - README
=========================

Compressed with xz (51 MB). Contains the RDS file `data_all_both` (~1.3 GB).
Note: the original gzip-wrapped file was replaced by this xz archive, which
restores to the raw RDS (readable by R directly).

Decompress
----------
xz -dk data_all_both.xz
  -> creates `data_all_both` (~1.3 GB); the .xz file is kept (-k)

Recompress (if needed)
----------------------
xz -9 -k data_all_both

Read in R (no extraction needed)
--------------------------------
readRDS(xzfile("data_all_both.xz"))

Or after decompressing:
readRDS("data_all_both")

Verify integrity
----------------
xz -t data_all_both.xz
