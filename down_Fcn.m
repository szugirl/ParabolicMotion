function  [cross_x, cross_y, best_theta] = down_Fcn(H, V0, G, k, b)
% H--���׸߶�
% V0--�׳��ٶ�
% G--�������ٶ�
% k--б��б��
% b--б��
cross_x = 0;
cross_y = 0;
best_theta = 0;
distance_x = -1*b/k;
syms x
for theta = linspace(0, pi/2, 100)
    eqns = [k*x + b == H + tan(theta)*x - 0.5*G*x^2*(1/cos(theta))^2/(V0^2), x< distance_x, x>0];    % ע��x���ܵ���0
    vars = [x];
    next_x = double(solve(eqns, vars));
    next_y = k * next_x + b;
    if next_x > cross_x
        cross_x = next_x;
        cross_y = next_y;
        best_theta = theta;
    end
    eqns = [0 == H + tan(theta)*x - 0.5*G*x^2*(1/cos(theta))^2/(V0^2), x>= distance_x];    % ע��x���ܵ���0
    vars = [x];
    next_x = double(solve(eqns, vars));
    next_y = 0;
    if next_x > cross_x
        cross_x = next_x;
        cross_y = next_y;
        best_theta = theta;
    end
end 

end