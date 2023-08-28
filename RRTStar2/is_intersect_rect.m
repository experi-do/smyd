function is_intersect = is_intersect_rect(start_node, end_node, pnt1, pnt2)
    %선분 A의 시작점과 끝점
    xA1 = start_node.x;
    xA2 = end_node.x;
    yA1 = start_node.y;
    yA2 = end_node.y;

    %선분 B의 시작점과 끝점
    xB1 = pnt1(1);
    xB2 = pnt2(1);
    yB1 = pnt1(2);
    yB2 = pnt2(2);

    %경계상자 계산
    xminA = min(xA1, xA2);
    xmaxA = max(xA1, xA2);
    yminA = min(yA1, yA2);
    ymaxA = max(yA1, yA2);
    xminB = min(xB1, xB2);
    xmaxB = max(xB1, xB2);
    yminB = min(yB1, yB2);
    ymaxB = max(yB1, yB2);

    %경계상자의 중심점 계산
    centerA = [(xminA + xmaxA)/2, (yminA + ymaxA)/2];
    centerB = [(xminB + xmaxB)/2, (yminB + ymaxB)/2];

    %경계상자의 너비와 높이 계산
    widthA = xmaxA - xminA;
    heightA = ymaxA - yminA;
    widthB = xmaxB - xminB;
    heightB = ymaxB - yminB;

    %두 경계상자가 겹치는지 확인
    if abs(centerA(1) - centerB(1)) < (widthA + widthB) / 2 && abs(centerA(2) - centerB(1)) < (heightA + heightB)/2
        %두 선분이 교차하는지 판별
        if det([xA2 - xA1, xB1 - xA1; xA2 - yA1, yB1-yA1]) * det([xA2-xA1, xB2-xA1; yA2-yA1, yB2-yA1]) < 0 && det([xB2-xB1, xA1-xB1; yB2-yB1, yA1-yB1]) * det([xB2-xB1, xA2-xB1; yB2-yB1, yA2-yB1]) < 0
            is_intersect = true;
        else
            is_intersect = false;
        end
    else
        is_intersect = false;
    end
end

