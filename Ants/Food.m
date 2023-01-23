%Food Class

classdef Food
    properties
        m_position = [0,0];
        m_direction = [0,0];
        m_screenPosition = [0,0]; %integer
        m_onScreen = false;
        m_dimensions = [10,25];
        m_startingLife = 0;
        m_life = 0;

        m_UIStorage;
    end

    methods
        %Constructor
        function obj = Food(position, direction, cameraRef, UIColor, startingLife)
            if nargin > 0
                obj.m_position = position;
                obj.m_direction = direction;
                obj.m_screenPosition = cameraRef.GetScreenPos(obj.m_position);
                topLeft = [obj.m_screenPosition(1) - obj.m_dimensions(2)/2, obj.m_screenPosition(2)];
                obj.m_onScreen = cameraRef.GetOnScreenTLD(topLeft, obj.m_dimensions);
                obj.m_UIStorage = UIGame([-12, 0], UIColor, 10);
                obj.m_life = startingLife;
                obj.m_startingLife = startingLife;
            end
        end

        function [obj, removeTarget, regenerateFood] = Update(obj, cameraRef, mathRef, thisIsTarget)
            obj.m_screenPosition = cameraRef.GetScreenPos(obj.m_position);
            obj.m_onScreen = (obj.m_life > 0 &&...
                cameraRef.GetOnScreenCDR(obj.m_screenPosition, obj.m_dimensions, obj.m_direction, mathRef));
            obj.m_UIStorage = obj.m_UIStorage.Update(obj.m_life/obj.m_startingLife);
            
            %remove target placed on this food if needed
            if (obj.m_life == 0 && thisIsTarget)
                removeTarget = true;
            else
                removeTarget = false;
            end

            %Rengerate food if it has run out
            regenerateFood = false;
            if (obj.m_life == 0)
                regenerateFood = true;
            end
        end

        function cameraRef = RenderFood(obj, cameraRef, mathRef)
            %If food is off screen, don't render
            if (obj.m_onScreen)
                
                cameraRef = cameraRef.RotateRender(mathRef, @obj.RotationFunction, ...
                    obj.m_screenPosition, obj.m_direction, obj.m_dimensions(2)/2, true);

                cameraRef = obj.m_UIStorage.Render(obj.m_screenPosition, cameraRef);
                
            end
        end

        function cameraRef = RotationFunction(obj, origionalPos, unrotatedPos, cameraRef, mathRef, focusPosition)

            leftCenter = [unrotatedPos(1), unrotatedPos(2) + ceil(obj.m_dimensions(2) / 2)]; 

            %calculate the angle between the pixel and reference point
            angleFinalPixel = atan(leftCenter(1)/leftCenter(2));    
            %Check the angle for 0/0 case and control angle based on the x
            %direction

            if (isnan(angleFinalPixel))
                %0/0. Angle won't matter since distance is zero but it will
                %through an error if left as NaN
                angleFinalPixel = 0;
            elseif (leftCenter(2) < 0)
                angleFinalPixel = angleFinalPixel + pi();
            end

            %Basic math for if the pixel is a part of the leaf
            %unrotated
            if (abs(angleFinalPixel) < pi()/6 || abs(angleFinalPixel) > 11 * pi()/6)
                if (mathRef.LeafFunction((unrotatedPos(1))) > (unrotatedPos(2)))
                    if (abs(unrotatedPos(1)) < 1)
                        %center
                        cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 20;
                        cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 130;
                        cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 30;
                    elseif (abs(unrotatedPos(1)) <= 5)
                        %main leaf
                        cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 20;
                        cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 100;
                        cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 30;
                    end
                end
            end
            
            if (leftCenter(2) < 4 && abs(leftCenter(1)) < 1 && leftCenter(2) > -2)
                %Stalk extended
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 120;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 80;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 40;
            end
        end

        function r = IsColliding(obj, position, mathRef)
            if (mathRef.Magnitude(obj.m_position - position) <= 13)
                %The object is within the bounds of the hole
                r = true;
            else 
                r = false;
            end
        end

    end %methods
end