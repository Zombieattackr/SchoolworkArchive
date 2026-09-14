import sys

def importarr(): #import the file to an array
    arr=[]
    with open('input.txt','r') as file:
        for line in file:
            arr.append(int(line))
    return arr

def MatOrder(p, i, j):
    mini=9999
    for k in range(i,j):
        count=(MatOrder(p,i,k) + MatOrder(p, k+1, j) + (p[i-1] * p[k] * p[j]) )
        if count < mini: mini=count
    return mini

arr=[50,20,1,10,100]#[10,20,30,40,50,40,10,50]
n=len(arr)
minimum = MatOrder(arr, 1, n-1)
print(minimum)