function new_cost = get_new_cost(node_start, node_end)
    %disp('get_new_cost.m')
    [dist, ~] = get_distance_and_angle(node_start, node_end);
    new_cost = get_cost(node_start) + dist;
end

