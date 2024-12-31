import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

m = random.randint(0, 255)
r = random.randint(0, 255)

result = 0

# operations = ['+', '-', 'x', '/', ]
# selected_operation = random.choice(operations)

# if selected_operation == '+':
#     result = m + r
# elif selected_operation == '-':
#     result = m - r
# elif selected_operation == 'x':
#     result = m * r
# elif selected_operation == '/':
#     result = m / r


result = m + r
result_bs = '{:08b}'.format(result)
m_bs = '{:08b}'.format(m)
r_bs = '{:08b}'.format(r)
m_sign = 1 if m_bs[0] == '1' else 0
r_sign = 1 if r_bs[0] == '1' else 0

# compute the flags
zero_flag = 1
carry_flag = 1 if result > 255 else 0
sign_flag = 1 if result_bs[0] == '1' else 0
overflow_flag = 1 if m_sign == r_sign and m_sign != sign_flag else 0
parity_flag = 0

for i in range(8):
    if result_bs[i] == '1':
        parity_flag += 1
        zero_flag = 0
parity_flag = 1 if parity_flag % 2 == 0 else 0

flag_register_bs = str(zero_flag) + str(carry_flag) + str(sign_flag) + str(overflow_flag) + str(parity_flag)
# generate the html question
question = """
<div>
    <p>What is teh binary representation of the the 5-bit status flags register (order from left Zero Flag, Carry Flag, Sign Flag, Overflow Flag, Parity Flag) after the 8-bit operation {} plus {} ?</p>
</div>
""".format(m, r)

print(
    json.dumps(
        {
            "question": question,
            "result": flag_register_bs
        }
    )
)