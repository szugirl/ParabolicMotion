function [best_theta, max_distance] = flat_Fcn(H, V0, G)
% H--�׳��߶�
% V0--�׳��ٶ�
% G--�������ٶ�

% ���巽�̣�б���˶���
syms theta y t   % ������ű���
eqns = [V0 * cos(theta) * t == y, -V0 * sin(theta) * t + 0.5 * G * t^2 == H];    % �г�x��y�����ϵĵ�ʽ
vars = [y t];  % ����Ϊy��t
relate_function = solve(eqns, vars);  % solve()�����������飬�ó����y��theta�Ĺ�ϵʽ��������Ҫ�ģ���ʱ��t��theta�Ĺ�ϵʽ

distance_function = @(theta) -1 * (V0 .* cos(theta) .* ((V0 .* sin(theta) + ((V0 .* sin(theta)).^2 + 2 .* G .* H).^(1/2)) ./ G));

% ���������ʱ�ĽǶȣ���������ֵ
[best_theta, max_distance] = fminbnd(distance_function, 0, pi/2);
max_distance = abs(max_distance);

end

    