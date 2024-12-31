import sys, json, random, datetime
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args['id']
# TODO: change for EXAM
secret = 0
week=datetime.datetime.now().isocalendar()[0]
random.seed(secret + week + int(student_id))

m = random.randint(129, 255)
r = random.randint(129, 255)

r_bs = '{:016b}'.format(r)

no_additions = 0
r_bs = "0" + r_bs + "0"
for i in range(1, 18):
    if r_bs[i]!=r_bs[i-1]:
        no_additions += 1

# generate the question in html format
question = """
<div>
    <p>Given the 16-bit Booth's algorithm, how many additions are required for {} multiply by {} ?</p>
</div>
""".format(m, r)

print(
    json.dumps(
        {
            "question": question,
            "result": no_additions
        }
    )
)