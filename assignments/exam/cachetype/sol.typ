== Problem

Calculate the tag, index, and block-offset widths for a cache with these characteristics:

- Cache size: 64 KB
- Block size: 16 bytes
- Organization: 4-way set associative
- Address space: 32 bits

== Solution

Calculate the number of cache blocks:

$ "Number of blocks" = (64 times 1024) / 16 = 4096 $

Calculate the number of sets:

$ "Number of sets" = 4096 / 4 = 1024 $

The block-offset width is:

$ "Block offset bits" = log_2(16) = 4 "bits" $

The index width is:

$ "Index bits" = log_2(1024) = 10 "bits" $

For a 32-bit address, the tag width is:

$ "Tag bits" = 32 - 10 - 4 = 18 "bits" $

Therefore:

- Tag: 18 bits
- Index: 10 bits
- Block offset: 4 bits