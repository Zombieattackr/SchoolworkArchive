import heapq

def importgraph(f): #import the file to a list of lists, 
    V=[]
    E=[]
    U=[]
    with open(f,'r') as file: 
        flag=False
        for line in file:
            if((not flag) and line=='\n'): 
                flag=True
            else:
                if flag:
                    u,v,w=map(str,line.strip().split())
                    E.append((u,v,int(w)))
                    if u not in V: V.append(u)
                    if v not in V: V.append(v)
                else:
                    leaf=map(str,line.strip().split())
                    U.append(leaf)
    return V,E,U

def find(u, parent):
    if parent[u] == u:
        return u
    parent[u] = find(parent[u], parent)
    return parent[u]


def union(u, v, parent, rank):
    u_root = find(u, parent)
    v_root = find(v, parent)
    if u_root == v_root:
        return False

    if rank[u_root] > rank[v_root]:
        parent[v_root] = u_root
    elif rank[u_root] < rank[v_root]:
        parent[u_root] = v_root
    else:
        parent[v_root] = u_root
        rank[u_root] += 1

    return True


def modified_kruskal(V, E, U):
    heapq.heapify(E)  # Turn E into a min heap
    parent = {v: v for v in V}
    rank = {v: 0 for v in V}
    spanning_tree = []
    degree = {v: 0 for v in V}

    while E and len(spanning_tree) < len(V) - 1:
        u, v, w = heapq.heappop(E)
        # If u and v are already a part of the same tree, we can continue
        if union(u, v, parent, rank):
            # Add edge to the spanning tree and update degrees
            spanning_tree.append((u, v, w))
            degree[u] += 1
            degree[v] += 1

            # Check if any node in U has a degree greater than 1
            violation = False
            for node in U:
                if degree[node] > 1:
                    violation = True
                    # Remove edge from the spanning tree, rollback the changes in degree, and reset parent pointer
                    spanning_tree.remove((u, v, w))
                    degree[u] -= 1
                    degree[v] -= 1
                    parent[v] = v
                    break

            if not violation and len(spanning_tree) == len(V) - 1:
                break

    # If the spanning tree is not fully connected, the problem has no solution
    if len(spanning_tree) != len(V) - 1:
        return None, None

    return spanning_tree, sum(w for _, _, w in spanning_tree)

#8 nodes 7 edges

if __name__ == "__main__":

    V = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'}

    E = [('A', 'B', 10), ('A', 'C', 12),
         ('B', 'C', 9), ('B', 'D', 8),
         ('C', 'E', 3), ('C', 'F', 1),
         ('D', 'E', 7), ('D', 'G', 8), ('D', 'H', 5),
         ('E', 'F', 3),
         ('F', 'H', 6),
         ('G', 'H', 9), ('G', 'I', 2),
         ('H', 'I', 11)
         ]

    U = {'A', 'D'} #'F'
    print(V)
    print(E)
    print(U)

    #V,E,U=importgraph('testin.txt')
    #print(V)
    #print(E)
    #print(U)

    spanning_tree, total_weight = modified_kruskal(V, E, U)
    if spanning_tree is None:
        print("No solution exists.")
    else:
        print("Tree:", spanning_tree)
        print("Weight:", total_weight)

