function path = extract_path(node_end, goal)
    %disp('extract_path.m')
    path = [goal.x, goal.y];
    node = node_end;
    while ~isempty(node.parent)
        path = [path; [node.x, node.y]];
        node = node.parent;
    end
    path = [path; [node.x, node.y]];
end

