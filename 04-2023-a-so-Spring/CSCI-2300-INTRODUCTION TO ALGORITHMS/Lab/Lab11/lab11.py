S=[{1,3,5,7,10,11},
{1,2,4,5,11},
{4,8,9},
{1,3,5,8,9,10},
{2,6,10}
]
n=11

curLen=0
select=[]
covered=set()
while len(covered) < n:
    bestIdx=None
    bestNum=0
    for i in range(len(S)):
        count = len(S[i]-covered)
        if count > bestNum:
            bestIdx=i
            bestNum=count
    select.append(bestIdx)
    covered |= S[bestIdx]

print(covered)
print(select)