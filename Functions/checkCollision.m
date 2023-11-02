function result = checkCollision(robot,q,plymodel,faceNormals)
faces = get(plymodel,'Faces');
vertex = get(plymodel, 'Vertices');
% Couldn't get it to read face Normals in the GUI so I stored them in a
% cell
% faceNormals = get(plymodel,'FaceNormals');
result = false;
for qIndex = 1:size(q,1)
    tr = GetLinkPoses(q(qIndex,:), robot);
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
end