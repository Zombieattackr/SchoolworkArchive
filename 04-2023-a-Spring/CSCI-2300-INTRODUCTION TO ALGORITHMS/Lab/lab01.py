import time

def fib1(n):
    if n==0: return 0
    if n==1: return 1
    return (fib1(n-1)+fib1(n-2))
    
def fib2(n):
    if n==0: return 0
    f=[ ]
    f.append(0)
    f.append(1)
    for i in range (2, n+1):
        f.append(f[i-1]+f[i-2])
    return f[n]
    
while 1:

    a = int(input('Enter n: '))
    b = int(input('Enter 0 or 1: '))

    start_time = time.time()
    if not b: #replce prints to get linear time??? test this later
        #print(f'the {a}th number in the fibonacci sequence is {fib1(a-1)}.')
	p=fib1(a-1)
    else:
        #print(f'the {a}th number in the fibonacci sequence is {fib2(a-1)}.')
	p=fib2(a-1)
    print(f'done in {time.time() - start_time} seconds.')
