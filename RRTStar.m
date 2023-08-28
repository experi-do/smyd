% import example map
image = imread('testMap2.jpg');
image = imresize(image, [600, 600]);
imshow(image)
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

% RRT Star
ss = stateSpaceSE2; % state space
sv = validatorOccupancyMap(ss); % 2차원 그리드 맵 기반의 상태 유효성 검사(충돌 여부)
sv.Map = mapInflated;
sv.ValidationDistance = 0.1;
ss.StateBounds = [mapInflated.XWorldLimits; mapInflated.YWorldLimits; [-pi, pi]];
planner = plannerRRTStar(ss, sv, ContinueAfterGoalReached=true, MaxIterations=5000, MaxconnectionDistance=100);

% testMap1
%start = [125, 425, 0];
%goal = [575, 575, 0];

% testMap2
start = [100, 500, 0];
goal = [550, 500, 0];

rng(1, 'twister') % 난수 생성기
tic
[pathObj, solnInfo] = plan(planner, start, goal); % 경로 계획. path와 solutionInfo 도출.

% 결과 시각화
map.show
hold on % 좌표축에 plot이 새로 추가될 때, 기존 plot이 삭제되지 않도록 현재 좌표축을 plot을 유지.

% tree expansion
plot(solnInfo.TreeData(:,1), solnInfo.TreeData(:,2), '.-')
% draw path
plot(pathObj.States(:,1), pathObj.States(:,2), 'r-', 'LineWidth', 2)
toc
len = pathLength(pathObj);
disp("Path Length = " +num2str(len))

for i = 1:len
    pathObj.States(:,1) = smoothdata(pathObj.States(:,1), 'movmean', 3);
    pathObj.States(:,2) = smoothdata(pathObj.States(:,2), 'movmean', 3);
end

plot(pathObj.States(:,1), pathObj.States(:,2), '-o')
