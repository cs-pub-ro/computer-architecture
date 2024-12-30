import sys, json, random, datetime
#args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
#x=10
#random.seed(x + args['id'])
x=10
week=datetime.datetime.now().isocalendar()[0]
random.seed(x + week)

m = random.randint(129, 255)
r = random.randint(129, 255)

r_bs = '{:016b}'.format(r)

no_additions = 0
r_bs = "0" + r_bs + "0"
for i in range(1, 18):
    if r_bs[i]!=r_bs[i-1]:
        no_additions += 1

print(
    json.dumps(
        {
            'm': m,
            'r': r,
            'no_additions': no_additions
        }
    )
)
# print(m)