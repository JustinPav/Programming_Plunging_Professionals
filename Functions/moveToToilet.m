function qMatrix = moveToToilet(kuka)

% Start with RMRC to move KUKA robot from its current position to to toilet
q0 = kuka.model.getpos;                                                    % Get robot start position
n = kuka.model.n;
t = 5;                                                                     % Total time in seconds
steps = 70;                                                               % No. of steps
deltaT = t/steps;                                                          % Discrete time step
qMatrix = zeros(steps,n);                                                  % Assign memory for joint angles
m = zeros(1,steps);                                                        % For recording measure of manipulability
minManipMeasure = 0.3;                                                     % Required for the dampled least square

% Set desired end position and create a trajectory between current position
% and end goal
Tr_goal = transl(0.6,0.5,0.65)*trotx(pi/2)*troty(pi/2)*trotz(pi);
Tr_current = kuka.model.fkine(q0).T;
x = zeros(3,steps);                                                        % set up our trajectory array
x(1,:) = linspace(Tr_current(1,4),Tr_goal(1,4),steps);                     % x trajectory
x(2,:) = linspace(Tr_current(2,4),Tr_goal(2,4),steps);                     % y trajectory
x(3,:) = linspace(Tr_current(3,4),Tr_goal(3,4),steps);                     % z trajectory

qMatrix(1,:) = q0;

for i = 1:steps-1
    T = kuka.model.fkine(qMatrix(i,:)).T;                                  % Get forward transformation at current joint state
    deltaX = x(:,i+1)-T(1:3,4);                                            % Get position error from next waypoint
    xdot = (1/deltaT)*deltaX;
    J = kuka.model.jacob0(qMatrix(i,:));                                   % Get Jacobian at current joint state
    J = J(1:3,:);

    m(i) = sqrt(det(J*J'));                                                % Record manipulability

    if m(i) < minManipMeasure                                              % If manipulability is less than given threshold
        lamda = 1 - (m(i)/minManipMeasure)^2;                              % Damping coefficient
        invJ = pinv(J'*J + lamda*eye(n)) * J';                              % Apply Damped Least Squares pseudoinverse
    else
        invJ = pinv(J);                                                     % Don't use DLS
    end
    qdot(i,:) = invJ*xdot;
    qMatrix(i+1,:) = qMatrix(i,:)+(deltaT*qdot(i,:));                      % Update next joint state based on joint velocities
end

qf = kuka.model.ikine(Tr_goal,qMatrix(steps,:));                           % Set an accurate goal for the end position of the robot and to align the end effector
qf(7) = qf(7)+pi/2;
qMatrix = [qMatrix;jtraj(qMatrix(steps,:),qf,50)];                         % Add the interpolation to the qMatrix

end