function dist_table_index = find_near_neighbor(node_new, vertex, search_radius, step_len, map_env, map)
    %disp('find_near_neighbor.m')
    n = length(vertex) + 1;
    r = min(search_radius * sqrt(log(n)/n), step_len);
    dist_table = [];

    for i = 1:length(vertex)
        dist_table = [dist_table, hypot(vertex(i).x - node_new.x,  vertex(i).y - node_new.y)];
    end
    dist_table_index = [];
    for i = 1:length(dist_table)
         if (~is_collision(node_new, vertex(i), map_env, map)) 
         %if (dist_table(i) <= r) && (~is_collision(node_new, vertex(i), map_env, map))
            dist_table_index = [dist_table_index; i];
        else
            dist_table_index = [dist_table_index; NaN];
        end
    end
end

