%Ant Nest

classdef Nest
    properties
        m_position = [0,0];
        m_screenPosition = [0,0]; %integer
        m_onScreen = false;
        m_dimensions = [30, 30];
        m_food = 10;
        m_foodForNextAnt = 5;
        m_lastQueenEatTime = 0;
    end

    methods
        %Constructor
        function obj = Nest(position, cameraRef, mathRef)
            if nargin > 0
                obj.m_position = position;
                obj.m_screenPosition = cameraRef.GetScreenPos(position);
                obj.m_onScreen = cameraRef.GetOnScreenCDR(obj.m_screenPosition, ...
                    obj.m_dimensions, [0,1], mathRef);
            end
        end

        function [obj, died] = Update(obj, cameraRef, mathRef)
            obj.m_screenPosition = cameraRef.GetScreenPos(obj.m_position);
            obj.m_onScreen = cameraRef.GetOnScreenCDR(obj.m_screenPosition, ...
                obj.m_dimensions, [0,1], mathRef);

            died = false;
            %Remove food if time is up
            if (cameraRef.m_gameTime - obj.m_lastQueenEatTime > 60)
                obj.m_lastQueenEatTime = obj.m_lastQueenEatTime + 60;
                obj.m_food = obj.m_food - ceil(cameraRef.m_gameTime / 30);
                
                %die if the food is less than 0
                if (obj.m_food < 0)
                    died = true;
                    %Pause to show Death
                    pause(2);
                end
            end
        end

        function cameraRef = Render(obj, cameraRef, mathRef)
            %loop through all possible pixels
            for i = -obj.m_dimensions(1)/2 : obj.m_dimensions(1)/2
                for j = -obj.m_dimensions(2)/2 : obj.m_dimensions(2)/2
                    %make sure the pixel is renderable
                    if (i + obj.m_screenPosition(1) > 0 && i + obj.m_screenPosition(1) < cameraRef.m_imageDimensions(1) && ...
                                j + obj.m_screenPosition(2) > 0 && j + obj.m_screenPosition(2) < cameraRef.m_imageDimensions(2))
                        dist = mathRef.DistanceXY(i, j);
                        %make the hole a circle
                        if (dist <= 15)
                            [r,g,b] = mathRef.NestFunction(dist);
                            cameraRef.m_sceneImage(obj.m_screenPosition(1) + i, obj.m_screenPosition(2) + j, 1) = r;
                            cameraRef.m_sceneImage(obj.m_screenPosition(1) + i, obj.m_screenPosition(2) + j, 2) = g;
                            cameraRef.m_sceneImage(obj.m_screenPosition(1) + i, obj.m_screenPosition(2) + j, 3) = b;
                    
                        end
                    end
                end
            end
        end

        function r = IsColliding(obj, position, mathRef)
            if (mathRef.Magnitude(obj.m_position - position) <= 7)
                %The object is within the bounds of the hole
                r = true;
            else 
                r = false;
            end
        end

    end% methods
end