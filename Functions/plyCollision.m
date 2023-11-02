function result = plyCollision(robot,q,environment)
result = false;
for i = 2:size(environment,1)
    plymodel = environment{i,1};
    faceNormals = environment{i,2};
    result = checkCollision(robot,q,plymodel,faceNormals);
    if result
        return
    end
end
end
