function jointSlider(robot,value,jointNo)
q = robot.model.getpos;
value = deg2rad(value);
q(jointNo) = value;
robot.model.animate(q);
end