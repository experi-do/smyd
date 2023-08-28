% import example map
image = imread('map1.jpg');
image = imresize(image, [60, 60]);
%imshow(image)
grayimage = rgb2gray(image);
bwimage = grayimage < 0.5;
map = binaryOccupancyMap(bwimage, 1); % second parameter : resolution


% define robot dimensions and inflate the map
% to ensure that the robot not collide with any obstacles, you should
% inflate the map by the dimension of the robot before supplying to the PRM
% path planner
robotRadius = 1;

global mapInflated;
mapInflated = copy(map); % 원본 map 복사 
inflate(mapInflated, robotRadius);

% binaryOccupancyMap을 다시 이미지로
inflatedMap = occupancyMatrix(mapInflated);
inflatedMap = uint8(inflatedMap * 255);

figure;
%show(mapInflated);
figure;
%imshowpair(image, inflatedMap, 'montage');


x_start = [10, 10];
x_goal = [50, 50];

s_start = Node(x_start);
s_goal = Node(x_goal);

cost = CostFunc(s_start);
function cost = CostFunc(input_node)
    node = input_node;
    node_parent = node.parent;
    class(node_parent)
    cost = 0.0;
    while ~isempty(node_parent)
        disp('*')
        cost = cost + hypot(node.x - node_parent(1), node.y - node_parent(2));
        node = node.parent;
    end
end