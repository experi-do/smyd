import random
import math
import pygame


class RRTMap: # Map을 그리기 위해 필요한 함수를 모아놓은 클래스
    def __init__(self, start, goal, MapDimensions, obsdim, obsnum):
        self.start = start # 시작 지점
        self.goal = goal # 도착 지점
        self.MapDimensions = MapDimensions # Map의 크기
        self.Maph, self.Mapw = self.MapDimensions # Maph에 Map의 height, Mapw에 Map의 width를 초기화

        # window settings
        self.MapWindowName = 'RRT path planning'
        pygame.display.set_caption(self.MapWindowName)
        self.map = pygame.display.set_mode((self.Mapw, self.Maph))
        self.map.fill((255, 255, 255)) # Map의 배경 흰색 지정
        self.nodeRad = 2
        self.nodeThickness = 0
        self.edgeThickness = 1

        self.obstacles = [] # 장애물 리스트
        self.obsDim = obsdim # 장애물 개수
        self.obsNumber = obsnum # 장애물 인덱스

        # Colors
        self.Gray = (70, 70, 70)
        self.Blue = (0, 0, 255)
        self.Green = (0, 255, 0)
        self.Red = (255, 0, 0)
        self.White = (255, 255, 255)

    def drawObs(self, obstacles): # 장애물 표시
        obstaclesList = obstacles.copy()
        while (len(obstaclesList) > 0): # obstacleList에 인덱스가 0인 원소를 하나씩 꺼내면서 obstacle에 초기화 후 제거
            obstacle = obstaclesList.pop(0)
            pygame.draw.rect(self.map, self.Gray, obstacle) # obstacle을 회색 사각형으로 Map 위에 표시

    def drawMap(self, obstacles): # 초기 Map
        pygame.draw.circle(self.map, self.Green, self.start, self.nodeRad + 5, 0) # 시작 지점을 초록색 작은 원으로 표시
        pygame.draw.circle(self.map, self.Green, self.goal, self.nodeRad + 20, 1) # 도착 지점을 초록색 큰 원으로 표시
        self.drawObs(obstacles) # drawObs 함수를 통해 장애물 표시

    def drawPath(self, path):
        for node in path: # path로 지정된 node에 대해서 빨간색 원으로 표시
            pygame.draw.circle(self.map, self.Red, node, self.nodeRad + 3, 0)

