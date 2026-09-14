import heapdict

def read():
    fname = "test.txt"
    fname2 = "rome 99.txt"
    with open(fname, 'r') as file:
        vertices=[]
        edges=[]
        l=[]
        for line in file:
            u,v,w=map(int,line.strip().split())
            print(u,v,w)
            edges.append((u,v))
            while len(l) < u:
                l.append([])
            while len(l[u]) < v:
                l[u].append(None)
            l[u][v]=w
    #max_node = max(max(node) for node in edges + [(0,)])
    #graph = [[] for _ in range(max_node + 1)]
    #for u,v,w in edges:
    #    graph[u].append((v,w))
    graph=()
    return graph

def makequeue(g):
    h=heapdict.heapdict()

    #??? Using dist values as keys?
    for i in range(len(g)):
        for j in range(len(g[i])):
            print('e')
#            h[]


#    return h


def dijkstra(g,s): #
    dist = [-1 for i in range(len(g.first))] #-1 represents infinite distance and nothing previous
    prev = dist
    dist[s] = 0

    H=makequeue(g)

    print(list(H.items()))
    while len(H)>0:
        u=H.popitem()
        for v in g[u]:
            if dist[v] > dist[u]: #+ l[]
                print('e')

graph=read()
print(graph)
dijkstra(graph,1)