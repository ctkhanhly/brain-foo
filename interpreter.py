import os

d = {}
pos = 0
loop = []
does_parse_loop = False

BYTE_ARRAY_SIZE = 30000
is_test = os.getenv("IS_TEST") == "True"

def parse(c):
    global d, pos, loop
    if pos not in d:
        d[pos] = 0
    if c == '<':
        pos = (pos - 1) % BYTE_ARRAY_SIZE
    elif c == '>':
        pos = (pos + 1) % BYTE_ARRAY_SIZE
    elif c == '+':
        d[pos] = (d[pos] + 1) % 256
    elif c == '-':
        d[pos] = (d[pos] - 1) % 256
    elif c == '.':
        if is_test:
            print(d[pos])
        else:
            print(chr(d[pos]), end='')
    elif c == ',':
        d[pos] = ord(input())
    else:
        raise Exception("Invalid argument")

def parse_loop():
    global d, pos, loop
    if pos not in d:
        d[pos] = 0
    while d[pos] != 0:
        for c in loop:
            parse(c)

while True:
    try:
        line = input()
        if is_test:
            d = {}
            pos = 0
        for c in line:
            if c == '[':
                does_parse_loop = True
            elif c == ']':
                does_parse_loop = False
                parse_loop()
                loop = []
            elif not does_parse_loop:
                parse(c)
            if does_parse_loop and c != '[':
                loop.append(c)

    except EOFError:
        break