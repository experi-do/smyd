% import example map
image = imread('testMap2.jpg');
image = imresize(image, [600, 600]);
grayimage = rgb2gray(image);
bwimage = grayimage < 0.5;
map = binaryOccupancyMap(bwimage, 1);

% define robot dimensions and inflate the map
% to ensure that the robot not collide with any obstacles, you should
% inflate the map by the dimension of the robot before supplying to the PRM
% path planner
robotRadius = 0.1;
mapInflated = copy(map); % 원본 map 복사 
inflate(mapInflated, robotRadius);

% A Star
planner = plannerAStarGrid(mapInflated, GCost="Euclidean");

% testMap1
%start = [550, 2300];
%goal = [1900, 2650];

% testMap2
start = [100, 100];
goal = [100, 550];

tic
plan(planner, start, goal); % 경로 계획.

% 결과 시각화
show(planner)
toc

waypoint = ans;
len = length(waypoint);

for j = 1:50
    for i = 1:len
        waypoint_x = smoothdata(waypoint(:,1), 'movmean',20);
        waypoint_y = smoothdata(waypoint(:,2), 'movmean', 20);
    end
end

plot(waypoint_x, waypoint_y, '-o')
hold on
plot(waypoint(:,1), waypoint(:,2), '-x')
hold off
legend('smoothed path', 'original path')
xlim([0 600])
ylim([0 600])

%refPathObj = referencePathFrenet(waypoint, DiscretizationDistance=1);

%show(refPathObj)

xlabel('X');
ylabel('Y');

