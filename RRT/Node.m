classdef Node

    properties
        x
        y
        parent_x
        parent_y
    end

    methods
        function  obj = Node(node)
            obj.x = node(1);
            obj.y = node(2);
            obj.parent_x=[];
            obj.parent_y=[];
        end
    end
end