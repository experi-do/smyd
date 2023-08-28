function map_env = mapFunc(map_w, map_h, obs_num)
   map_list = ones(map_w,map_h);

   % boundary
   map_list(1,:) = 0;
   map_list(:, 1) = 0;
   map_list(map_w, :) = 0;
   map_list(:, map_h) = 0;

   % divide rect and cir
   rand_num = randi([1, obs_num]);
   rect_cnt = rand_num;
   disp('rect_cnt')
   disp(rect_cnt)
   cir_cnt = obs_num - rand_num;
   disp('cir_cnt')
   disp(cir_cnt)

   for i = 1:rect_cnt
       rand_x = randi([1, map_w]);
       rand_y = randi([1, map_h]);
       rand_w = randi([1, 10]);
       rand_h = randi([1, 10]);
       if (rand_x + rand_w > map_w)
           rand_w = map_w - rand_x;
       end
       if (rand_y + rand_h > map_h)
           rand_h = map_h - rand_y;
       end

       map_list(rand_x:rand_x+rand_w-1, rand_y:rand_y+rand_h-1) = 0;
   end

   for i =1:cir_cnt
       rand_x_cir = randi([1, map_w]);
       rand_y_cir = randi([1, map_h]);
       rand_r = randi([1, 3]);

       rad_list = [rand_x_cir - rand_r, 60 - rand_x_cir - rand_r, rand_y_cir - rand_r, 60 - rand_y_cir - rand_r];
       min_rad = 1;
       for i =1:length(rad_list)
           if rad_list(i) < 1
               if rad_list(i) < min_rad
                   min_rad = rad_list(i);
               end
           end
       end
       rand_r = rand_r + min_rad;

       for x = rand_x_cir - rand_r:rand_x_cir + rand_r
           for y = rand_y_cir - rand_r:rand_y_cir + rand_r
               if (hypot(rand_x_cir - x, rand_y_cir - y) < rand_r)
                   map_list(x, y) = 0;
               end
           end
       end
   end    

   map_env = map_list;

   disp(map_env)
end

