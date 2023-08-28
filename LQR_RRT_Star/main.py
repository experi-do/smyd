from lqr_rrt_star import LqrRrtStar

def main():
    x_start = (18, 8)  # Starting node
    x_goal = (37, 18)  # Goal node

    lqr_rrt_star = LqrRrtStar(x_start, x_goal, 10, 0.10, 20, 15000)
    lqr_rrt_star.planning()

if __name__ == '__main__':
    main()
