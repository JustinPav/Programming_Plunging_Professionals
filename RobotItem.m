classdef RobotItem < handle
    % Adaptation of RobotItems to create items in the workspace   

    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 2;
    end
    
    properties
        % Number of items
        itemCount = 2;
        
        % A cell structure of \c itemCount item models
        itemModel;
        
        % paddockSize in meters
        paddockSize = [1.8,1.8];        
        
        % Dimensions of the workspace in regard to the padoc size
        workspaceDimensions;
    end
    
    methods
        %% ...structors
        function self = RobotItem(itemCount)
            if 0 < nargin
                self.itemCount = itemCount;
            end
            
            self.workspaceDimensions = [-self.paddockSize(1)/2, self.paddockSize(1)/2 ...
                                       ,-self.paddockSize(2)/2, self.paddockSize(2)/2 ...
                                       ,-0.1,self.maxHeight];

            % Create the required number of items
            for i = 1:self.itemCount
                if i == 1
                    self.itemModel{i} = self.GetItemModel('plunger');
                elseif i == 2
                    self.itemModel{i} = self.GetItemModel('bleach');
                else
                    self.itemModel{i} = self.GetItemModel('bleach');
                end

                % Random spawn
                basePose = SE3(SE2((2 * rand()-1) * self.paddockSize(1)/2 ...
                                         , (2 * rand()-1) * self.paddockSize(2)/2 ...
                                         , (2 * rand()-1) * 2 * pi));
                self.itemModel{i}.base = basePose;
                
                 % Plot 3D model
                plot3d(self.itemModel{i},0,'workspace',self.workspaceDimensions,'view',[-30,30],'delay',0,'noarrow','nowrist');
                % Hold on after the first plot (if already on there's no difference)
                if i == 1 
                    hold on;
                end
            end

            axis equal
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end 
        end
        
        function delete(self)
            for index = 1:self.itemCount
                handles = findobj('Tag', self.itemModel{index}.name);
                h = get(handles,'UserData');
                try delete(h.robot); end
                try delete(h.wrist); end
                try delete(h.link); end
                try delete(h); end
                try delete(handles); end
            end
        end
    end

    
    methods (Static)
        %% GetItemModel
        function model = GetItemModel(name)
            if nargin < 1
                name = 'Item';
            end
            [faceData,vertexData] = plyread([name '.ply'],'tri');
            link1 = Link('alpha',0,'a',-0.03,'d',0.07,'offset',0);
            model = SerialLink(link1,'name',name);
            
            % Changing order of cell array from {faceData, []} to 
            % {[], faceData} so that data is attributed to Link 1
            % in plot3d rather than Link 0 (base).
            model.faces = {[], faceData};

            % Changing order of cell array from {vertexData, []} to 
            % {[], vertexData} so that data is attributed to Link 1
            % in plot3d rather than Link 0 (base).
            model.points = {[], vertexData};
        end
    end    
end