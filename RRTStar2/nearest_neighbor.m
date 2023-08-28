function nearest_node = nearest_neighbor(node_list, node)
    %disp('nearest_neighbor.m')
    dist_list = [];
    for i = 1:length(node_list)
        dist_list(end + 1) = hypot(node_list(i).x - node.x, node_list(i).y - node.y);
    end
    nearest_node_value = min(dist_list);
    nearest_node_idx = find(nearest_node_value == dist_list);
    nearest_node = node_list(nearest_node_idx(1));
end

