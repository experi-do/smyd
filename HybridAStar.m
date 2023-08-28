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

% Hybrid AStar
ss = stateSpaceSE2; % state space
sv = validatorOccupancyMap(ss); % 2차원 그리드 맵 기반의 상태 유효성 검사(충돌 여부)
sv.Map = mapInflated;
sv.ValidationDistance = 0.1;
ss.StateBounds = [mapInflated.XWorldLimits; mapInflated.YWorldLimits; [-pi, pi]];
planner = plannerHybridAStar(sv, MotionPrimitiveLength=6, MinTurningRadius=4);

% testMap1
%start = [550, 2300, 0];
%goal = [1900, 2650, 0];

% testMap2
start = [100, 500, 0];
goal = [550, 500, 0];

tic
pathObj = plan(planner, start, goal); % 경로 계획. path와 solutionInfo 도출.

% 결과 시각화
show(planner)
toc
% 이동 거리 계산 
len = pathLength(pathObj);
disp("Path Length = " +num2str(len))