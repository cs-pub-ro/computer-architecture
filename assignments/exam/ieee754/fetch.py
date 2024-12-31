import sys, json, random, datetime, struct
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

# define the problem
# Generate a random number between 129 and 255
number=random.randint(129, 255)
floating_point_number = float(number)
nhs = ''.join(f'{c:02x}' for c in struct.pack('!f', floating_point_number))
# generate the question in html
question = """
<div>
    <p>Given the following hexadecimal string 0x{} in big endian format of an 32-bit IEEE754 floating-point, what is the value of it?</p>
</div>
""".format(nhs)
result = floating_point_number

print(
    json.dumps({
        "question": question,
        "result": result
    })
)