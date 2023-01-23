%UI class for UI shown in game
%The idea is that they are attached to another game item
classdef UIGame
    properties
        m_relativePosition = [0,0];
        m_percentageFull = 1; %0 to 1
        m_colorBackground = [0,0,0];
        m_width = 10;
        m_show = true;
    end

    methods
        %Constructor
        function obj = UIGame(relativePosition, backgroundColor, width)
            if nargin > 0
                obj.m_relativePosition = relativePosition;
                obj.m_colorBackground = backgroundColor;
                obj.m_width = width;
            end
        end

        function obj = Update(obj, percentageFull)
            obj.m_percentageFull = percentageFull;
        end

        function cameraRef = Render(obj, screenPosition, cameraRef)
            if (obj.m_show)
                for i = 1:3
                    for j = 1:obj.m_width
    
                        y = i + screenPosition(1) + obj.m_relativePosition(1) - 3;
                        x = j + screenPosition(2) + obj.m_relativePosition(2) - obj.m_width / 2;
    
                        %Check it is valid position to render
                        if (y <= cameraRef.m_imageDimensions(1) && ...
                                y >= 1 && ...
                                x <= cameraRef.m_imageDimensions(2)  && ...
                                x >= 1 )
                            
                            %Percentage bar
                            if ((i == 2 ) && (j >=2 && j <= obj.m_width))
                                if (((j-1)/(obj.m_width - 2)) <= obj.m_percentageFull)
                                    %Bar full up to this point
                                    cameraRef.m_sceneImage(y, x, 1) = 255;
                                    cameraRef.m_sceneImage(y, x, 2) = 255;
                                    cameraRef.m_sceneImage(y, x, 3) = 255;
                                else
                                    %Bar empty at this point
                                    cameraRef.m_sceneImage(y, x, 1) = obj.m_colorBackground(1);
                                    cameraRef.m_sceneImage(y, x, 2) = obj.m_colorBackground(2);
                                    cameraRef.m_sceneImage(y, x, 3) = obj.m_colorBackground(3);
                                end
                            else
                                %background
                                cameraRef.m_sceneImage(y, x, 1) = obj.m_colorBackground(1);
                                cameraRef.m_sceneImage(y, x, 2) = obj.m_colorBackground(2);
                                cameraRef.m_sceneImage(y, x, 3) = obj.m_colorBackground(3);
                            end
                        end
                    end
                end
            end
        end
        
    end %methods
end