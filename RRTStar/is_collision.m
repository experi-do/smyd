function collision = is_collision(start_node, end_node)
   global mapInflated; 
   
   if mapInflated(start_node.y, start_node.x) || mapInflated(end_node.y, end_node.x) == 0
       collision = true;
   else
       collision = false;
   end

   N = 10; %쪼개는 수
   xs = linspace(start_node.x, end_node.x, N);
   ys = linspace(start_node.y, end_node.y, N);
   for i = 1:N
       x = round(xs(i));
       y = round(ys(i));
       if getOccupancy(mapInflated, [x, y])
           collision = true;
       else
           collision = false;
       end
   end
end

