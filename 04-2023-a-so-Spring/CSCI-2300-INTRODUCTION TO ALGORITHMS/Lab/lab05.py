import random

def quickSort(S,low,high):
    if low < high:
        r=random.randint(low,high) #this really doesn't need to be done randomly
        S[low],S[r]=S[r],S[low] #literally just uses the low value, but swaps with a random for some reason.
                                    #I guess it'll make it more consistent? but a tad bit slower
        v=low
        i=low+1
        for j in range(low+1,high+1): #for everything in the current area
            if S[j] <= S[v]: #if current index is less than pivor
                S[i],S[j]=S[j],S[i] #swap it with pivot
                i+=1
        S[v],S[i-1]=S[i-1],S[v] #lmao idk, just accounting for things
        v=i-1
        quickSort(S,low,v-1) #continue sorting left side
        quickSort(S,v+1,high) #continue sorting right side
    return S #unnecessary, just return


while 1:
    n = int(input(f'Enter n: '))
    S = []
    i=n
    while i > 0:
        S.append(random.randint(0,n-1))
        i -= 1
    print(f'S = {S}')
    ans = quickSort(S,0,n-1) #not necessary, just call quickSort(S,0,n-1)
    print(f'S = {ans}') #not necessary, justs print(f'{S}) again
