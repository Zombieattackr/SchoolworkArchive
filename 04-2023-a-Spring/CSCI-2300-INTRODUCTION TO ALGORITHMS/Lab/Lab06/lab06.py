def read(graph, rgraph):
    fname = "test.txt"
    fname2 = "LAB6-TEST-SET.txt"
    file = open(fname, "r")

    local = {}
    for v in file:
        if int(v.split()[0]) not in local:
            local[int(v.split()[0])] = [int(v.split()[1])]
        else:
            local[int(v.split()[0])].append(int(v.split()[1]))

        if int(v.split()[1]) not in local:
            local[int(v.split()[1])] = []

    for k in sorted(local.keys()):
        if k not in graph:
            graph[int(k)] = local[k]

    for k in reversed(sorted(local.keys())):
        for l in local[k]:
            if l not in rgraph:
                rgraph[l] = [k]
            else:
                rgraph[l].append(k)

            if k not in rgraph:
                rgraph[k] = []

# finds a connected loop, calls until it finds a node that has all visited neighbors
def explore(vertex, visited, stack, graph):
    visited[vertex] = 1
    for neighbor in graph[vertex]:
        if not visited[neighbor]:
            explore(neighbor, visited, stack, graph)
    stack.append(vertex)

def secondExplore(vertex, visited, graph):
    visited[vertex] = 1
    print(vertex, end=" ")
    for neighbor in graph[vertex]:
        if not visited[neighbor]:
            secondExplore(neighbor, visited, graph)


def dfs(graph, rgraph):
    # O(V)
    stack, visited = [], [0 for i in range(max(graph.keys())+1)]
    for vertex in graph.keys():
        if not visited[vertex]:
            explore(vertex, visited, stack, rgraph)

    # prints each loop
    visited = [0 for i in range(max(graph.keys())+1)]
    while len(stack) != 0:
        top = stack.pop()
        if not visited[top]:
            secondExplore(top, visited, graph)
            print()


graph, rgraph = {}, {}
read(graph, rgraph)
print("graph: ",graph,"\n")
print("rgraph: ",rgraph,"\n")
dfs(graph, rgraph)