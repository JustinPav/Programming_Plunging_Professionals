function environment = setupEnvironment(KUKA,DoBot,items)
view(45,30)
axis([-1.5, 1.5, -1, 1, 0, 2])
hold on
environment = cell(8,2);


surf([-1.8,-1.8;1.8,1.8] ...
    ,[-1.8,1.8;-1.8,1.8] ...
    ,[0,0;0,0] ...
    ,'CData',imread('bathroom.jpg') ...
    ,'FaceColor','texturemap');

% Add in toilet and move it to the back right edge of the workspace
toilet = PlaceObject('toilet.ply');
toiletVertices = get(toilet,'Vertices');
pause(0.1)
toiletNormals = get(toilet,'FaceNormals');
transformedToiletVertices = [toiletVertices,ones(size(toiletVertices,1),1)] * transl(0.6,0.5,0)';
set(toilet,'Vertices',transformedToiletVertices(:,1:3));
environment{1,1} = toilet;
environment{1,2} = toiletNormals;

% Add in a shelf and move it to the front left edge of the workspace
shelf1 = PlaceObject('shelf.ply');
shelfVertices = get(shelf1,'Vertices');
pause(0.1)
shelfNormals = get(shelf1,'FaceNormals');
transformedShelfVertices = [shelfVertices,ones(size(shelfVertices,1),1)] * transl(-0.8,-0.85,0.6)';
set(shelf1,'Vertices',transformedShelfVertices(:,1:3));
environment{2,1} = shelf1;
environment{2,2} = shelfNormals;
shelf2 = PlaceObject('shelf.ply');
shelfVertices = get(shelf2,'Vertices');
pause(0.1)
shelfNormals = get(shelf1,'FaceNormals');
transformedShelfVertices = [shelfVertices,ones(size(shelfVertices,1),1)] * transl(-0.8,-0.55,0.6)';
set(shelf2,'Vertices',transformedShelfVertices(:,1:3));
environment{3,1} = shelf2;
environment{3,2} = shelfNormals;

% Add in a bathroom wall into the workspace
wall = PlaceObject('wall.ply');
wallVertices = get(wall,'Vertices');
pause(0.1)
wallNormals = get(wall,'FaceNormals');
transformedWallVertices = [wallVertices, ones(size(wallVertices,1),1)] * trotz(pi/2)* transl(0,1,0)';
set(wall,'Vertices',transformedWallVertices(:,1:3))
environment{4,1} = wall;
environment{4,2} = wallNormals;

% Add in extinguisher and move it to the corner of the workspace
extinguisher = PlaceObject('extinguisher.ply');
extinguisherVertices = get(extinguisher,'Vertices');
pause(0.1)
extinguisherNormals = get(extinguisher,'FaceNormals');
transformedExtinguisherVertices = [extinguisherVertices,ones(size(extinguisherVertices,1),1)] * transl(-1.25,0.8,0)';
set(extinguisher,'Vertices',transformedExtinguisherVertices(:,1:3));
environment{5,1} = extinguisher;
environment{5,2} = extinguisherNormals;

% Add in warning sign and move it to the corner of the workspace
WarningSign = PlaceObject('WarningSign.ply');
WarningSignVertices = get(WarningSign,'Vertices');
pause(0.01)
WarningSignNormals = get(WarningSign,'FaceNormals');
transformedWarningSignVertices = [WarningSignVertices,ones(size(WarningSignVertices,1),1)] * trotx(-pi/2)* transl(0.6,0.97,1.4)';
set(WarningSign,'Vertices',transformedWarningSignVertices(:,1:3));
environment{6,1} = WarningSign;
environment{6,2} = WarningSignNormals;

% Add in wetsign and move it to the corner of the workspace
wetsign = PlaceObject('wetsign.ply');
wetsignVertices = get(wetsign,'Vertices');
pause(0.01)
wetsignNormals = get(wetsign,'FaceNormals');
transformedWetsignVertices = [wetsignVertices,ones(size(wetsignVertices,1),1)] * transl(1.25,-0.8,0)';
set(wetsign,'Vertices',transformedWetsignVertices(:,1:3));
environment{7,1} = wetsign;
environment{7,2} = wetsignNormals;

% Add in stopbutton and move it onto the wall of the workspace
stopbutton = PlaceObject('stopbutton.ply');
stopbuttonVertices = get(stopbutton,'Vertices');
s = 0.5;
stopbuttonVertices = stopbuttonVertices * s;
pause(0.01)
stopbuttonNormals = get(stopbutton,'FaceNormals');
transformedStopbuttonVertices = [stopbuttonVertices,ones(size(stopbuttonVertices,1),1)] * trotx(-pi/2)* transl(0.25,1,1)';
set(stopbutton,'Vertices',transformedStopbuttonVertices(:,1:3));
environment{8,1} = stopbutton;
environment{8,2} = stopbuttonNormals;

% Move robots into their correct positions
KUKA.model.base = transl(0,0.2,0);
KUKA.model.animate(KUKA.model.getpos)
DoBot.model.base = transl(-0.6,-0.6,0.6)*trotz(pi/2);
DoBot.model.animate(DoBot.model.getpos)

items.itemModel{1}.base = transl(-0.8,-1,0.8)*trotx(-pi/2);
items.itemModel{1}.delay = 0.01;
items.itemModel{1}.plot(0)
items.itemModel{2}.base = transl(-0.7,-0.75,0.55);
items.itemModel{2}.plot(0)
items.itemModel{2}.delay = 0.01;




view(45,30)
axis([-1.5, 1.5, -1, 1, 0, 2])
end
