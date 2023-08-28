function rewire(node_new, neighbor_idx, vertex)
    disp('rewire.m')
    for i = 1:length(neighbor_idx)
        node_neighbor = vertex(i);

        if get_cost(node_neighbor) > get_new_cost(node_new, node_neighbor)
            node_neighbor.parent = node_new;
        end
    end
end

