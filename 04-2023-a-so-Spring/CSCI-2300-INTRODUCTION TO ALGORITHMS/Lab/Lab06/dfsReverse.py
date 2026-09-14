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

def gout(g,n): #to output file for easy comparison
    if n:
        file=open('easyout.txt','w')
    else:
        file=open('dfsout.txt','w')
    i=1
    while i<len(g):
        file.writelines([str(i), '-->', str(g[i]), '\n'])
        i+=1
    file.close()

def easyreverse(g): #easier method for testing output
    gr=[[] for i in range(len(g))]
    for i in range(len(g)):
        for j in range(len(g[i])):
            gr[g[i][j]].append(i)
    return gr

def reverse(g):
    v=[] #visited
    p=[] #post numbers
    p=dfspost(g,1,v,p) #get post numbers
    rg=[[] for i in range(len(g))] #create empty reverse graph
    rg=dfsreverse(g,rg,p) #reverse the graph with post order and assing to rg
    return rg

def dfspost(g,i,v,p):
    v.append(i) #visited
    for j in range(len(g[i])): #visit next nodes (if not visited)
        if g[i][j] not in v: dfspost(g,g[i][j],v,p)
    p.append(i) #add to post when done
    return p

def dfsreverse(g,rg,p):
    for i in p: #for each node
        for j in g[i]: #for everthing it points to
            rg[j].append(i) #reverse points the other way
    return rg


#import the file to a list of lists, 
b=int(input('enter 0 for test or 1 for full'))
if b: f='LAB6-TEST-SET.txt'
else: f='test.txt'
graph=importgraph(f)

print('check0, print input graph')
gprint(graph)

print('check1, easy reverse')
regraph = easyreverse(graph)

print('check2, print easy reverse')
gprint(regraph)
gout(regraph,0)

print('check3, reverse')
rgraph = reverse(graph)

for i in range(len(rgraph)):#sort reverse for easier comparison
    rgraph[i].sort()

print('check4, print reverse')
gprint(rgraph)
gout(rgraph,1)
