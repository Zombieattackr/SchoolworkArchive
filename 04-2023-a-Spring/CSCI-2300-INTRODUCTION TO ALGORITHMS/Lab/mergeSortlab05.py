import random

def quickSort(S):
    if len(S) < 2: return S
    #print(f'running {S}')
    mini = S[0]
    maxi = S[0]
    for i in S:
        if i < mini: mini = i
        if i > maxi: maxi = i
    if maxi == mini: return S
    v=random.randint(mini,maxi)
    SL=[]
    Sv=[]
    SR=[]
    for i in S:
        if i < v: SL.append(i)
        elif i > v: SR.append(i)
        else: Sv.append(i)
    return quickSort(SL) + quickSort(Sv) + quickSort(SR)


while 1:
    n = int(input(f'Enter n: '))
    S = []
    while n > 0:
        S.append(random.randint(0,n-1))
        n -= 1
    print(f'S = {S}')
    answer = quickSort(S)
    print(f'S = {answer}')
