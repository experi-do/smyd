function node_idx = search_goal_parent(vertex, goal, step_len, map_env, map)
    disp('search_goal_parent.m')
    for i = 1:length(vertex)
        dist_list = hypot(vertex(i).x - goal.x, vertex(i).y - goal.y);
    end
    node_index = find(dist_list <= step_len);
    disp('node_index :')
    disp(node_index)

    if ~isempty(node_index)
        cost_list = [];
        for i = 1:length(node_index)
            if ~is_collision(vertex(node_index(i)), goal, map_env, map)
                cost_list = [cost_list; dist_list(node_index(i)) + get_cost(vertex(node_index(i)))];
            end
        end
        disp('cost_list:')
        disp(cost_list)
        [~, idx] = min(cost_list);
        node_idx = node_index(idx);
    else
        node_idx = length(vertex);
    end
end

