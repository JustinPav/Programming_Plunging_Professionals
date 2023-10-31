function qMatrix = KUKAbleachToilet(kuka,q)

n = kuka.model.n;
t = 5;                                                                     % Total time in seconds
steps = 180;                                                               % No. of steps
deltaT = t/steps;                                                          % Discrete time step
qMatrix = zeros(steps,n);                                                  % Assign memory for joint angles
m = zeros(1,steps);                                                        % For recording measure of manipulability
minManipMeasure = 0.3;                                                     % Required for the dampled least square

% Create an array of location in a circle with 100mm radius around the
% toilet bowl
x = zeros(3,steps); 
d = 2*pi/steps;
for i = 1:steps
    x(1,i) = 0.1*cos(d)+0.6;
    x(2,i) = 0.1*sin(d)+0.5;
    x(3,i) = 0.65;
    d = d + 2*pi/steps;
end

qMatrix(1,:) = q;                                                          % Set the intial q value

for i = 1:steps-1
    T = kuka.model.fkine(qMatrix(i,:)).T;                                  % Get forward transformation at current joint state
    deltaX = x(:,i+1)-T(1:3,4);                                            % Get position error from next waypoint
    xdot = (1/deltaT)*deltaX;
    J = kuka.model.jacob0(qMatrix(i,:));                                   % Get Jacobian at current joint state
    xdot = [xdot;0;0;0];                                                   % no change in rpy shown by 3 zeros

    m(i) = sqrt(det(J*J'));                                                % Record manipulability

    if m(i) < minManipMeasure                                              % If manipulability is less than given threshold
        lamda = 1 - (m(i)/minManipMeasure)^2;                              % Damping coefficient
        invJ = pinv(J'*J + lamda*eye(n)) * J';                             % Apply Damped Least Squares pseudoinverse
    else
        invJ = pinv(J);                                                    % Don't use DLS
    end
    qdot(i,:) = invJ*xdot;
    qMatrix(i+1,:) = qMatrix(i,:)+(deltaT*qdot(i,:));                      % Update next joint state based on joint velocities
end

end

