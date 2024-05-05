import time
import random
import sys

def method1(m,n): #O(bits^2)
    s=0 #sum
    while(n != 0): #while n is not zero
        if (n & 1): #if n's rightmost digit is 1
            s+=m #add m to the sum
        m = m << 1 #shift m left so it's bigger
        n = n >> 1 #shift n right to check next digit
        #print(f'{m},{n},{s}') #print steps
    return (s)
    
def method2(m,n): #O(bits^2) #shifts in size of n and adds m at that size whenever it's odd
    if n==0: #base case, if n is zero, product is zero
        return 0
    o = method2(m,n>>1) #o equals m*floor(n/2)
    if (n & 1): #if n is odd
        return (m + (o << 1)) #add m at this level and go back a level by adding 2*o
    return (o << 1) #else, just go back a level by adding 2*o
    
def method3(m,n): #O(3^(log_2(bits))) = O(bits^1.59)
    bits=max(m.bit_length(),n.bit_length())
    if (bits==1 or m==0 or n==0):
        return (n&m)
    ml = m >> (bits >> 1)
    mr = m & ((1 << (bits >> 1)) -1)
    nl = n >> (bits >> 1)
    nr = n & ((1 << (bits >> 1)) -1)

    p1=method3(ml,nl)
    p2=method3(mr,nr)
    p3=method3(ml+mr,nl+nr)
    return ((p1 << ((bits >> 1) << 1)) + ((p3-p1-p2) << (bits >> 1)) + p2)

def method4(m,n): #O(m*bits)
    return(m*n)

sys.setrecursionlimit(10**6)

mode = int(input('enter 0 for manual mode, 1 for random mode: '))
if mode: #random mode
    while 1:
        d = int(input('enter digits: '))
        r = int(input('enter runs: '))
        c = int(input('Method 1, 2, or 3 (or don\'t): '))
        times = 0
        if c==1:
            for i in range(0,r):
                a = random.getrandbits(d)
                b = random.getrandbits(d)
                start_time = time.time()
                p=method1(a,b)
                end_time = time.time()
                times = times + (end_time - start_time)
                #print(f'{a} * {b} = {p} in {end_time - start_time} seconds')
        elif c==2:
            for i in range(0,r):
                a = random.getrandbits(d)
                b = random.getrandbits(d)
                start_time = time.time()
                p=method2(a,b)
                end_time = time.time()
                times = times + (end_time - start_time)
                #print(f'{a} * {b} = {p} in {end_time - start_time} seconds')
        elif c==3:
            for i in range(0,r):
                a = random.getrandbits(d)
                b = random.getrandbits(d)
                start_time = time.time()
                p=method3(a,b)
                end_time = time.time()
                times = times + (end_time - start_time)
                #print(f'{a} * {b} = {p} in {end_time - start_time} seconds')
        else:
            for i in range(0,r):
                a = random.getrandbits(d)
                b = random.getrandbits(d)
                start_time = time.time()
                p=a*b
                end_time = time.time()
                times = times + (end_time - start_time)
                #print(f'{a} * {b} = {p} in {end_time - start_time} seconds')
        print(f'finished {r} multiplications with {d} bits with an average time of {times/r} seconds')
else: #manual mode
    while 1:

        a = int(input('Enter m: '))
        b = int(input('Enter n: '))
        c = int(input('Method 1, 2, or 3 (or don\'t): '))

        if c==1: 
            start_time = time.time()
            p=method1(a,b)
            end_time = time.time()
        elif c==2:
            start_time = time.time()
            p=method2(a,b)
            end_time = time.time()
        elif c==3:
            start_time = time.time()
            p=method3(a,b)
            end_time = time.time()
        else:
            start_time = time.time()
            p=method4(a,b)
            end_time = time.time()
        print(f'{a} * {b} = {p}')
        print(f'done in {end_time - start_time} seconds.')
