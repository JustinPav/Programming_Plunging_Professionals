function qMatrix = DoBotDoGood(robot)
steps = 10;
q0 = robot.model.getpos;                                                   % Gets robot's current position with object in hand
q_1 = linspace(q0(1),deg2rad(90),steps);                                   % Rotate 90 degrees around the base to be closer to the desired end position
q_2 = linspace(q0(3),deg2rad(10),steps);                                   % Lifts object by altering joint 3 and 4
q_3 = linspace(q0(4),deg2rad(60),steps);
q_4 = pi - q_2 - q_3;                                                      % Ensures end effector is always perpendicular to the ground
% Stores lifting motion in the first qMatrix
qLift = zeros(steps,5);
qLift(:,1) = q_1;
qLift(:,2) = q_2;
qLift(:,3) = q_3;
qLift(:,4) = q_4;
qLift(:,5) = q0(5);

% Creates matrix that moves to the transfer point
transferPoint = transl(-0.35,-0.45,0.73);
q1 = qLift(steps,:);
q2 = robot.model.ikcon(transferPoint,q1);
qMatrix = jtraj(q1,q2,steps);
qMatrix = [qLift;qMatrix];
end

