classdef KUKAiiwa7 < RobotBaseClass
    %% KUKA iiwa7 robot arm constructed from datasheet

    properties (Access = public)
        plyFileNameStem = 'KUKAiiwa7';
    end

    methods
        % Creates the robot model and plots it in a figure
        function self = KUKAiiwa7(baseTr)
            self.CreateModel();
            if nargin < 1
                baseTr = eye(4);
            end
            self.model.base = self.model.base.T * baseTr;

            self.PlotAndColourRobot();
        end

        function CreateModel(self)

            % Derived DH Parameters
            link(1) = Link('d',0.34,'a',0,'alpha',-pi/2,'qlim',deg2rad([-170 170]));
            link(2) = Link('d',0,'a',0,'alpha',pi/2,'qlim',deg2rad([-120 120]));
            link(3) = Link('d',0.4,'a',0,'alpha',pi/2,'qlim',deg2rad([-170 170]));
            link(4) = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-120 120]));
            link(5) = Link('d',0.4,'a',0,'alpha',-pi/2,'qlim',deg2rad([-170 170]));
            link(6) = Link('d',0,'a',0,'alpha',pi/2,'qlim',deg2rad([-120 120]));
            link(7) = Link('d',0.126,'a',0,'alpha',0,'qlim',deg2rad([-175 175]));

            % KUKAiiwa7 :: 7 axis, RRRRRRR, stdDH, slowRNE
            % +---+-----------+-----------+-----------+-----------+-----------+
            % | j |     theta |         d |         a |     alpha |    offset |
            % +---+-----------+-----------+-----------+-----------+-----------+
            % |  1|         q1|       0.34|          0|    -1.5708|          0|
            % |  2|         q2|          0|          0|     1.5708|          0|
            % |  3|         q3|        0.4|          0|     1.5708|          0|
            % |  4|         q4|          0|          0|    -1.5708|          0|
            % |  5|         q5|        0.4|          0|    -1.5708|          0|
            % |  6|         q6|          0|          0|     1.5708|          0|
            % |  7|         q7|      0.126|          0|     1.5708|          0|
            % +---+-----------+-----------+-----------+-----------+-----------+
            
            self.model = SerialLink(link,'name',self.name);
        end
    end
end
