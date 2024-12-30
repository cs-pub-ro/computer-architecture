import sys, json, random, datetime
#args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
#x=10
#random.seed(x + args['id'])
x=10
week=datetime.datetime.now().isocalendar()[0]
random.seed(x + week)

def calculate_no_gates_ripple_carry_adder(n, order):
    return n * 5

def calculate_no_gates_kogge_stone_adder(n, order):
    return n * 3 + 3 * n * order - 3 * n + 3

def calculate_no_gates_brent_kung_adder(n, order):
    return n * 3 + 6 * n - 6 - 3 * order

def path_carry_out_ripple_carry_adder(n, order):
    return n * 3

def path_carry_out_kogge_stone_adder(n, order):
    return 2 * order + 1

def path_carry_out_brent_kung_adder(n, order):
    return 2 * order + 1

# Define the possible values for the number of bits
order_of_bits = [x for x in range(4, 5, 6)]
adder_types = ['ripple-carry adder', 'kogge-stone CLA', 'brent-kung CLA']
question_types = ['gates', 'carry-out path']
questions = ['How many gates are in a {}-bit {}?', 'How many gates are in the carry-out path are in a {}-bit {}?']
selected_order_of_bits = random.choice(order_of_bits)
selected_adder_type = random.choice(adder_types)
selected_no_bits = 2 ** selected_order_of_bits
selected_question_type = random.choice(question_types)

answer = 0

if selected_question_type == 'gates':
    if selected_adder_type == 'ripple-carry adder':
        answer = calculate_no_gates_ripple_carry_adder(selected_no_bits, selected_order_of_bits)
    elif selected_adder_type == 'kogge-stone CLA':
        answer = calculate_no_gates_kogge_stone_adder(selected_no_bits, selected_order_of_bits)
    elif selected_adder_type == 'brent-kung CLA':
        answer = calculate_no_gates_brent_kung_adder(selected_no_bits, selected_order_of_bits)
elif selected_question_type == 'carry-out path':
    if selected_adder_type == 'ripple-carry adder':
        answer = path_carry_out_ripple_carry_adder(selected_no_bits, selected_order_of_bits)
    elif selected_adder_type == 'kogge-stone CLA':
        answer = path_carry_out_kogge_stone_adder(selected_no_bits, selected_order_of_bits)
    elif selected_adder_type == 'brent-kung CLA':
        answer = path_carry_out_brent_kung_adder(selected_no_bits, selected_order_of_bits)

question = questions[question_types.index(selected_question_type)].format(selected_no_bits, selected_adder_type)

print(
    json.dumps(
        {
            'question': question,
            'answer': answer
        }
    )
)
