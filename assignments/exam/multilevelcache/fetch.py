import sys, json, random, datetime
#args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
#x=10
#random.seed(x + args['id'])
x=10
week=datetime.datetime.now().isocalendar()[0]
random.seed(x + week)

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
cache2_miss_rates = [float(x)/20 for x in range(8, 12)]


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
selected_new_cache_hit_time = selected_cache_hit_time  * random.choice([5, 6, 7, 8])
selected_new_cache_miss_rate = random.choice(cache2_miss_rates)
selected_new_block_size = selected_block_size
selected_new_cache_size = selected_cache_size * 16

initial_miss_penalty = calculate_miss_penalty(selected_main_memory_access_time, selected_block_size, selected_main_memory_byte_transfer_time)
initial_amat = calculate_amat(selected_cache_hit_time, selected_cache_miss_rate, initial_miss_penalty)
cache2_miss_penalty = calculate_miss_penalty(selected_main_memory_access_time, selected_new_block_size, selected_main_memory_byte_transfer_time)
cache2_amat = calculate_amat(selected_new_cache_hit_time, selected_new_cache_miss_rate, cache2_miss_penalty)
new_miss_penalty = cache2_amat
new_amat = calculate_amat(selected_cache_hit_time, selected_cache_miss_rate, new_miss_penalty)
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
            'cache2mapping': selected_new_cache_mapping,
            'cache2hitime': selected_new_cache_hit_time,
            'cache2missrate': selected_new_cache_miss_rate * 100,
            'cache2size': selected_new_cache_size,
            'cache2blocksize': selected_new_block_size,
            'speedup': speedup
        }
    )
)
