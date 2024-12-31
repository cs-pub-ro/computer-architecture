import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

# define the problem
# Generate a random number between 129 and 255
number=random.randint(129, 255)
# Convert the number to binary and hexadecimal
nbs = '{:08b}'.format(number)
nhs = '0x{:02x}'.format(number)

# generate the question in html
question = """
<div>
    <p>Convert the hexadecimal number {} in big endian format to integer value (no sign) </p>
</div>
""".format(nhs)

result = number

print(
    json.dumps({
        "question": question,
        "result": result
    })
)