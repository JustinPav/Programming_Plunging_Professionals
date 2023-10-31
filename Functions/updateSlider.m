function updateSlider(robot,sliderArray)
q = robot.model.getpos;
for i = 1:size(sliderArray,2)
    sliderArray(i).Value = rad2deg(q(i));
end
end
