function result = checkCollision(robot,q,plymodel)
faces = get(plymodel,'Faces');
vertex = get(plymodel, 'Vertices');
faceNormals = get(plymodel,'FaceNormals');
result = false;

tr = GetLinkPoses(q, robot);
for i = 1 : size(tr,3)-1
    for faceIndex = 1:size(faces,1)
        vertOnPlane = vertex(faces(faceIndex,1)',:);
        [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)');
        if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
            disp('Intersection');
            result = true;
            return
        end
    end
end
end