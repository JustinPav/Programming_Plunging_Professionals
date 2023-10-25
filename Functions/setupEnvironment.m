function setupEnvironment(KUKA,DoBot)
view(3)
axis([-1.5, 1.5, -1, 1, 0, 2])
hold on

% Add in toilet and move it to the back right edge of the workspace
toilet = PlaceObject('toilet.ply');
toiletVertices = get(toilet,'Vertices');
transformedToiletVertices = [toiletVertices,ones(size(toiletVertices,1),1)] * transl(1.1,0.5,0)';
set(toilet,'Vertices',transformedToiletVertices(:,1:3));

% Add in a shelf and move it to the front left edge of the workspace
shelf = PlaceObject('shelf.ply');
shelfVertices = get(shelf,'Vertices');
transformedShelfVertices = [shelfVertices,ones(size(shelfVertices,1),1)] * transl(-0.8,-0.85,1)';
set(shelf,'Vertices',transformedShelfVertices(:,1:3));
shelf = PlaceObject('shelf.ply');
shelfVertices = get(shelf,'Vertices');
transformedShelfVertices = [shelfVertices,ones(size(shelfVertices,1),1)] * transl(-0.8,-0.55,1)';
set(shelf,'Vertices',transformedShelfVertices(:,1:3));

KUKA.model.base = transl(0,0.2,0);
KUKA.model.animate(KUKA.model.getpos)
DoBot.model.base = transl(-0.8,-0.6,1);
DoBot.model.animate(DoBot.model.getpos)
end
