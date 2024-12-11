We have a cache system with the following characteristics:
 - One level cache
 - Main memory access time: {{ mainmemoryaccesstime }}
 - Main memory byte transfer time: {{ mainmemorybytetransfertime }}
 - Cache hit time: {{ cachehitime }}
 - Cache miss rate: {{ cachemissrate }}%
 - Cache block size: {{ blocksize }} bytes
 - Cache size: {{ cachesize }} KB
 - Cache Mapping: {{ cachemapping }}

What is the speedup in average memory access time (AMAT) if we change the following characteristics:
 - Cache hit time: {{ newcachehitime }}
 - Cache miss rate: {{ newcachemissrate }}%
 - Cache size: {{ newcachesize }} KB
