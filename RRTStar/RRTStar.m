classdef RRTStar
    %RRTSTAR 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    
    properties
        s_start
        s_goal
        step_len
        goal_sample_rate
        search_radius
        iter_max
        vertex
        path

        x_range
        y_range
    end
    
    methods
        function obj = RRTStar(x_start, x_goal, step_len, goal_sample_rate, search_raidus, iter_max)
            %검색 반경은 최대 스텝 크기를 초과할 수 없음. 
            %초과하면, 알고리즘이 이전 단계에서 발견한 노드를 다시
            %방문하거나 검색 반경을 넘어서는 너무 멀리 떨어진 지역을 불필요하게 조사함.

            obj.s_start = Node(x_start);
            obj.s_goal = Node(x_goal);
            obj.step_len = step_len;
            obj.goal_sample_rate = goal_sample_rate;
            obj.search_radius = search_raidus;
            obj.iter_max = iter_max;
            obj.vertex = [obj.s_start];
            obj.path = [];
            
            obj.x_range = [0, 50];
            obj.y_range = [0, 30];
        end
                
        function cost = CostFunc(~,input_node)
            node = input_node;
            cost = 0.0;
            while ~isempty(node.parent)
                cost = cost + hypot(node.x - node.parent.x, node.y - node.parent.y);
                node = node.parent;
            end
        end

        function [d, a] = get_distance_and_angle(node_start, node_end)
            dx = node_end.x - node_start.x;
            dy = node_end.y - node_start.y;
            d = hypot(dx, dy);
            a = atan2(dy, dx);
        end

        function new_cost = get_new_cost(obj, node_start, node_end)
            [dist, ~] = obj.get_distance_and_angle(node_start, node_end);
            new_cost = obj.CostFunc(node_start) + dist;
        end

        function node_rand = generate_random_node(obj, goal_sample_rate)
            delta = 0.5; %조정 가능 

            if rand()> goal_sample_rate
                rand_x = rand() * (obj.x_range(2) - obj.x_range(1) - delta * 2) + obj.x_range(1) + delta;
                rand_y = rand() * (obj.y_range(2) - obj.y_range(1) - delta * 2) + obj.y_range(1) + delta;

                node_rand = Node([rand_x, rand_y]);
            else
                node_rand = obj.s_goal;
            end
        end

        function node_new = new_state(obj, node_start, node_end)
            [dist, theta] = obj.get_distance_and_angle(node_start, node_end);

            dist = min(obj.step_len, dist);
            node_new = Node([node_start.x + dist*cos(theta), node_start.y + dist*sin(theta)]);

            node_new.parent = node_start;
        end

        function choose_parent(obj, node_new, neighbor_index)
            cost = [];
            for i = 1:length(neighbor_index)
                cost(end + 1) = obj.get_new_cost(obj.vertex(neighbor_index(i)), node_new);
            end
            [~, min_idx] = min(cost);
            cost_min_index = neighbor_index(min_idx);
            node_new.parent_node = obj.vertex(cost_min_index);
        end

        function rewire(obj, node_new, neighbor_idx)
            for i = 1:lenth(neighbor_idx)
                node_neighbor = obj.vertex(i);

                if obj.CostFunc(node_neighbor) > obj.get_new_cost(node_new, node_neighbor)
                    node_neighbor.parent = node_new;
                end
            end
        end

        function node_idx = search_goal_parent(obj)
            for i = 1:length(obj.vertex)
                dist_list = hypot(vertex(i).x - obj.s_goal.x, vertex(i).y - obj.s_goal.y);
            end
            node_index = find(dist_list <= obj.step_len);

            if ~isempty(node_index)
                cost_list = [];
                for i = 1:length(node_index)
                    node_i = node_index(i);
                    if ~is_collision(obj.vertex(node_i), obj.s_goal)
                        cost_list(end + 1) = dist_list(node_i) + obj.CostFunc(obj.vertex(node_i));
                    end
                end
                [~, idx] = min(cost_list);
                node_idx = node_index(idx);
            end
            node_idx = length(obj.vertex);
        end
        
        function nearest_node = nearest_neighbor(node_list, n)
            dist_list = [];
            for i = 1:length(node_list)
                dist_list(end + 1) = hypot(node_list(i).x - n.x, node_list(i).y - n.y);
            end
            nearest_node = min(dist_list);
        end

        function dist_table_index = find_near_neighbor(obj, node_new)
            n = length(obj.vertex) + 1;
            r = min(obj.search_radius * math.sqrt(math.log(n)/n), obj.step_len);
            %노드 수가 증가함에 따라 검색 반경이 감소하도록 함->잘 탐색된 그래프 영역 탐색x
            %하지만 최대 스텝 크기보다 작아야만 불필요한 노드 탐색을 방지할 수 있음.
            dist_table = zeros(1, size(obj.vertex));
            for i = 1:length(obj.vertex)
                dist_table(i) = hypot(obj.vertex(i).x - node_new.x, obj.vertex(i).y - node_new.y);
            end
            dist_table_index = [];
            for i = 1:length(dist_table)
                if dist_table(i) <= r && ~is_collision(node_new, obj.vertex(i))
                    dist_table_index(end + 1) = i;
                end
            end
        end

        function path = extract_path(obj, node_end)
            path = [[obj.s_goal.x, obj.s_goal.y]];
            node = node_end;
            while node.parent ~= None
                path(end + 1, :) = [node.x, node.y];
                node = node.parent;
            end
            path(end + 1, :) = [node.x, node.y];
        end

        function planning(obj)
            disp(obj.iter_max)
            for i = 1: obj.iter_max
                node_rand = obj.generate_random_node(obj.goal_sample_rate);
                node_near = obj.nearest_neighbor(obj.vertex, node_rand);
                node_new = new_state(node_near, node_rand);

                if k%500 ==0
                    disp(k)
                end

                neighbor_index = [];
                if ~isempty(node_new) && ~is_collision(node_near, node_new)
                    neighbor_index(end + 1) = obj.find_near_neighbor(node_New);
                    obj.vertex(end + 1, :) = node_new;

                    if ~isempty(neighbor_index)
                        obj.choose_parent(node_new, neighbor_index);
                        obj.rewire(node_New, neighbor_index);
                    end
                end
            end

            index = obj.search_goal_parent();
            obj.path = obj.extract_path(obj.vertex(index));

            plot(obj.path(1,:), obj.path(2,:));
        end
    end

end
