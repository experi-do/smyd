function choose_parent(node_new, neighbor_index, vertex)
    %disp('choose_parent.m')
    cost = [];

    for i = 1:length(neighbor_index)
        cost(end + 1) = get_new_cost(vertex(neighbor_index(i)), node_new);
    end
    [~, min_index] = min(cost);
    cost_min_index = neighbor_index(min_index);
    node_new.parent = vertex(cost_min_index);
end

