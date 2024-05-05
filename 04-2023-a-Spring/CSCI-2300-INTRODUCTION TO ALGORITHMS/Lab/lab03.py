import random

def modexp(x,y,N):
    if y == 0: return 1
    z = modexp(x, (y >> 1), N)
    if y&1:
        return (x*z*z)%N
    else:
        return (z*z)%N

def prime(N,k):
    for i in range(0,k):
        a = random.randint(1,N-1)
        if(modexp(a,N-1,N) != 1):
            return False
    return True

def carm(N,k,l):
    falsePositives=0
    for i in range(l):
        if(prime(N,k)):
            falsePositives += 1
    return falsePositives

a = int(input('Enter 0 for modexp, 1 for prime, 2 for carmichael prob test: '))

while 1:
    if a==0:
        x = int(input('Enter x: '))
        y = int(input('Enter y: '))
        N = int(input('Enter N: '))
        print(f'x^y mod N = {modexp(x,y,N)}') 
    elif a==1:
        N = int(input('Enter N: '))
        k = int(input('Enter k: '))
        print(f'N is prime? {prime(N,k)}')
    else:
        N = int(input('Enter N: '))
        k = 2
        print(f'k coded to {k}')
        l = int(input('Enter l: '))
        print(f'expected 1/2^k = {0.5**k}')
        f = carm(N,k,l)
        print(f'exp p = {f}/{l} = {f/l}')
