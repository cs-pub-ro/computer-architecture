import sys, json, random
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
random.seed(args['id'])

def calculate_miss_penalty(access_time, block_size, byte_transfer_times):
    return access_time + (block_size * byte_transfer_times)

def calculate_amat(hit_time, miss_rate, miss_penalty):
    return hit_time + (miss_rate * miss_penalty)


# Define the possible values for the cache size, block size, cache mapping, and associativity
cache_sizes_in_KBytes = [16, 32, 64, 128, 256, 512, 1024, 2048, 4096]
block_sizes_in_bytes = [8, 16, 32, 64, 128, 256, 512, 1024]
cache_mapping = ['direct', 'set-associative', 'fully-associative']
associativities = [2, 4, 8]
main_memory_access_times = [x * 10 for x in range(12, 20)]
cache_hit_times = [x * 2 for x in range(3, 5)]
main_memory_byte_transfer_times = [x * 4 for x in cache_hit_times]
cache_miss_rates = [float(x)/100 for x in range(6, 10)]


# Randomly select one value from each list
selected_cache_size = random.choice(cache_sizes_in_KBytes)
selected_block_size = random.choice(block_sizes_in_bytes)
selected_cache_mapping = 'direct'
selected_main_memory_access_time = random.choice(main_memory_access_times)
selected_cache_hit_time = random.choice(cache_hit_times)
selected_main_memory_byte_transfer_time = random.choice(main_memory_byte_transfer_times)
selected_cache_miss_rate = random.choice(cache_miss_rates)

# select values for a modified cache in associativity
selected_new_cache_mapping = 'set-associative'
selected_new_associativity = random.choice(associativities)
selected_new_cache_hit_time = selected_cache_hit_time  * random.choice([1.5, 2, 2.5])
selected_new_cache_miss_rate = selected_cache_miss_rate - random.choice([0.02, 0.03, 0.04])

initial_miss_penalty = calculate_miss_penalty(selected_main_memory_access_time, selected_block_size, selected_main_memory_byte_transfer_time)
initial_amat = calculate_amat(selected_cache_hit_time, selected_cache_miss_rate, initial_miss_penalty)
new_miss_penalty = calculate_miss_penalty(selected_main_memory_access_time, selected_block_size, selected_main_memory_byte_transfer_time)
new_amat = calculate_amat(selected_new_cache_hit_time, selected_new_cache_miss_rate, new_miss_penalty)
speedup = initial_amat / new_amat

selected_new_cache_mapping = str(selected_new_associativity) + '-way set-associative'

# Print the selected values
print(
    json.dumps(
        {
            'cachesize': selected_cache_size,
            'blocksize': selected_block_size,
            'cachemapping': selected_cache_mapping,
            'mainmemoryaccesstime': selected_main_memory_access_time,
            'cachehitime': selected_cache_hit_time,
            'mainmemorybytetransfertime': selected_main_memory_byte_transfer_time,
            'cachemissrate': selected_cache_miss_rate * 100,
            'newcachemapping': selected_new_cache_mapping,
            'newcachehitime': selected_new_cache_hit_time,
            'newcachemissrate': selected_new_cache_miss_rate * 100,
            'speedup': speedup
        }
    )
)
