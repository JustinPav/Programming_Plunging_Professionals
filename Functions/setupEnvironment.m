function items = setupEnvironment(KUKA,DoBot)
view(45,30)
axis([-1.5, 1.5, -1, 1, 0, 2])
hold on

surf([-1.8,-1.8;1.8,1.8] ...
    ,[-1.8,1.8;-1.8,1.8] ...
    ,[0,0;0,0] ...
    ,'CData',imread('bathroom.jpg') ...
    ,'FaceColor','texturemap');

% Add in toilet and move it to the back right edge of the workspace
toilet = PlaceObject('toilet.ply');
toiletVertices = get(toilet,'Vertices');
transformedToiletVertices = [toiletVertices,ones(size(toiletVertices,1),1)] * transl(0.6,0.5,0)';
set(toilet,'Vertices',transformedToiletVertices(:,1:3));

% Add in a shelf and move it to the front left edge of the workspace
shelf = PlaceObject('shelf.ply');
shelfVertices = get(shelf,'Vertices');
transformedShelfVertices = [shelfVertices,ones(size(shelfVertices,1),1)] * transl(-0.8,-0.85,0.6)';
set(shelf,'Vertices',transformedShelfVertices(:,1:3));
shelf = PlaceObject('shelf.ply');
shelfVertices = get(shelf,'Vertices');
transformedShelfVertices = [shelfVertices,ones(size(shelfVertices,1),1)] * transl(-0.8,-0.55,0.6)';
set(shelf,'Vertices',transformedShelfVertices(:,1:3));

% Add in a bathroom wall into the workspace
wall = PlaceObject('wall.ply');
wallVertices = get(wall,'Vertices');
transformedWallVertices = [wallVertices, ones(size(wallVertices,1),1)] * trotz(pi/2)* transl(0,1,0)';
set(wall,'Vertices',transformedWallVertices(:,1:3))

% Move robots into their correct positions
KUKA.model.base = transl(0,0.2,0);
KUKA.model.animate(KUKA.model.getpos)
DoBot.model.base = transl(-0.8,-0.6,0.6)*trotz(pi/2);
DoBot.model.animate(DoBot.model.getpos)

items = RobotItem(2);
items.itemModel{1}.base = transl(-1.25,-0.6,0.55);
items.itemModel{1}.delay = 0.01;
items.itemModel{1}.plot(0)
items.itemModel{2}.base = transl(-1.25,-0.75,0.55);
items.itemModel{2}.plot(0)
items.itemModel{2}.delay = 0.01;

view(45,30)
axis([-1.5, 1.5, -1, 1, 0, 2])
end
