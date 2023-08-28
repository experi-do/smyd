classdef Map
    %MAP 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    
    properties
        map_env
        
        rect_x
        rect_y
        rect_w
        rect_h

        rect_xl
        rect_yl
        rect_wl
        rect_hl

        rand_num
        rect_cnt
    end
    
    methods
        function obj = Map(map_w, map_h, obs_num)
            obj.map_env = ones(map_w, map_h);

            obj.rand_num = randi([5, obs_num]);
            obj.rect_cnt = obj.rand_num;
            %obj.rect_cnt = 10;

            for i = 1:obj.rect_cnt
                obj.rect_x = randi([1, map_w]);
                obj.rect_xl = [obj.rect_xl, obj.rect_x];
                obj.rect_y = randi([1, map_h]);
                obj.rect_yl = [obj.rect_yl, obj.rect_y];
                obj.rect_w = randi([1, 10]);
                if (obj.rect_x + obj.rect_w > map_w)
                    obj.rect_w = map_w - obj.rect_x;
                end
                obj.rect_wl = [obj.rect_wl, obj.rect_w];
                obj.rect_h = randi([1, 10]);
                if (obj.rect_y + obj.rect_h > map_h)
                    obj.rect_h = map_h - obj.rect_y;
                end
                obj.rect_hl = [obj.rect_hl, obj.rect_h];
                
            end
        end
        
        function map_env = boundary(obj, map_list, map_w, map_h)
            obj.map_env = map_list;
            obj.map_env(1,:) = 0;
            obj.map_env(:,1) = 0;
            obj.map_env(map_w,:) = 0;
            obj.map_env(:,map_h) = 0;
            map_env = obj.map_env;
        end

        function map_env =rectangle(obj, map_list)
            obj.map_env = map_list;
            for i = 1:obj.rect_cnt
                rect_xc = obj.rect_xl(i);
                rect_yc = obj.rect_yl(i);
                rect_wc = obj.rect_wl(i);
                rect_hc = obj.rect_hl(i);
                obj.map_env(rect_yc:rect_yc+rect_hc-1, rect_xc:rect_xc+rect_wc-1) = 0;
            end
            map_env = obj.map_env;
        end
    end
end

