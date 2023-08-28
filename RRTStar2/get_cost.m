function cost = get_cost(input_node_class)
    %disp('get_cost.m')
    node = input_node_class;
    cost = 0.0;
    while ~isempty(node.parent)
        cost = cost + hypot(node.x - node.parent.x, node.y - node.parent.y);
        node = node.parent;
    end
end

