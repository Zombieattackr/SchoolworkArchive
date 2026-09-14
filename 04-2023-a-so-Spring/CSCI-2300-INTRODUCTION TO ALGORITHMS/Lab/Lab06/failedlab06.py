def importgraph(f): #import the file to a list of lists, 
    with open(f,'r') as file: #LAB6-TEST-SET.txt #test.txt
        edges=[]
        for line in file:
            u,v=map(int,line.strip().split())
            edges.append((u,v))
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

def reverse(g): #easier method for testing output
    gr=[[] for i in range(len(g))]
    for i in range(len(g)):
        for j in range(len(g[i])):
            gr[g[i][j]].append(i)
    return gr

def dfs(g):
    v=[] #visited
    po=[-1 for i in range(len(g))] #post numbers
    pr=[-1 for i in range(len(g))] #pre numbers
    clk=0
    for j in range(len(g)):
        print(j)
        if j not in v: pr,po,clk,v=dfss(g,j,v,pr,po,clk)
    return  pr,po

def dfss(g,i,v,pr,po,clk):
    print(f'{i}, clk={clk}, pr={pr}, po={po}')
    pr[i]=clk
    clk+=1
    v.append(i) #visited
    print(f'{i}, clk={clk}, pr={pr}, po={po}')
    for j in range(len(g[i])): #visit next nodes (if not visited)
        if g[i][j] not in v: pr,po,clk,v=dfss(g,g[i][j],v,pr,po,clk)
    po[i]=clk
    clk+=1
    return pr,po,clk,v

#import the file to a list of lists, 
b=0#int(input('enter 0 for test or 1 for full: '))
if b: f='LAB6-TEST-SET.txt'
else: f='test.txt'
graph=importgraph(f)

#create GR
print('check0, print input graph')
gprint(graph)
print('check1, reverse')
rgraph = reverse(graph)
print('check2, print reverse')
gprint(rgraph)

#compute DFS interval on GR for each node
print('check3, dfs')
pr,po=dfs(rgraph)
print('check4, print pre and post')
print(f'pr={pr}')
print(f'po={po}')

#iteratively select the next unvisited node u with highest post
#for each such u, use dfs on g to visit all nodes reachable from u and output this set as a connected component
