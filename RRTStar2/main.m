start = Node([10, 10]);
goal = Node([50, 50]);
step_len = 8; %5
goal_sample_rate = 0.3;
search_radius = 10;%10
iter_max = 10000;

vertex = [];
vertex = [vertex, start];

map = Map(60, 60, 15);
map_env = map.map_env;
map_env = map.boundary(map_env, 60, 60);
map_env = map.rectangle(map_env);
%map_env = map.circle(map_env);

%map = mapFunc(60, 60, 20);
imshow(map_env);
hold on;

path = planning(map, map_env, goal, step_len, goal_sample_rate, search_radius, iter_max, vertex);

disp('path :')
disp(path)
plot(path(:,1), path(:,2), 'r-o')

disp(map.rect_cnt)
%disp(map.cir_cnt)


