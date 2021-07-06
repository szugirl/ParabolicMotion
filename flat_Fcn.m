function [best_theta, max_distance] = flat_Fcn(H, V0, G)
% H--抛出高度
% V0--抛出速度
% G--重力加速度

% 定义方程（斜抛运动）
syms theta y t   % 定义符号变量
eqns = [V0 * cos(theta) * t == y, -V0 * sin(theta) * t + 0.5 * G * t^2 == H];    % 列出x和y方向上的等式
vars = [y t];  % 变量为y和t
relate_function = solve(eqns, vars);  % solve()求多变量方程组，得出射程y和theta的关系式（我们需要的），时间t和theta的关系式

distance_function = @(theta) -1 * (V0 .* cos(theta) .* ((V0 .* sin(theta) + ((V0 .* sin(theta)).^2 + 2 .* G .* H).^(1/2)) ./ G));

% 求出射程最大时的角度，和射程最大值
[best_theta, max_distance] = fminbnd(distance_function, 0, pi/2);
max_distance = abs(max_distance);

end

    