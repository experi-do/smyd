function is_collision = collision(x1, y1, x2, y2)
    color = [];
    x = linspace(x1, x2, (x2-x1)/100);
    y = linspace(y1, y2, (y2-y1)/100);

    for i =1:length(x)
        color = [color, [int(y(i)), int(x(i))]];
    end
    if ismember(0, color)
        is_collision = true;
    else
        is_collision = false;
    end
end

