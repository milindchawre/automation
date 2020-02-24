import sys
import json

OBSTACLE = 'X'
BIG_INT = 9999999

def readMaze():
    with open(sys.argv[1]) as f:
        data = json.load(f)
    f.close()
    return data["maze"]

def printMaze(maze):
    for i in range(len(maze)):
        for j in range(len(maze[i])):
            print(maze[i][j],end=" ")
        print("\n")

def findSource(maze):
    for i in range(len(maze)):
        for j in range(len(maze[i])):
            if maze[i][j] == 'S':
                return i,j
    # If source is not found, exit.
    sys.exit("Source 'S' not found in maze.")

def replace_obstacle(maze, val):
    for i in range(len(maze)):
        for j in range(len(maze[i])):
            if maze[i][j] == 1:
                maze[i][j] = val

def searchPath(maze, x, y):
    # 1. Check if not out of maze
    if x < 0 or y < 0 or y >= len(maze[0]) or x >= len(maze):
        return BIG_INT
    # 2. Check if Finish is reached
    if maze[x][y] == 'F':
        return 1
    # 3. Check if its obstacle
    if maze[x][y] == OBSTACLE:
        return BIG_INT
    maze[x][y] = 'X'
    dest = min(searchPath(maze, x - 1, y), searchPath(maze, x + 1, y), searchPath(maze, x, y - 1), searchPath(maze, x, y + 1))
    maze[x][y] = 0
    return dest + 1

def main():
    maze = readMaze()
    print("Input Maze : \n")
    printMaze(maze)
    replace_obstacle(maze, 'X')
    x,y = findSource(maze)
    #print("x =",x,"y =",y)
    maze[x][y] = 0
    l = searchPath(maze, x, y)
    maze[x][y] = 'S'
    #printMaze(maze)
    if l >= BIG_INT:
        print("There is no any path from S to F")
    else:
        print("Shortest Path Length = ",l-1)

if __name__ == "__main__":
    main()

