function node_rand = generate_random_node(goal_sample_rate, x_range, y_range, delta, goal)
     %disp('generate_random_node.m')
     rand_num = rand();
     if rand_num> goal_sample_rate
        rand_x = randi([x_range(1) + delta, x_range(2) - delta]);
        rand_y = randi([y_range(1) + delta, y_range(2) - delta]);

        node_rand = Node([rand_x, rand_y]);
     else
        node_rand = goal;
     end
end

