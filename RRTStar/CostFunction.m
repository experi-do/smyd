function cost = CostFunc(input_node)
    disp('*')
    node = input_node;
    class(node)
    cost = 0.0;
    while ~isempty(node.parent)
        cost = cost + hypot(node.x - node.parent.x, node.y - node.parent.y);
        node = node.parent;
    end
end
