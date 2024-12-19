text = open('control_unit.v', 'r').read()
anyintxt = True
while anyintxt:
    anyintxt = False
    lookfor = f"`OK"
    while lookfor in text:
        text = text.replace(lookfor, "")
        anyintxt = True

print(text, file=open('control_unit.v', 'w'))
