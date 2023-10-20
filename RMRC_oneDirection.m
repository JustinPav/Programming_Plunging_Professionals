function RMRC_oneDirection(robot, steps, value, dir)


t = 10;                         % Total time (s)
deltaT = t/steps;               % No. of steps for simulation
epsilon = 0.1;                  % Threshold value for manipulability/Damped Least Squares

m = zeros(steps,1);             % Array for Measure of Manipulability
qMatrix = zeros(steps,robot.model.n);       % Array for joint anglesR
qdot = zeros(steps,robot.model.n);          % Array for joint velocities
theta = zeros(3,steps);         % Array for roll-pitch-yaw angles
x = zeros(3,steps);             % Array for x-y-z trajectory

Tr = robot.model.fkine(robot.model.getpos).T; % Get robot's current position
rpy = tr2rpy(Tr(1:3,1:3));

if dir == 1
    a = linspace(Tr(1,4),value,steps);
    for i=1:steps
        x(1,i) = a(i);          % Points in x
        x(2,i) = Tr(2,4);       % Points in y
        x(3,i) = Tr(3,4);       % Points in z
        theta(1,i) = rpy(1);    % Roll angle
        theta(2,i) = rpy(2);    % Pitch angle
        theta(3,i) = rpy(3);    % Yaw angle
    end
elseif dir == 2
    a = linspace(Tr(2,4),value,steps);
    for i=1:steps
        x(1,i) = Tr(1,4);       % Points in x
        x(2,i) = a(i);          % Points in y
        x(3,i) = Tr(3,4);       % Points in z
        theta(1,i) = rpy(1);    % Roll angle
        theta(2,i) = rpy(2);    % Pitch angle
        theta(3,i) = rpy(3);    % Yaw angle
    end
elseif dir == 3
    a = linspace(Tr(3,4),value,steps);
    for i=1:steps
        x(1,i) = Tr(1,4);       % Points in x
        x(2,i) = Tr(2,4);       % Points in y
        x(3,i) = a(i);          % Points in z
        theta(1,i) = rpy(1);    % Roll angle
        theta(2,i) = rpy(2);    % Pitch angle
        theta(3,i) = rpy(3);    % Yaw angle
    end
end

qMatrix(1,:) = robot.model.getpos;

for i = 1:steps-1
    T = robot.model.fkine(qMatrix(i,:)).T;                                           % Get forward transformation at current joint state
    deltaX = x(:,i+1) - T(1:3,4);                                         	% Get position error from next waypoint
    Rd = rpy2r(theta(1,i+1),theta(2,i+1),theta(3,i+1));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                                % Calculate rotation matrix error
    S = Rdot*Ra';                                                           % Skew symmetric!
    linear_velocity = (1/deltaT)*deltaX;
    angular_velocity = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    deltaTheta = tr2rpy(Rd*Ra');                                            % Convert rotation matrix to RPY angles
    xdot = [linear_velocity;angular_velocity];                          	% Calculate end-effector velocity to reach next waypoint.
    J = robot.model.jacob0(qMatrix(i,:));                 % Get Jacobian at current joint state
    m(i) = sqrt(det(J*J'));
    if m(i) < epsilon  % If manipulability is less than given threshold
        lambda = (1 - m(i)/epsilon)*5E-2;
    else
        lambda = 0;
    end
    invJ = inv(J'*J + lambda *eye(robot.model.n))*J';                                   % DLS Inverse
    qdot(i,:) = (invJ*xdot)';                                                % Solve the RMRC equation (you may need to transpose the         vector)
    for j = 1:robot.model.n                                                             % Loop through joints 1 to robot.model.n
        if qMatrix(i,j) + deltaT*qdot(i,j) < robot.model.qlim(j,1)                     % If next joint angle is lower than joint limit...
            qdot(i,j) = 0; % Stop the motor
        elseif qMatrix(i,j) + deltaT*qdot(i,j) > robot.model.qlim(j,2)                 % If next joint angle is greater than joint limit ...
            qdot(i,j) = 0; % Stop the motor
        end
    end
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT*qdot(i,:);                         	% Update next joint state based on joint velocities
end

robot.model.plot(qMatrix)