class RRTGraph: # Map을 구성하는 원소들을 설정하는데 필요한 함수를 모아놓은 클래스
    def __init__(self, start, goal, MapDimensions, obsdim, obsnum):
        (x, y) = start # 시작 지점 좌표
        self.start = start
        self.goal = goal
        self.goalFlag = False  # 목표 영영에 도달하면 True
        self.maph, self.mapw = MapDimensions
        self.x = [] # x 좌표를 저장하는 리스트
        self.y = [] # y 좌표를 저장하는 리스트
        self.parent = [] # 부모 노드를 저장하는 리스트
        # initialize the tree
        self.x.append(x)
        self.y.append(y)
        self.parent.append(0)
        # the obstacles
        self.obstacles = []
        self.obsDim = obsdim
        self.obsNum = obsnum
        # path
        self.goalstate = None
        self.path = []

    def makeRandomRect(self): # 장애물을 의미하는 사각형 꼭짓점 좌표 랜덤 설정
        uppercornerx = int(random.uniform(0, self.mapw - self.obsDim))  # 맵 외부에 생성하지 않도록 self.obsDim을 빼줌.
        uppercornery = int(random.uniform(0, self.maph - self.obsDim))
        return (uppercornerx, uppercornery)

    def makeobs(self): # 장애물 생성
        obs = []

        for i in range(0, self.obsNum):
            rectang = None
            startgoalcol = True
            while startgoalcol:
                upper = self.makeRandomRect() # 직사각형 꼭짓점 좌표 반환
                rectang = pygame.Rect(upper, (self.obsDim, self.obsDim)) # 해당 좌표를 직사각형으로 설정(cf. pygame.draw.rect가 그리는 것)
                if rectang.collidepoint(self.start) or rectang.collidepoint(self.goal):  # collidepoint : 인자와의 좌표 검증
                    startgoalcol = True
                else:
                    startgoalcol = False
            obs.append(rectang)
        self.obstacles = obs.copy()
        return obs

    def add_node(self, n, x, y): # 새로운 노드 추가
        self.x.insert(n, x)
        self.y.append(y)

    def remove_node(self, n): # (x, y)가 장애물 내에 있을 때
        self.x.pop(n)
        self.y.pop(n)

    def add_edge(self, parent, child): # 부모노드와 자식노드 사이의 edge 연결
        self.parent.insert(child, parent)

    def remove_edge(self, n): # edge를 제거하고 부모 노드 제거
        self.parent.pop(n)

    def number_of_nodes(self): # 노드의 개수
        return len(self.x)

    def distance(self, n1, n2): # 노드 사이의 거리 구하기
        (x1, y1) = (self.x[n1], self.y[n1])
        (x2, y2) = (self.x[n2], self.y[n2])
        px = (float(x1) - float(x2)) ** 2
        py = (float(y1) - float(y2)) ** 2
        return (px + py) ** (0.5)

    def sample_envir(self): # 샘플점(random node) 생성
        x = int(random.uniform(0, self.mapw))
        y = int(random.uniform(0, self.maph))
        return x, y

    def nearest(self, n): # 트리에서 random node와 가장 가까운 노드를 구할 때 사용
        dmin = self.distance(0, n)
        nnear = 0
        for i in range(0, n):
            if self.distance(i, n) < dmin:
                dmin = self.distance(i, n)
                nnear = i
        return nnear

    def isFree(self): # 노드가 장애물과 충돌하는지 판별하는데 사용
        n = self.number_of_nodes() - 1  # 노드 index가 0부터 시작되기 때문.
        (x, y) = (self.x[n], self.y[n])
        obs = self.obstacles.copy()
        while len(obs) > 0:
            rectang = obs.pop(0)
            if rectang.collidepoint(x, y):
                self.remove_node(n)
                return False
        return True

    def crossObstacle(self, x1, x2, y1, y2): # edge가 장애물과 충돌하는지 판별하는데 사용
        obs = self.obstacles.copy()
        while (len(obs) > 0):
            rectang = obs.pop(0)
            for i in range(0, 101):
                u = i / 100
                x = x1 * u + x2 * (1 - u)
                y = y1 * u + y2 * (1 - u)
                if rectang.collidepoint(x, y):
                    return True  # edge가 장애물과 적어도 한 번 이상 판별하는 경우
        return False

    def connect(self, n1, n2): # 트리와 새로운 노드 연결할 때 사용
        (x1, y1) = (self.x[n1], self.y[n1])
        (x2, y2) = (self.x[n2], self.y[n2])
        if self.crossObstacle(x1, x2, y1, y2): # 노드와 장애물이 충돌하는 경우
            self.remove_node(n2)
            return False
        else:
            self.add_edge(n1, n2) # 새로운 노드가 자유 공간 내에 있는 경우
            return True

    def step(self, nnear, nrand, dmax=35):  # 점nnear과 점nrand 사이의 점 (x, y) 좌표 구하기
        d = self.distance(nnear, nrand)
        print('d : ', d)
        if d > dmax:
            u = dmax / d
            (xnear, ynear) = (self.x[nnear], self.y[nnear])
            (xrand, yrand) = (self.x[nrand], self.y[nrand])
            (px, py) = (xrand - xnear, yrand - ynear) # near node와 random node 사이의 px, py
            theta = math.atan2(py, px) # 둘 사이의 각도
            (x, y) = (int(xnear + dmax * math.cos(theta)), int(ynear + dmax * math.sin(theta))) # 두 노드 사이의 새로운 노드
            self.remove_node(nrand)
            if abs(x-self.goal[0]) < dmax and abs(y - self.goal[1] < dmax): # 새로운 노드와 목표지점이 일정 거리 내에 있으면 목표지점에 도달한 것으로 판단
                self.add_node(nrand, self.goal[0], self.goal[1])
                self.goalstate = nrand
                self.goalFlag = True
            else:
                self.add_node(nrand, x, y) # 목표지점과 일정 거리 내로 들어오지 않으면 새로운 노드를 트리로 편입

    def path_to_goal(self): # 경로
        if self.goalFlag: # 목표지점에 도달한 경우
            self.path=[]
            self.path.append(self.goalstate)
            newpos = self.parent[self.goalstate]
            while (newpos != 0):
                self.path.append(newpos)
                newpos = self.parent[newpos]
            self.path.append(0)
        return self.goalFlag

    def getPathCoords(self): # 경로 내에 노드의 좌표 리스트
        pathCoords = []
        for node in self.path:
            x, y = (self.x[node], self.y[node])
            pathCoords.append((x, y))
        return pathCoords

    def bias(self, ngoal): # ngoal은 목표지점의 좌표
        n = self.number_of_nodes()
        self.add_node(n, ngoal[0], ngoal[1])
        nnear = self.nearest(n)
        self.step(nnear, n)
        self.connect(nnear, n)
        return self.x, self.y, self.parent

    def expand(self): # 트리의 확장
        n = self.number_of_nodes()
        x, y = self.sample_envir()
        self.add_node(n, x, y)
        if self.isFree():
            xnearest = self.nearest(n)
            self.step(xnearest, n)
            self.connect(xnearest, n)
        return self.x, self.y, self.parent