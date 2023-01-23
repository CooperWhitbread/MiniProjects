%Button Class

classdef Button
    properties
        m_topLeft = [0,0];
        m_bottomRight = [0,0];
        m_color = [0,0,0];
    end
    methods
        %Constructor
        function obj = Button(topleft, bottomRight, color)
            if nargin > 0
                obj.m_topLeft = topleft;
                obj.m_bottomRight = bottomRight;
                obj.m_color = color;
            end
        end

        function r = PressingButton(obj, mouseCoordinates)
            if (mouseCoordinates(1) >= obj.m_topLeft(1) && ...
                    mouseCoordinates(2) >= obj.m_topLeft(2) && ...
                    mouseCoordinates(1) <= obj.m_bottomRight(1) && ...
                    mouseCoordinates(2) <= obj.m_bottomRight(2))
                %inside the desired position
                r = true;
            else
                r = false;
            end
        end

        function cameraRef = RenderButton(obj, cameraRef)
            %Calculate points
            y1 = obj.m_topLeft(1);
            y2 = obj.m_bottomRight(1);
            x1 = obj.m_topLeft(2);
            x2 = obj.m_bottomRight(2);
        
            %Loop through all the require pixels
            cameraRef.m_sceneImage(y1:y2, x1:x2, 1) = obj.m_color(1);
            cameraRef.m_sceneImage(y1:y2, x1:x2, 2) = obj.m_color(2);
            cameraRef.m_sceneImage(y1:y2, x1:x2, 3) = obj.m_color(3);
        end

    end%methods
end