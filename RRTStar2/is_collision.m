function collision = is_collision(start_node, end_node, map_env, map)
   disp('is_collision.m')
   start_node.x = round(start_node.x);
   start_node.y = round(start_node.y);
   end_node.x = round(end_node.x);
   end_node.y = round(end_node.y);
   
   % 각 노드가 장애물 내부에 있는지 확인
   if map_env(start_node.y, start_node.x) ~= 0 && map_env(end_node.y, end_node.x) ~= 0
       collision_check = false;
   else
       collision_check = true;
   end

   for i = 1:length()
   total_check = collision_check + intersection_rect;
   disp('total')
   disp(total_check)
   if total_check ~= 0
       collision = true;
   else
       collision = false;
   end
end

