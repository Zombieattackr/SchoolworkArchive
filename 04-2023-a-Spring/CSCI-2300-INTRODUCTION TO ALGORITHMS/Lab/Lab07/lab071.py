import heapdict

def read():
    fname = "test.txt"
    fname2 = "rome 99.txt"
    graph=[]
    maxv = 0
    with open(fname, 'r') as file:
        for line in file:
            x=line.strip().split()
            graph.append((int(x[0]),int(x[1]),int(x[2])))
            if int(x[0]) > maxv: maxv=int(x[0])
            if int(x[1]) > maxv: maxv=int(x[1])
    return graph,maxv

def dijkstra(g,m,s):
    V=[i+1 for i in range(m)]
    print(V)

    dist=[]
    prev=[]
    for u in range(len(V)):
        dist.append(float('inf'))
        prev.append(None)
    dist[s]=0

    heap=heapdict.heapdict()
    for x in g:
        V=max(V,x[2])

    for V in range(1,V+1):
        graph[V]=

    for V in dist:
        path=[]
        cur = V




graph,size=read()
print(graph)
dijkstra(graph,size,1)