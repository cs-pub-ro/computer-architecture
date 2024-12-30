We have a cache system with the following characteristics:
 - One level cache
 - Main memory access time: {{ mainmemoryaccesstime }}
 - Main memory byte transfer time: {{ mainmemorybytetransfertime }}
 - Cache hit time: {{ cachehitime }}
 - Cache miss rate: {{ cachemissrate }}%
 - Cache block size: {{ blocksize }} bytes
 - Cache size: {{ cachesize }} KB
 - Cache Mapping: {{ cachemapping }}

What is the speedup in average memory access time (AMAT) if we add a seconde-level cache with the following characteristics:
 - Cache hit time: {{ cache2hitime }}
 - Cache miss rate: {{ cache2missrate }}%
 - Cache block size: {{ cache2blocksize }} bytes
 - Cache size: {{ cache2size }} KB
 - Cache Mapping: {{ cache2mapping }}
