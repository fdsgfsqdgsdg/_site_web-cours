# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
# Kruskal's algorithm in Python




def add_edge(graph,u, v, w):
    graph.append([u, v, w])

    # Search function

def find(parent, i):
    if parent[i] == i:
        return i
    return find(parent, parent[i])

def union(parent, rank, x, y):
    xroot = find(parent, x)
    yroot = find(parent, y)

    if rank[xroot] < rank[yroot]:
        parent[xroot] = yroot
    elif rank[xroot] > rank[yroot]:
        parent[yroot] = xroot
    else:
        parent[yroot] = xroot
        rank[xroot] += 1

def kruskal(graph, V):
    result = []
    i, e = 0, 0
    graph = sorted(graph, key=lambda item: item[2])
    parent = [i for i in range(V)]
    rank = [0] * V

    while e < V - 1:
        u, v, w = graph[i]
        i += 1
        x = find(parent, u)
        y = find(parent, v)
        if x != y:
            e += 1
            result.append([u, v, w])
            union(parent, rank, x, y)

    return result

# Exemple d'utilisation
graph = [[0, 1, 10], [0, 2, 6], [0, 3, 5], [1, 3, 15], [2, 3, 4]]
V = 4
mst = kruskal(graph, V)
for u, v, weight in mst:
    print(f"{u} -- {v} == {weight}")
