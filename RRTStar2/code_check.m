map = Map(20, 20, 5);
map_env = map.map_env;
start = Node([10, 10]);
goal = Node([10,10]);
vertex = [];
vertex = [vertex, start];

path = planning(map, map_env, goal, 4, 0.3, 5, 1000, start);
disp(path)