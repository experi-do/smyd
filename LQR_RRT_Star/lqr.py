import numpy as np
np.set_printoptions(precision=3,suppress=True)

class LQR:
    def __init__(self, yaw, dt):
        self.yaw = yaw
        self.dt = dt
        self.max_linear_v = 3.0 # 최대 meters/sec
        self.max_angular_v = 1.5708 # 최대 radians/sec
        self.A = np.array([[1.0, 0, 0], [0, 1.0, 0], [0, 0, 1.0]]) # 행렬 A
        self.x_prev = np.array([0.0, 0.0, 0.0]) # t-1에서 x
        self.u_prev = np.array([4.5, 0.05]) # t-1에서 u
        self.R = np.array([[0.01, 0], [0, 0.01]]) # Input cost matrix
        self.Q = np.array([[1, 0, 0], [0, 1, 0], [0, 0, 1]]) # State cost matrix

    def getB(self):
        B = np.array([[np.cos(self.yaw)*self.dt, 0], [np.sin(self.yaw)*self.dt, 0], [0, self.dt]]) # 행렬 B
        return B

    def state_space(self):
        yaw_angle = 0.0 # radius
        delta_t = 1.0 # seconds

        # self.u_prev이 -self.max_linear_v와 self.max_linear_v를 넘어가지 않도록 함.
        self.u_prev[0] = np.clip(self.u_prev[0], -self.max_linear_v, self.max_linear_v)
        self.u_prev[1] = np.clip(self.u_prev[1], -self.max_angular_v, self.max_angular_v)
        x_curr = (self.A @ self.x_prev) + ((self.getB(self.yaw, self.dt)) @ self.u_prev)
        return x_curr

    def lqr(self, actual_state, desired_state):
        x_error = actual_state - desired_state
        N = 50
        P = [None]*(N+1)
        qf = self.Q
        P[N] = qf

        for i in range(N, 0, -1):
            # Discrete-time Algebraic Riccati equation to calculate the optimal
            # state cost matrix
            P[i - 1] = self.Q + self.A.T @ P[i] @ self.A - (self.A.T @ P[i] @ self.B) @ np.linalg.pinv(self.R + self.B.T @ P[i] @ self.B) @ (self.B.T @ P[i] @ self.A) # Riccati equation. 재귀로 계산

        k = [None] * N # Optimal Feedback gain(가중치 역할)
        u = [None] * N

        for i in range(N):
            k[i] = -np.linalg.pinv(self.R + self.B.T @ P[i+1] @ self.B) @ self.B.T @ P[i+1] @ self.A
            u[i] = k[i] @ x_error

        u_star = u[N-1] # Optimal control input
        return u_star



def getB(yaw, dt):
    B = np.array([[np.cos(yaw)*dt, 0], [np.sin(yaw)*dt, 0], [0, dt]]) # 행렬 B
    return B

def solve_dare(A, B, Q, R): # Riccati equation
    p_temp, p = Q, Q

    for i in range(50):
        p = A.T * p_temp * A - A.T * p_temp * B * np.linalg.inv(R + B.T * p_temp * B) * B.T * p_temp * A + Q
        if (abs(p-p_temp)).max() < 0.01:
            break
        p_temp = p

    k = np.linalg.inv(R) * B * p

    return k, p

def solve_k()

def lqr(v_list, x, N):
    A = np.array([[0.1, 1.0], [0.0, 0.1]])
    B = np.array([0.0, 1.0]).reshape(2, 1)
    Q = np.array([[1, 0, 0], [0, 1, 0], [0, 0, 1]])  # State cost matrix
    R = np.array([[0.01, 0], [0, 0.01]])  # Input cost matrix


    for v is v_list:






