% Test Script

rosshutdown
rosinit;

%% Uses end effector pose

% posArray lets you send an array of locations for the DoBot to move
% through
posArray = [0.2,-0.1,0.05;
            0.2,-0.1,0.1;
            0.2,-0.05,0.05;
            0.2,-0.05,0.1;
            0.2,0,0.05;
            0.2,0,0.1];

s = size(posArray);
for i = 1:s(1)
    endEffectorPoseSubscriber = rossubscriber('/dobot_magician/end_effector_poses'); % Create a ROS Subscriber to the topic end_effector_poses
    pause(1); %Allow some time for MATLAB to start the subscriber
    currentEndEffectorPoseMsg = endEffectorPoseSubscriber.LatestMessage;
    % Extract the position of the end effector from the received message
    currentEndEffectorPosition = [currentEndEffectorPoseMsg.Pose.Position.X,
        currentEndEffectorPoseMsg.Pose.Position.Y,
        currentEndEffectorPoseMsg.Pose.Position.Z];
    % Extract the orientation of the end effector
    currentEndEffectorQuat = [currentEndEffectorPoseMsg.Pose.Orientation.W,
        currentEndEffectorPoseMsg.Pose.Orientation.X,
        currentEndEffectorPoseMsg.Pose.Orientation.Y,
        currentEndEffectorPoseMsg.Pose.Orientation.Z];
    % Convert from quaternion to euler
    eul = quat2eul(currentEndEffectorQuat');
    roll = eul(1);
    pitch = eul(2);
    yaw = eul(3);

    endEffectorPosition = posArray(i,:);
    endEffectorRotation = [0,0,0];

    [targetEndEffectorPub,targetEndEffectorMsg] = rospublisher('/dobot_magician/target_end_effector_pose');

    targetEndEffectorMsg.Position.X = endEffectorPosition(1);
    targetEndEffectorMsg.Position.Y = endEffectorPosition(2);
    targetEndEffectorMsg.Position.Z = endEffectorPosition(3);

    qua = eul2quat(endEffectorRotation);
    targetEndEffectorMsg.Orientation.W = qua(1);
    targetEndEffectorMsg.Orientation.X = qua(2);
    targetEndEffectorMsg.Orientation.Y = qua(3);
    targetEndEffectorMsg.Orientation.Z = qua(4);

    send(targetEndEffectorPub,targetEndEffectorMsg);
    input('Press enter to continue')
end
