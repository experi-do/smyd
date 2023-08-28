function [dist, angle] = get_distance_and_angle(node_start, node_end)
    %disp('get_distance_and_angle.m')
    dx = node_end.x - node_start.x;
    dy = node_end.y - node_start.y;
    dist = hypot(dx, dy);
    angle = atan2(dy, dx);
end

