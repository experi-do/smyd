function [x, y, directCon, nodeCon] = check_collision(x1, y1, x2, y2)
    [~, theta] = get_distance_and_angle(x2, y2, x1, y1);
    x = x2 + stepSize
end

