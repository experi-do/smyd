classdef Node

    properties
        x
        y
        parent
    end

    methods
        function  obj = Node(node)
            obj.x = node(1);
            obj.y = node(2);
            obj.parent;
        end
    end
end