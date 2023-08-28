# 2번과 다른 파일로 개발해야 함.

import pygame
from RRTbasePy import RRTGraph
from RRTbasePy import RRTMap
import time

def main():
    dimensions = (600, 1000) # Map의 크기
    start = (50, 50) # 시작 지점
    goal = (810, 510) # 목표 지점
    obsdim = 30 # 장애물의 크기
    obsnum = 50 # 장애물의 개수
    iteration = 0 # 반복 횟수
    t1 = 0 # 시간

    pygame.init()
    map = RRTMap(start, goal, dimensions, obsdim, obsnum)
    graph = RRTGraph(start, goal, dimensions, obsdim, obsnum)

    obstacles = graph.makeobs() # 장애물 생성
    map.drawMap(obstacles) # 장애물을 포함한 Map 생성

    t1 = time.time()
    while (not graph.path_to_goal()): # 목표지점에 도달하지 않는 동안 진행
        elapsed = time.time() - t1
        t1 = time.time()
        if elapsed > 10:
            raise  # 10초가 넘어가면 timeout으로 설정하여 error 발생

        if iteration % 10 == 0: # 반복횟수가 10의 배수일 때, bias 진행
            X, Y, Parent = graph.bias(goal)
            pygame.draw.circle(map.map, map.Gray, (X[-1], Y[-1]), map.nodeRad + 2, 0)
            pygame.draw.line(map.map, map.Blue, (X[-1], Y[-1]), (X[Parent[-1]], Y[Parent[-1]]), map.edgeThickness)

        else: # 그 외에는 expand 진행
            X, Y, Parent = graph.expand()
            pygame.draw.circle(map.map, map.Gray, (X[-1], Y[-1]), map.nodeRad + 2, 0)
            pygame.draw.line(map.map, map.Blue, (X[-1], Y[-1]), (X[Parent[-1]], Y[Parent[-1]]), map.edgeThickness)

        if iteration % 5 == 0: # 반복횟수가 5의 배수일 때마다 display update
            pygame.display.update()
        iteration += 1

    map.drawPath(graph.getPathCoords())
    pygame.display.update()
    pygame.event.clear()
    pygame.event.wait(0)


if __name__ == '__main__':

    result = False
    while not result:
        try:
            main()
            result = True  # path를 찾은 경우 실행
        except:
            result = False  # path를 찾지 못한 경우 찾을 때까지 실행

