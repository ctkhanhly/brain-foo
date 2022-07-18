from BF_code_gen import gen, best, cost

curr = 0
line = input()
pos = 0
d = {}

# The algorithm only ever uses byte at indices 0 and 1
def get_clear_code():
    global pos, d
    clear_first = 0 in d and d[0]
    clear_second = 1 in d and d[1]
    clear_code = ""
    if pos == 0 and clear_first:
        clear_code += "[-]"
    if pos == 0 and clear_second:
        clear_code += ">[-]<"
    if pos == 0:
        if clear_first:
            clear_code += "[-]"
        if clear_second:
            clear_code += ">[-]<"
    elif pos == 1:
        if clear_second:
            clear_code += "[-]"
        clear_code += "<"
        if clear_first:
            clear_code += "[-]"
    return clear_code

for c in line:
    index = ord(c)
    clear_code = get_clear_code()
    if abs(curr - index) < cost(*best[index]) + len(clear_code):
        distance = index - curr
        if distance < 0:
            print('-'*(-distance) + '.')
        else:
            print('+'*distance + '.')
        d[pos] = index
    else:
        # Clear out values at indices 0 and 1
        if len(clear_code) > 0:
            print(clear_code)
        pos = 0
        # Generate code using the algorithm
        gen(index)
        a,b,_,_ = best[index]
        if a+b > 0:
            pos += 1
            d[1] = index
            d[0] = 0
        else:
            d[0] = index
        
    curr = index
        

