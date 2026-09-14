def importgraph(f): #import the file to a list of lists, 
    with open(f,'r') as file: #LAB6-TEST-SET.txt #test.txt
        edges=[]
        for line in file:
            u,v=map(int,line.strip().split())
            edges.append((u,v))
            edges.append((v,u))
    max_node = max(max(node) for node in edges + [(0,)])
    graph = [[] for _ in range(max_node + 1)]
    for u,v in edges:
        graph[u].append(v)
    return graph

def gprint(g): #print for readability
    i=1
    while i<len(g):
        print(f'{i} --> {g[i]}')
        i+=1


def dfs(g):
    v=[]     #visited
    c=[None for i in range(len(g))]     #"color", starts None, painted 1 or 0
    for i in range(len(g)):     #visit everything not yet visited
        if i not in v: 
            v,c,b = dfss(g,v,c,i)
            if not b:     #boolean return value
                return False
    return True


def dfss(g,v,c,i):
    v.append(i)
    flag0=False
    flag1=False
    for j in g[i]:     #visit all connected nodes
        if j in v:     #only those that have been visited (and therefore colored)
            if c[j]==0: flag0=True     #track if any neighbors are colored 0 or 1
            elif c[j]==1: flag1=True
    if flag0 and flag1: return v,c,False     #is touching nodes of both colors
    elif flag0: c[i]=1     #if touching a 0, color this 1
    else: c[i]=0     #if touching a 1 or nothing, color this 0
    for j in g[i]:     #visit all connected nodes again
        if j not in v:     #this time the other ones that haven't been visited
            v,c,b = dfss(g,v,c,j)     #continue dfss on them
            if not b: return v,c,False     #if any of them return false, return false all the way back
    return v,c,True     #if none are false, all branches are bipartite, return true


#import the file to a list of lists, 
f='test.txt'
graph=importgraph(f)

#create GR
print('check0, print input graph')
gprint(graph)
print('check1, is it bipeartite?')
if dfs(graph):
    print('Yes it is')
else: 
    print('No it\'s not')

#iteratively select the next unvisited node u with highest post
#for each such u, use dfs on g to visit all nodes reachable from u and output this set as a connected component
