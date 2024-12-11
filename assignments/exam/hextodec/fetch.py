import sys, json, random
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
random.seed(args['id'])
number=random.randint(129, 255)
nbs = '{:08b}'.format(number)
nhs = '{:02x}'.format(number)
print(json.dumps({'number': number, 'nbs': nbs, 'nhs': nhs}))