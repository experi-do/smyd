import numpy as np
import matplotlib.pyplot as plt
import cv2

# 맵이미지 처리
img_origin = cv2.imread('testMap2.jpg') # 맵 이미지 불러오기
img_origin = cv2.resize(img_origin, (640, 640)) # 맵 사이즈 조절
img_gray = cv2.cvtColor(img_origin, cv2.COLOR_BGR2GRAY) # 그레이 스케일로 변환
img_gray = img_gray / 255 # 정규화
ret, img_gray = cv2.threshold(img_gray, 0.5, 1, cv2.THRESH_BINARY) # thresholding
plt.imshow(img_gray) # matplotlib으로 imshow
plt.xlim([0, 640]) # pyplot에서 x 범위
plt.ylim([0, 640]) # pyplot에서 y 범위
plt.show()

# Barrier Inflation Function


# Node class
class Node:
    def __init__(self, img, position, parent=None):
        self.img = img
        self.position = position # 현재 노드의 좌표
        self.parent = parent # 현재 노드의 부모 모드 좌표

        self.g = 0 # start node에서 현재 노드까지의 cost
        self.h = 0 # 현재 노드에서 end node까지의 예상 cost
        self.f = 0 # f = g + h

        self.tempTuple = ()
        self.connectableNode_within_range = []
        self.cnt1 = 0
        self.map_size = img(len(maze), len(maze[0])) # map의 크기 / map이 바뀔 경우, 변경 필요
        self.newNode = None

    def neighborNode(self, currentNode):
        # currentNode의 주변 노드들에 대하여 범위 내에 있는 노드인지, 장애물은 아닌지 판별
        for connectedNode in [(-1, -1), (-1, 1), (-1, 0), (0, -1), (0, 1), (1, -1), (1, 1), (1, 0)]:
            self.tempTuple = (currentNode.position[0] + connectedNode[0], currentNode.position[1] + connectedNode[1])
            self.cnt1 += 1
            print("cnt1 : ", self.cnt1)
            print("tempTuple : ", self.tempTuple)

            # tempTuple(연결되어 있는 노드)이 index 범위 안에 있어야 함.(조건 리스트)
            self.connectableNode_within_range = [
                self.tempTuple[0] > self.map_size[0] - 1,
                self.tempTuple[0] < 0,
                self.tempTuple[1] > self.map_size[1] - 1,
                self.tempTuple[1] < 0
            ]

            # connectableNode_within_range의 4가지 조건 중 하나라도 만족하면 img 범위 밖임.
            if any(connectableNode_within_range):
                print('tempTuple 범위 밖')
                continue  # 범위 밖인 좌표는 connectableNode 리스트에 추가하지 않음.

            # img에서 해당 좌표의 값이 0이 아니라면 장애물로 간주하고 주변 노드를 찾지 않음.
            if self.img[self.tempTuple[0]][self.tempTuple[1]] != 0:
                print('tempTuple 장애물')
                continue

            # 범위 내에 있고 장애물이 아닌 노드는 new_node로 초기화한 후 children 리스트에 Node 클래스로 저장
            self.newNode = Node(self.tempTuple, currentNode)
            return self.newNode

    def cost_calculation(self, childrenList, startNode, currentNode, endNode):
        # currentNode의 자식 노드 중 openList에 들어갈 자식 노드를 찾아 최신화하는 과정


# Initial set-up
startNode_xy = (10, 10)
endNode_xy = (600, 600)

startNode = Node(img_gray, startNode_xy, None)
endNode = Node(img_gray, endNode_xy, None)

# List
openList = [] # Node 클래스가 추가
openList_xy = [] # Node의 좌표가 추가
closedList = [] # Node 클래스가 추가
closedList_xy = [] # Node의 좌표가 추가

openList.append(startNode)
openList_xy.append(startNode_xy)



