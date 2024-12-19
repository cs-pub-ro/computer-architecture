text = open('control_unit.v', 'r').read()
anyintxt = True
while anyintxt:
    anyintxt = False
    for i in range(16):
        lookfor = f"`IR{i}"
        while lookfor in text:
            text = text.replace(lookfor, "")
            anyintxt = True
    while "`OK" in text:
        text = text.replace("`OK", "")
        anyintxt = True

print(text, file=open('control_unit.v', 'w'))
