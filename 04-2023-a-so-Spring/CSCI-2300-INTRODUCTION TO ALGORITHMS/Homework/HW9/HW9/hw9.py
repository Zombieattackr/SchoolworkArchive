import numpy as np

def simplex(c, A, b):
    m, n = A.shape
    tableau = np.zeros((m+1, n+m+1))
    tableau[:m, :n] = A
    tableau[:m, n:n+m] = np.eye(m)
    tableau[:m, -1] = b
    tableau[-1, :n] = -c
    while any(tableau[-1, :-1] < 0):
        pivot_col = np.argmin(tableau[-1, :-1])
        ratios = np.divide(tableau[:-1, -1], tableau[:-1, pivot_col])
        pivot_row = np.argmin(ratios)
        tableau[pivot_row, :] /= tableau[pivot_row, pivot_col]
        for i in range(m+1):
            if i != pivot_row:
                tableau[i, :] -= tableau[i, pivot_col]*tableau[pivot_row, :]
    return tableau[-1, -1], tableau[:-1, -1]

'''
# Example usage:
c = np.array([3, 2, 0, 0])
A = np.array([[1, 2, 1, 0], [4, 1, 0, 1]])
b = np.array([8, 12])
z, x = simplex(c, A, b)
print("Maximum value:", z)
print("Optimal solution:", x)
'''






#driver code
s=int(input('what would you like to test?'))
'''
if s==1:
    c=[1000,1200,12000] #revenue of each
    A=[[2,1,3], #weight
       [1,1,1], #volume
       [1,0,0], #ammount of each
       [0,1,0], #
       [0,0,1]] #
    b=[100,60,40,30,20] #actaul constrainst relating to those above
if s==2:
    c=[2,3,4]
    A=[[3,2,1],
       [2,5,3],
       [4,1,2]]
    b=[10,15,18]
if s==3:
    c=[1,0,-2]
    A=[[1,-1,0],
       [0,2,-1]]
    b=[1,1]
if s==4:
    c=[12,16]
    A=[[1,2],
       [1,1]]
    b=[40,30]
'''
c=np.array([1000,1200,12000]) #revenue of each
A=np.array([[2,1,3], #weight
   [1,1,1], #volume
   [1,0,0], #ammount of each
   [0,1,0], #
   [0,0,1]]) #
b=np.array([100,60,40,30,20]) #actaul constrainst relating to those above
if s==0:
    c=np.array([1000,1200,12000]) #revenue of each
    A=np.array([[2,1,3], #weight
       [1,1,1], #volume
       [1,0,0], #ammount of each
       [0,1,0], #
       [0,0,1]]) #
    b=np.array([100,60,40,30,20]) #actaul constrainst relating to those above
if s==1:
    c=np.array([1000,1200,12000]) #revenue of each
    A=np.array([[2,1,3], #weight
       [1,1,1], #volume
       [1,0,0], #ammount of each
       [0,1,0], #
       [0,0,1]]) #
    b=np.array([100,60,40,30,20]) #actaul constrainst relating to those above
if s==2:
    c=np.array([2,3,4])
    A=np.array([[3,2,1],
       [2,5,3],
       [4,1,2]])
    b=np.array([10,15,18])
if s==3:
    c=np.array([1,0,-2])
    A=np.array([[1,-1,0],
       [0,2,-1]])
    b=np.array([1,1])
if s==4:
    c=np.array([12,16])
    A=np.array([[1,2],
       [1,1]])
    b=np.array([40,30])


max_val,solution=simplex(c,A,b)
print('solution with max of ',max_val,' is: ', solution)
