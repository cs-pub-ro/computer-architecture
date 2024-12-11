import sys, json, random, struct
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
random.seed(args['id'])
number=random.randint(129, 255)
number = float(number)
nhs = ''.join(f'{c:02x}' for c in struct.pack('!f', floating_point_number))
print(json.dumps({'number': number, 'nhs': nhs}))