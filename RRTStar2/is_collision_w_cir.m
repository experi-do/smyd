function collision = is_collision_w_cir(start_node, end_node, map_env, map)
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

   rect_cen = [];
   for i = 1:map.rect_cnt %map_env에 있는 모든 직사각형 장애물의 좌표 저장
       rect_cen = [rect_cen, [map.rect_xl(i), map.rect_yl(i)]];
   end
   
   dist_list_st = [];
   dist_list_en = [];
   for i = 1:map.rect_cnt
       %start_node와 장애물의 꼭짓점 4개 거리 확보
       dist_st = hypot(start_node.x - map.rect_xl(i), start_node.y - map.rect_yl(i));
       dist_list_st = [dist_list_st, dist_st];
       
       %end_node와 장애물의 꼭짓점 4개 거리 확보 후 최솟값 인덱스 반환
       dist_en = hypot(end_node.x - map.rect_xl(i), end_node.y - map.rect_yl(i));
       dist_list_en = [dist_list_en, dist_en];
   end
   %두 가지 dist의 최솟값과 인덱스 초기화
   [dist_st, rect_st_idx] = min(dist_list_st);
   [dist_en, rect_en_idx] = min(dist_list_en);

   if dist_st < dist_en
       check_pnt = dist_st;
       check_pnt_idx = rect_st_idx;
       check_dist_list = dist_list_st;
   else
       check_pnt = dist_en;
       check_pnt_idx = rect_en_idx;
       check_dist_list = dist_list_en;
   end

   if check_dist_list(check_pnt_idx) < hypot(start_node.x - end_node.x, start_node.y - end_node.y)
       intersection_check = [];
       %vertex_list = [(x,y); (x+w,y); (x+w,y+h); (x,y+h)]
       vertex_list = [map.rect_xl(i), map.rect_yl(i); map.rect_xl(i) + map.rect_wl(i), map.rect_yl(i); map.rect_xl(i) + map.rect_wl(i), map.rect_yl(i) + map.rect_hl(i); map.rect_xl(i), map.rect_yl(i) + map.rect_hl(i)];
       intersection_check = [intersection_check, is_intersect_rect(start_node, end_node, vertex_list(1, :), vertex_list(2, :))];
       intersection_check = [intersection_check, is_intersect_rect(start_node, end_node, vertex_list(2, :), vertex_list(3, :))];
       intersection_check = [intersection_check, is_intersect_rect(start_node, end_node, vertex_list(3, :), vertex_list(4, :))];
       intersection_check = [intersection_check, is_intersect_rect(start_node, end_node, vertex_list(4, :), vertex_list(1, :))];

       if sum(intersection_check) ~= 0
           intersection_rect = true;
       else
           intersection_rect = false;
       end
   else
       intersection_rect = false;
   end

   dist_list_cir = [];
   for i = 1:map.cir_cnt
       dist_cir = hypot(start_node.x - map.cir_xl(i), start_node.y - map.cir_yl(i));
       dist_list_cir = [dist_list_cir, dist_cir];
       [~, cir_idx] = min(dist_list_cir);
   end

   if dist_list_cir(cir_idx) < hypot(start_node.x - end_node.x, start_node.y - end_node.y)
       intersection_cir = is_intersect_cir(start_node, end_node, map.cir_xl(i), map.cir_yl(i), map.cir_rl(i));
   else
       intersection_cir = false;
   end

   total_check = collision_check + intersection_rect + intersection_cir;
   disp('total')
   disp(total_check)
   if total_check ~= 0
       collision = true;
   else
       collision = false;
   end
end

