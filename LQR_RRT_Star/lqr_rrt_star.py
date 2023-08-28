import copy
import math
import numpy as np

import env, plotting, utils, queue
from Node import Node
from lqr2 import LQR

class LqrRrtStar:
    def __init__(self, x_start, x_goal, step_len, goal_sample_rate, search_radius, iter_max): #시작노드좌표, 목표노드좌표, 노드간 거리 조절, 목표노드 생성확률, 탐색반경, 최대 탐색 횟수
        self.s_start = Node(x_start) # 시작 노드 설정
        self.s_goal = Node(x_goal) # 목표 노드 설정
        self.step_len = step_len
        self.goal_sample_rate = goal_sample_rate
        self.search_radius = search_radius
        self.iter_max = iter_max
        self.vertex = [self.s_start] # 탐색된 노드 저장
        self.path = [] # 경로 저장

        self.env = env.Env() # Env 클래스 객체 생성
        self.plotting = plotting.Plotting(x_start, x_goal)
        self.utils = utils.Utils()

        self.x_range = self.env.x_range
        self.y_range = self.env.y_range
        self.obs_circle = self.env.obs_circle
        self.obs_rectangle = self.env.obs_rectangle
        self.obs_boundary = self.env.obs_boundary

        self.lqr_planner = LQR()

    def planning(self):
        for k in range(self.iter_max):
            node_rand = self.generate_random_node(self.goal_sample_rate) # 랜덤 노드 생성
            node_near = self.nearest_neighbor(self.vertex, node_rand)
            node_new = self.steer(node_near, node_rand)

            if k % 500 == 0:
                print(k)

            if node_new and not self.utils.is_collision(node_near, node_new):
                neighbor_index = self.find_near_neighbor(node_new)
                self.vertex.append(node_new)

                if neighbor_index:
                    self.choose_parent(node_new, neighbor_index)
                    self.rewire(node_new, neighbor_index)

        index = self.search_goal_parent()
        self.path = self.extract_path(self.vertex[index])

        self.plotting.animation(self.vertex, self.path, "rrt*, N = " + str(self.iter_max))

    def choose_parent(self, node_new, neighbor_index):
        cost = [self.get_new_cost(self.vertex[i], node_new) for i in neighbor_index]

        cost_min_index = neighbor_index[int(np.argmin(cost))]
        node_new.parent = self.vertex[cost_min_index]

    def rewire(self, node_new, neighbor_index):
        for i in neighbor_index:
            node_neighbor = self.vertex[i]

            if self.cost(node_neighbor) > self.get_new_cost(node_new, node_neighbor):
                node_neighbor.parent = node_new

    def search_goal_parent(self):
        dist_list = [math.hypot(n.x - self.s_goal.x, n.y - self.s_goal.y) for n in self.vertex]
        node_index = [i for i in range(len(dist_list)) if dist_list[i] <= self.step_len]

        if len(node_index) > 0:
            cost_list = [dist_list[i] + self.cost(self.vertex[i]) for i in node_index
                         if not self.utils.is_collision(self.vertex[i], self.s_goal)]
            return node_index[int(np.argmin(cost_list))]

        return len(self.vertex) - 1

    def get_new_cost(self, node_start, node_end):
        dist, _ = self.get_distance_and_angle(node_start, node_end)

        return self.cost(node_start) + dist

    # 랜덤 노드 생성하는 함수
    def generate_random_node(self, goal_sample_rate):
        delta = self.utils.delta # 0.5로 설정

        if np.random.random() > goal_sample_rate: # 랜덤수가 goal_sample_rate보다 큰 경우
            return Node((np.random.uniform(self.x_range[0] + delta, self.x_range[1] - delta), np.random.uniform(self.y_range[0] + delta, self.y_range[1] - delta))) # env의 x,y 범위 내 랜덤 좌표에 대한 노드 반환

        return self.s_goal # if가 아닌 경우 목표 노드 반환

    def find_near_neighbor(self, node_new):
        n = len(self.vertex) + 1
        r = min(self.search_radius * math.sqrt((math.log(n) / n)), self.step_len)

        dist_table = [math.hypot(nd.x - node_new.x, nd.y - node_new.y) for nd in self.vertex]
        dist_table_index = [ind for ind in range(len(dist_table)) if dist_table[ind] <= r and
                            not self.utils.is_collision(node_new, self.vertex[ind])]

        return dist_table_index

    # node_list 중 n노드와 가장 가까운 노드 구하는 함수
    def nearest_neighbor(self, node_list, n):
        return node_list[int(np.argmin([math.hypot(nd.x - n.x, nd.y - n.y) for nd in node_list]))] # node_list의 노드들과 n노드 사이의 유클리드 거리를 계산하여 거리가 가장 최소인 노드 반환

    @staticmethod
    def cost(node_p):
        node = node_p
        cost = 0.0

        while node.parent:
            cost += math.hypot(node.x - node.parent.x, node.y - node.parent.y)
            node = node.parent

        return cost

    def update_cost(self, parent_node):
        OPEN = queue.QueueFIFO()
        OPEN.put(parent_node)

        while not OPEN.empty():
            node = OPEN.get()

            if len(node.child) == 0:
                continue

            for node_c in node.child:
                node_c.Cost = self.get_new_cost(node, node_c)
                OPEN.put(node_c)

    def extract_path(self, node_end):
        path = [[self.s_goal.x, self.s_goal.y]]
        node = node_end

        while node.parent is not None:
            path.append([node.x, node.y])
            node = node.parent
        path.append([node.x, node.y])

        return path

    @staticmethod
    def get_distance_and_angle(node_start, node_end):
        dx = node_end.x - node_start.x
        dy = node_end.y - node_start.y
        return math.hypot(dx, dy), math.atan2(dy, dx)

    def sample_path(self, course_x, course_y):
        part_x, part_y, course_len = [], [], []

        for i in range(len(course_x) - 1):
            for k in np.arange(0.0, 1.0, self.step_len):
                part_x.append(k * course_x[i + 1] + (1.0 - k) * course_x[i]) # course_x[i]와 course_x[i + 1]의 선형 보간
                part_y.append(k * course_y[i + 1] + (1.0 - k) * course_y[i]) # course_y[i]와 course_y[i + 1]의 선형 보간

        dx = np.diff(part_x) # 리스트 part_x 원소들의 차이
        dy = np.diff(part_y) # 리스트 part_y 원소들의 차이
        clen = [math.hypot(idx, idy) for (idx, idy) in zip(dx, dy)] # dx, dy를 이용한 거리 산출

        return part_x, part_y, clen

    def steer(self, from_node, to_node):
        course_x, course_y = self.lqr_planner.lqr_planning(from_node, to_node) # LQR을 활용한 x, y 좌표 리스트
        part_x, part_y, course_lens = self.sample_path(course_x, course_y)

        if part_x is None:
            return None

        newNode = copy.deepcopy(from_node)
        newNode.x = part_x[-1] # to_node에 가장 보간 지점_x
        newNode.y = part_y[-1] # to_node에 가장 보간 지점_y
        newNode.cost += sum([abs(c) for c in course_lens]) # newNode의 cost 최신화
        newNode.parent = from_node # newNode의 부모 노드 최신화

        return newNode