import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

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
cache_hit_times = [x * 2 for x in range(1, 3)]
main_memory_byte_transfer_times = [x * 4 for x in cache_hit_times]
cache_miss_rates = [float(x)/100 for x in range(4, 7)]


# Randomly select one value from each list
selected_cache_size = random.choice(cache_sizes_in_KBytes)
selected_block_size = random.choice(block_sizes_in_bytes)
selected_cache_mapping = 'direct'
selected_main_memory_access_time = random.choice(main_memory_access_times)
selected_cache_hit_time = random.choice(cache_hit_times)
selected_main_memory_byte_transfer_time = random.choice(main_memory_byte_transfer_times)
selected_cache_miss_rate = random.choice(cache_miss_rates)

# select values for a modified cache in block size
selected_new_block_size = random.choice([x for x in block_sizes_in_bytes if x != selected_block_size])
if selected_new_block_size > selected_block_size:
    selected_new_cache_hit_time = selected_cache_hit_time + random.choice([-1, 1, 2])
    selected_new_cache_miss_rate = selected_cache_miss_rate - random.choice([0.01, 0.02, 0.03])
else:
    selected_new_cache_hit_time = selected_cache_hit_time + random.choice([-1, 1, 2])
    selected_new_cache_miss_rate = selected_cache_miss_rate + random.choice([0.01, 0.02, 0.03])

initial_miss_penalty = calculate_miss_penalty(selected_main_memory_access_time, selected_block_size, selected_main_memory_byte_transfer_time)
initial_amat = calculate_amat(selected_cache_hit_time, selected_cache_miss_rate, initial_miss_penalty)
new_miss_penalty = calculate_miss_penalty(selected_main_memory_access_time, selected_new_block_size, selected_main_memory_byte_transfer_time)
new_amat = calculate_amat(selected_new_cache_hit_time, selected_new_cache_miss_rate, new_miss_penalty)
speedup = initial_amat / new_amat

# generate the html question
question = """
<div>
    <p>We have a cache system with the following characteristics:</p>
    <ul>
        <li>One level cache</li>
        <li>Main memory access time: {}</li>
        <li>Main memory byte transfer time: {}</li>
        <li>Cache hit time: {}</li>
        <li>Cache miss rate: {}%</li>
        <li>Cache block size: {} bytes</li>
        <li>Cache size: {} KB</li>
        <li>Cache Mapping: {}</li>
    </ul>
    <p>What is the speedup in average memory access time (AMAT) if we change the following characteristics:</p>
    <ul>
        <li>Cache hit time: {}</li>
        <li>Cache miss rate: {}%</li>
        <li>Cache block size: {} bytes</li>
    </ul>
</div>
""".format(
    selected_main_memory_access_time,
    selected_main_memory_byte_transfer_time,
    selected_cache_hit_time,
    selected_cache_miss_rate * 100,
    selected_block_size,
    selected_cache_size,
    selected_cache_mapping,
    selected_new_cache_hit_time,
    selected_new_cache_miss_rate * 100,
    selected_new_block_size
)

# Print the selected values
print(
    json.dumps(
        {
            'question': question,
            'result': speedup
        }
    )
)
