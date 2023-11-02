function qMatrix = moveDoBotToItem(robot,items,itemNo)

steps = 20;
targetLoc = items.itemModel{itemNo}.base.T;                                % Sets target location as the item's position
if itemNo == 1
    targetLoc(1,4) = targetLoc(1,4)-0.1;                                   % Altering the location of the plunger to pickup from the handle
    targetLoc(2,4) = targetLoc(2,4)+0.4;
    targetLoc(3,4) = targetLoc(3,4)-0.05;    
elseif itemNo == 2
    targetLoc(3,4) = targetLoc(3,4) + 0.2;                                 % Alters the location of pickup for the bleach bottle
end
q1 = robot.model.getpos;                                                   % Sets start joint position
q2 = robot.model.ikcon(targetLoc,q1);
qMatrix = jtraj(q1,q2,steps);                                              % Creates trajectory

end