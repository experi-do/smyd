classdef Node
    % Information about Node
    %   x, y, parent_Node

    properties
        x
        y
        parent
    end

    methods (Static)
        function  obj = Node(node)
            obj.x = node(1);
            obj.y = node(2);
            class(obj.x);
            obj.parent = ;
        end
    end
end