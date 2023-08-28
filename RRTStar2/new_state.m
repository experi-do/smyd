function node_new = new_state(node_start, node_end, step_len)
    %disp('new_state.m')
    [dist, theta] = get_distance_and_angle(node_start, node_end);
    dist = min(step_len, dist);
    node_new = Node([node_start.x + dist*cos(theta), node_start.y + dist*sin(theta)]);
    node_new.parent = node_start;
end

