function q = controllerInput(joy,robot,dt,q0)

% read joystick
[axes, buttons, povs] = read(joy);

% 1 - turn joystick input into an end-effector velocity command
K_linear = 0.3;
K_angular = 0.8;
vx = K_linear*axes(3);
vy = K_linear*axes(4);
vz = -K_linear*axes(2);
wx = K_angular*(buttons(6)-buttons(5));
wy = K_angular*(buttons(8)-buttons(7));
wz = K_angular*(buttons(10)-buttons(9));

J = robot.model.jacob0(q0);

noJoints = robot.model.n;
if noJoints >=6
    x_dot = [vx vy vz wx wy wz]';
elseif noJoints == 5
    x_dot = [vx vy vz wx wz]';
    J = J([1:4,6],:);
end

% Check measure of manipubility
m = sqrt(det(J*J'));
minM = 0.07;

% 2 - use J inverse to calculate joint velocity
if m < minM
    lamda = (1 - (m/minM)^2)*0.1;
    J_inv = (J'*J + lamda*eye(size(J,2)))*J';

else
    J_inv = pinv(J);
end

% 3 - apply joint velocity to step robot joint angles
q_dot = J_inv*x_dot;
q = q0 + q_dot'*dt;

% Update plot
robot.model.animate(q);

end