%% Define the simulation environment
map = robotics.BinaryOccupancyGrid(10,10,1);
inflate(map,0.3); % Inflate the obstacles by 0.3 meters
show(map); % Display the map

%% Define the robot
robotRadius = 0.2;
robot = robotics.RoboticsSystem('MaxAngularVelocity',2*pi,'MaxLinearVelocity',0.5);
robotRadius = robotRadius + robot.LocalMap.Size(1)*robot.LocalMap.Resolution;
setRobotSize(robot,robotRadius); % Set the robot size

%% Define the path planning algorithm
planner = robotics.PRM(map); % Create a probabilistic roadmap planner
planner.NumNodes = 200; % Set the number of nodes to 200
planner.ConnectionDistance = 1.5; % Set the maximum connection distance to 1.5 meters

%% Plan a path
startPose = [2 2 0]; % Set the start pose
goalPose = [8 8 0]; % Set the goal pose
path = plan(planner,startPose,goalPose); % Plan a path from startPose to goalPose

%% Plot the path
plot(planner); % Plot the PRM
hold on;
show(map);
plot(path); % Plot the planned path
hold off;