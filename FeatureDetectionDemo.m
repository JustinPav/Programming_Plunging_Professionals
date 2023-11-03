clear all
close all
robot = KUKAiiwa7;
hold on
view(3)
toilet = PlaceObject('toilet.ply');
toiletVertices = get(toilet,'Vertices');
pause(0.1)
toiletNormals = get(toilet,'FaceNormals');
transformedToiletVertices = [toiletVertices,ones(size(toiletVertices,1),1)] * transl(0.5,0.5,0)';
set(toilet,'Vertices',transformedToiletVertices(:,1:3));
pause(0.1)
q1 = [-0.1177    1.8451    0.3532    0.4987    0.9184    1.6955         0];
q2 = [2.4923    1.4661    0.5934    0.4189    0.5934    1.6955         0];
qMatrix = jtraj(q1,q2,40);
result = checkCollision(robot,qMatrix,toilet,toiletNormals);
for i = 1:size(qMatrix,1)
    robot.model.animate(qMatrix(i,:))
    drawnow();
    pause(0.2)
end