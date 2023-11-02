function qMatrix = KUKAplungeToilet(kuka,q)
n = kuka.model.n;
t = 5;                                                                     % Total time in seconds
stepsPerPlunge = 30;                                                       % Number of steps per plunging action
numberOfPlunges = 4;                                                       % Number of plunges per run through
steps = stepsPerPlunge*numberOfPlunges;                                    % No. of steps
deltaT = t/steps;                                                          % Discrete time step
qMatrix = zeros(steps,n);                                                  % Assign memory for joint angles
m = zeros(1,steps);                                                        % For recording measure of manipulability
minManipMeasure = 0.3;                                                     % Required for the dampled least square

% Create a velocity array that has a high velocity in negative z so that
% the plunger is pushed down and then a high velocity up with a pause at
% the top
xdotMatrix = zeros(6,steps); 
velocity = 1;                                                              % velocity at which the plunger is moved
for i = 1:numberOfPlunges
    count = 1;
    for m = stepsPerPlunge*(i-1)+1:stepsPerPlunge*i
        if count <= 12
            xdotMatrix(3,m) = -velocity;
        elseif count > 12 && count <= 24
            xdotMatrix(3,m) = velocity;
        else
            xdotMatrix(3,m) = 0;
        end
        count = count + 1;  
    end
end

qMatrix(1,:) = q;                                                          % Set the intial q value

for i = 1:steps-1
    % T = kuka.model.fkine(qMatrix(i,:)).T;                                  % Get forward transformation at current joint state
    % deltaX = xdot(:,i+1)-T(1:3,4);                                            % Get position error from next waypoint
    xdot = xdotMatrix(:,i);
    J = kuka.model.jacob0(qMatrix(i,:));                                   % Get Jacobian at current joint state
    % xdot = [xdot;0;0;0];                                                   % no change in rpy shown by 3 zeros

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