function path = planning(map, map_env, goal, step_len, goal_sample_rate, search_radius, iter_max, vertex)
    disp('planning.m')
    for k = 1 : iter_max
        disp('vertex : ')
        for i = 1:length(vertex)
            disp([vertex(i).x, vertex(i).y])
        end
        
        node_rand = generate_random_node(goal_sample_rate, [0,60], [0,60], 1, goal);
        disp('node_rand')
        disp([node_rand.x, node_rand.y])

        node_near = nearest_neighbor(vertex, node_rand);
        disp('node_near')
        disp([node_near.x, node_near.y])

        node_new = new_state(node_near, node_rand, step_len);
        disp('node_new')
        disp([node_new.x, node_new.y])

        if k%500 == 0
            disp('k :')
            disp(k)
        end

        neighbor_index = [];
        
        if ~isempty(node_new) && ~is_collision(node_near, node_new, map_env, map)
            if ~isnan(find_near_neighbor(node_new, vertex, search_radius, step_len, map_env, map))
                neighbor_index = [neighbor_index; find_near_neighbor(node_new, vertex, search_radius, step_len, map_env, map)]; 
                vertex = [vertex; node_new];

                if ~isempty(neighbor_index)
                    choose_parent(node_new, neighbor_index, vertex);
                    rewire(node_new, neighbor_index, vertex);
                end
            end
        end
        if hypot(vertex(end).x - goal.x, vertex(end).y - goal.y) < step_len
            %index = search_goal_parent(vertex, goal, step_len, map_env, map);
            path = extract_path(vertex(end), goal);
            if path
            path = flip(path);
            plot(path(:,1), path(:,2), 'r-o')
            break
            end
        end
        if k == iter_max
            try
                path = planning(map, map_env, goal, step_len, goal_sample_rate, search_radius, iter_max, vertex);
            catch
                disp('Can not find the path')
            end
        end
    end
end

