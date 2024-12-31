import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

def calculate_cache_parameter(cachesize, blocksize, cachemapping, associativity, addressbits, questiontag):
    # Calculate the number of blocks in the cache
    cache_size_bytes = cachesize * 1024
    number_of_blocks = cache_size_bytes // blocksize

    # Calculate the number of sets in the cache
    if cachemapping == 'direct':
        number_of_sets = number_of_blocks
    elif cachemapping == 'fully-associative':
        number_of_sets = 1
    elif cachemapping == 'set-associative':
        number_of_sets = number_of_blocks // associativity

    # Calculate the number of bits for the block offset
    block_offset_bits = blocksize.bit_length() - 1

    # Calculate the number of bits for the index
    index_bits = number_of_sets.bit_length() - 1

    # Calculate the number of bits for the tag
    tag_bits = addressbits - index_bits - block_offset_bits

    if questiontag == 'tag':
        return tag_bits
    elif questiontag == 'index':
        return index_bits
    elif questiontag == 'block offset':
        return block_offset_bits
    else:
        return addressbits

# Define the possible values for the cache size, block size, cache mapping, and associativity
cache_sizes_in_KBytes = [16, 32, 64, 128, 256, 512, 1024, 2048, 4096]
block_sizes_in_bytes = [8, 16, 32, 64, 128, 256, 512, 1024]
cache_mapping = ['direct', 'set-associative', 'fully-associative']
associativities = [2, 4, 8]
address_bits = [32, 64]
question_tags = ['tag', 'index', 'block offset']


# Randomly select one value from each list
selected_cache_size = random.choice(cache_sizes_in_KBytes)
selected_block_size = random.choice(block_sizes_in_bytes)
selected_cache_mapping = random.choice(cache_mapping)
selected_address_bits = random.choice(address_bits)
selected_question_tag = random.choice(question_tags)

# If the cache mapping is set-associative, randomly select the associativity
if selected_cache_mapping == 'set-associative':
    selected_associativity = random.choice(associativities)
else:
    selected_associativity = 0

# Calculate the cache parameter
selected_cache_parameter = calculate_cache_parameter(
    selected_cache_size, selected_block_size, selected_cache_mapping, selected_associativity, selected_address_bits, selected_question_tag
)

if selected_cache_mapping == 'set-associative':
    selected_cache_mapping = str(selected_associativity) + '-way set-associative'


# generate the html question
question = """
<div>
    <p>Calculate the number of bits for the {} for a cache memory with the following characteristics:</p>
    <ul>
        <li>Cache size: {} KB</li>
        <li>Block size: {} bytes</li>
        <li>Mapping: {}</li>
    </ul>
    <p>The address space is {} bits.</p>
</div>
""".format(
    selected_question_tag,
    selected_cache_size,
    selected_block_size,
    selected_cache_mapping,
    selected_address_bits
)
# Print the selected values
print(
    json.dumps(
        {
            'question': question,
            'result': selected_cache_parameter
        }
    )
)
