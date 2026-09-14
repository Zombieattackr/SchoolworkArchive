from heapdict import heapdict 
from collections import defaultdict

def dijkstra(G,s):
    # heap to hold each node and dist
    heapG = heapdict()
    dist = {}
    prev = {}
    V = 0

    # dict of nodes as keys and list of tuple as connected too and weight as value. dict[u] = [(v,w)]
    graph = defaultdict(list)
    for x in G:
        V = max(V,x[2])

    for V in range(1,V+1):
        graph[V] = []

    for x in G:
        graph[x[0]].append((x[1],x[2]))

    # sets each node to have an initial val of inf except for the s node
    for V in range(1,V+1):
        dist[V] = float('inf')
        heapG[V] = dist[V]
        prev[V] = 0

    dist[s] = 0
    heapG[s] = 0
    prev[s] = None

    while(heapG):
        #gets current node and current total dist
        u, luv = heapG.popitem()

        # If the new distance is smaller than the current distance to the neighbor,
        # update the distances and previous nodes, and add the neighbor to the priority queue
        for v, dist_u in graph[u]:
            if dist[v] > dist_u + luv:
                dist[v] = dist_u + luv
                prev[v] = u
                heapG[v] = dist_u + luv


    for V in dist:
        path = []
        cur = V

        while cur is not None:
            path.append(cur)
            if cur == 0:
                cur = None
            else:
                cur = prev[cur]
        path.reverse()

        if dist[V] != float('inf'):
            print(f"{V}: {dist[V]}, {path}\n")

file = "test.txt"
file2 = "rome99.txt"
file = open(file2, "r")

G = []
V= 0

# read the graph into a dict
for x in file:

    G.append((int((x.split()[0])),int(x.split()[1]),int(x.split()[2])))

dijkstra(G,1)