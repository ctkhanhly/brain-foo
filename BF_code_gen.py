best = [(-1,0,0,0)] * 256
init = False

def cost(a,b,s,k):
    extras = 6 if a+b > 0 else 0
    return a+b+abs(s) + abs(k) + extras

def calc(c):
    if c == 0:
        return (0,0,0,0)
    found = False
    for a in range(2,51):
        for s in range(-50, 51):
            if s == 0:
                continue
            for t in range(0,256):
                if (-t*a+s) % 256 == 0:
                    for b in range(0,51):
                        if t * b % 256 != c:
                            continue
                        found = True
                        if best[c][0] == -1 or cost(*best[c]) > cost(a,b,s,0):
                            best[c] = (a,b,s,0)
                    break
    if not found:
        print(f"c: {c}, Not found!")

def run():
    best[0] = (0,0,0,0)
    for c in range(103, 103+256):
        calc(c%256)
        a,b,s,k = best[c%256]

    mx = 0
    mn = float('inf')
    best_left = [(-1,0,0,0)] * 256
    best_right = [(-1,0,0,0)] * 256
    for c in range(0, 256):
        span = 10
        best_left[c] = best[c]
        for i in range(-span,0):
            if 0 <= c + i < 256:
                a,b,s,k = best_left[c]
                ai,bi,si,ki = best_left[c+i]
                if ai + bi + abs(si) +abs(ki-i) < a + b + abs(s) + abs(k) or (a == -1 and ai != -1):
                    best_left[c] = (ai,bi,si,ki-i) 
    
    for c in range(255,-1,-1):
        span = 10
        best_right[c] = best[c]
        for i in range(1,span):
            if 0 <= c + i < 256:
                a,b,s,k = best_right[c]
                ai,bi,si,ki = best_right[c+i]
                if ai + bi + abs(si) +abs(ki-i) < a + b + abs(s) + abs(k) or (a == -1 and ai != -1):
                    best_right[c] = (ai,bi,si,ki-i)

    for c in range(0,256):
        best[c] = best_left[c]
        al,bl,sl,kl = best_left[c]
        ar,br,sr,kr = best_right[c]
        if al + bl + abs(sl) + abs(kl) < ar + br + abs(sr) + abs(kr):
            best[c] = best_left[c]
        else:
            best[c] = best_right[c]
        a,b,s,k = best[c]

def gen(c):
    global init, best
    if not init:
        run()
        init = True
    a,b,s,k = best[c]
    if s >= 0:
        print('+'*(s), end='')
    else:
        print('-'*(-s), end='')
    if a + b > 0:
        print('[', end='')
        if a:
            print('-'*a, end='')
        if b:
            print('>' + '+'*b + '<', end='')
        print(']>', end= '')
    if k >= 0:
        print('+'*(k), end='')
    else:
        print('-'*(-k), end='')
    print('.')