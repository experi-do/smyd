import numpy as np
import math

class LQR:
    def __init__(self):
        self.A = np.array([[0.1, 0.0], [0.0, 0.1]])
        self.B = np.array([0.0, 1.0]).reshape(2, 1)
        self.Q = np.eye(2)  # State cost matrix
        self.R = np.eye(1)  # Input cost matrix

        self.iter_max = 150
        self.time_max = 100
        self.goal_dist = 0.1
        self.eps = 0.01

    def solve_lqr(self):  # Riccati equation
        p_temp, p = self.Q, self.Q

        # P값 구하기(리카티 방정식 사용)
        for i in range(self.iter_max):
            p = self.A.T * p_temp * self.A - self.A.T * p_temp * self.B * np.linalg.inv(self.R + self.B.T * p_temp * self.B) * self.B.T * p_temp * self.A + self.Q
            if (abs(p - p_temp)).max() < self.eps:
                break
            p_temp = p

        # K값 구하기
        k = np.linalg.inv(self.B.T @ p @ self.B + self.R) @ (self.B.T @ p @ self.A)

        # 시스템의 균형점에서의 고유값을 나타냄(안정화 정도)
        eigValues = np.linalg.eigvals(self.A - self.B @ k)

        return k, p, eigValues

    def u_star(self, x):    # 최적 제어 입력값 구하기
        k_opt, p, ev = self.solve_lqr()
        u_star = -k_opt @ p
        return u_star

    def lqr_planning(self, start, goal): # LQR을 활용한 두 노드 간의 경로 계획
        course_x = [start.x] # 경로의 x좌표
        course_y = [start.y] # 경로의 y좌표

        x = np.array([[start.x - goal.x], [start.y - goal.y]])

        found_path = False
        time = 0.0

        while time <= self.time_max:
            time += 0.1

            u_opt = self.u_star(x)
            x = self.A @ x + self.B @ u_opt # x* = Ax + Bu / f(x0, u0)에 대한 테일러 전개

            course_x.append(x[0][0] + goal.x)
            course_y.append(x[1][0] + goal.y)

            dist = math.hypot(goal.x - course_x[-1], goal.y - course_y[-1])
            if dist <= self.goal_dist:
                found_path = True
                break

        if not found_path: # path를 찾지 못한 경우
            print("Cannot found path")
            return [], []

        return course_x, course_y