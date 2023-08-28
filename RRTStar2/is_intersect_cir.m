function is_intersect = is_intersect_cir(start_node, end_node, center_x, center_y, rad)
    if hypot(start_node.x - center_x, start_node.y - center_y) < rad || hypot(end_node.x - center_x, end_node.y - center_y) < rad
        is_intersect = true;
    else
        is_intersect = false;
    end
end

