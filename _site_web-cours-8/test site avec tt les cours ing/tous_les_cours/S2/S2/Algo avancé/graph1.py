graph=[[0,2,1,0],[1,0,3,1],[1,1,0,0],[0,2,0,1]]


def nbArete(graph):
    nb=0
    for i in range(len(graph)):
        for j in range(len(graph[i])):
            if (i!=j):
                nb=nb+graph[i][j]
            else:
                nb=nb+graph[i][j]*2
    return nb/2       
            
def showGraph(graph):
    nbNodes=len(graph)
    nbArretes=nbArete(graph)
    print("Nombre de sommets :",nbNodes)
    print("Nombre de arretes :",nbArretes)
    # A terminer
    
def isSimple(graph):
    #graphe simple ==> pas de boucle et pas de d'arrêtes
    #parallèles:
    for i in range(len(graph)):
        for j in range(len(graph[i])):
            #arêtes parallèles?
            if (graph[i][j] > 1):
                return False
            #boucles ?
            if  (i==j and graph[i][i]!=0):
                return False
    return True

#Rendre un graphe simple
def makeSimple(graph):
    for i in range(len(graph)):
        for j in range(len(graph[i])):
            #arêtes parallèles?
            if  (i==j):
                graph[i][j]=0
            else:
               if (graph[i][j] >0):
                   graph[i][j]=1

def chainElementary(graph, listNodes):
    extrem1 = listNodes[0]
    print(extrem1)
    n = len(listNodes)
    extrem2 = listNodes[n-1]
    for i in range(len(listNodes)-1,0,-1):
        print(listNodes[i])
        if extrem1 == listNodes[i]:
            listNodes = listNodes[-(len(listNodes)-i):]
            print(listNodes)
            return listNodes
    return listNodes

def isConnex(graph): #David
    done = [0]
    todo = [0]
    connected = set({})
    for i in todo:
        for j in range(len(graph[i])):
            if graph[i][j] > 0:
                connected.add(graph[i][j])
            if j not in done:
                todo.append(j)
        if len(connected) == len(graph):
            return True
        done.append(i)
    return False


def isConnexCorrection(graph): #complexité o(n^2)
    n = len(graph)
    groups = np.zeros(n, dtype = int)
    groups[0] = 1
    stack = [0]
    while stack :
        curr_el = stack[0]
        current_group = groups[curr_el]
        for i in range(n):
            if graph[curr_el][i] == 1 and groups[i] == 0:
                stack.append(i)
                groups[i] = 1
        stack.pop(0)
    if set(groups) == (1):
        return True
    return False

def is_connex(graph): #chat
    # Fonction récursive pour parcourir le graphe
    def dfs(node, visited):
        visited.add(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                dfs(neighbor, visited)

    # Vérifier la connexité en effectuant une recherche en profondeur (DFS)
    start_node = next(iter(graph))
    visited = set()
    dfs(start_node, visited)

    # Si tous les nœuds sont visités, le graphe est connexe
    if len(visited) == len(graph):
        print("Le graphe est connexe.")
        return True
    else : 
        print("Le graphe n'est pas connexe.")
        return False



def is_bipartite(graph):
    # Fonction pour vérifier si le graphe est biparti à partir d'un nœud de départ
    def dfs(node, color):
        colors[node] = color
        for neighbor in graph[node]:
            if neighbor not in colors:
                if not dfs(neighbor, 1 - color):
                    return False
            elif colors[neighbor] == color:
                print("Le graphe n'est pas biparti.")
                return False
        print("Le graphe est biparti.")
        return True

    # Initialisation des couleurs et vérification à partir de chaque nœud
    colors = {}
    for node in graph:
        if node not in colors:
            if not dfs(node, 0):
                print("Le graphe n'est pas biparti.")
                return False
    print("Le graphe est biparti.")
    return True
    

def compConnex(graph):
    # Fonction récursive pour trouver les composantes connexes à partir d'un nœud de départ
    def dfs(node, visited, component):
        visited.add(node)
        component.append(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                dfs(neighbor, visited, component)

    # Initialisation des variables
    visited = set()
    components = []

    # Parcours de chaque nœud du graphe
    for node in graph:
        if node not in visited:
            component = []
            dfs(node, visited, component)
            components.append(component)

    print("Les composantes connexes du graphe sont:", components)
    return components





makeSimple(graph)
print(graph)
print(isConnex(graph))