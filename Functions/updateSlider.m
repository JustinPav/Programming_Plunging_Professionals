function updateSlider(robot,sliderArray)
q = robot.model.getpos;
for i = 1:size(sliderArray)
    sliderArray(i).Value = q(i);
end
end
