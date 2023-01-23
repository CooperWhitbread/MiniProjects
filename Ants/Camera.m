%Camera Class

classdef Camera
    properties
        %screen image variables
        m_imageDimensions = [0,0];
        m_imageMidpoint = [0,0];
        m_sceneImage = [];

        %camera variables
        m_cameraPosition = [0,0];

        %timerVariables
        m_deltaTime = 0;
        m_gameTime = 0;
        m_desiredFrameRate = 60; %FPS

        %Target display Info
        m_targetDisplay;
        m_targetLable;
        
    end

    methods
        %%%Constructor%%%
        function obj = Camera(imageDimensions, cameraPosition, UIColor)
            if nargin > 0
                obj.m_imageDimensions = imageDimensions;
                obj.m_cameraPosition = cameraPosition;
                obj.m_sceneImage = 255 * ones(obj.m_imageDimensions(1), obj.m_imageDimensions(2), 3, 'uint8');
                obj.m_imageMidpoint = obj.m_imageDimensions / 2 + 1;
                
                %Target Display
                obj.m_targetLable = UIFixed([2, 41], [6,82], UIColor, '');
                obj.m_targetDisplay = UIGame([-obj.m_imageDimensions(1) / 2 + 5, 11], ...
                    UIColor, 40);
            end
        end
        
        %%%Update Functions%%%
        function obj = UpdateGameTime(obj, deltaTime)
            obj.m_deltaTime = deltaTime;
            obj.m_gameTime = obj.m_gameTime + obj.m_deltaTime;
        end

        function obj = Update(obj, focusPoint, gameMapRef, mathRef, foodRef, targetIndex)
            obj.m_cameraPosition = mathRef.LimitValue(focusPoint, obj.m_imageMidpoint,...
                gameMapRef.m_mapDimensions - obj.m_imageMidpoint);

            %update the target lable
            if (targetIndex == 0)
                obj.m_targetDisplay.m_percentageFull = 0;
            else
                obj.m_targetDisplay.m_percentageFull = ...
                    foodRef(targetIndex).m_life / foodRef(targetIndex).m_startingLife;
            end
        end

        %%%Getter Functions For Game Information%%%
        function r = GetScreenPos(obj, position)
            r = round(position - obj.m_cameraPosition + obj.m_imageMidpoint);
        end

        function r = GetOnScreen(obj, position)
            r = (position(1) >= 1 && position(2) >= 1 && ...
                position(1) <= obj.m_imageDimensions(1) && ...
                position (2) <= obj.m_imageDimensions(2));
        end
        
        function r = GetOnScreenTLD(obj, topLeft, dimensions)
            %alternate GetOnScreen Function
            r = (obj.GetOnScreen(topLeft) || obj.GetOnScreen(topLeft+dimensions));
        end

        function r = GetOnScreenCDR(obj, center, dimensions, direction, mathRef)
            %Alternate GetOnScreen Function

            %Get the base rotation
            baseAngle = mathRef.CalculateAngle(direction);
            %convert the sign to be a multiple of 45 degrees
            baseAngle = pi()/4 * round(baseAngle / (pi() / 4));

            %Calculate the unrotated angle for each corner
            topLeftAngleU =     mathRef.CalculateAngle(-dimensions);
            topRigthtAngleU =   mathRef.CalculateAngle([-dimensions(1), dimensions(2)]);
            bottomRightAngleU = mathRef.CalculateAngle(dimensions);
            bottomLeftAngleU =  mathRef.CalculateAngle([dimensions(1), -dimensions(2)]);

            %Calculate the distance between each corner and the center of
            %the rectangle
            hypotenuse = sqrt((dimensions(1)/2)^2 + (dimensions(2)/2)^2);
            
            %Calculate the rotated position of the corners 
            corners = [
                hypotenuse*sin(topLeftAngleU+baseAngle)     hypotenuse*cos(topLeftAngleU+baseAngle);
                hypotenuse*sin(topRigthtAngleU+baseAngle)   hypotenuse*cos(topRigthtAngleU+baseAngle);
                hypotenuse*sin(bottomRightAngleU+baseAngle) hypotenuse*cos(bottomRightAngleU+baseAngle);
                hypotenuse*sin(bottomLeftAngleU+baseAngle)  hypotenuse*cos(bottomLeftAngleU+baseAngle)];
            
            %Select the maximum and minimum points for the rectangle
            xMax = 0; 
            xMin = 1000;
            yMax = 0; 
            yMin = 1000;
            for i = 1:size(corners, 1)
                if (xMax < corners(i, 2))
                    xMax = corners(i, 2);
                end
                if (yMax < corners(i, 1))
                    yMax = corners(i, 1);
                end
                if (xMin > corners(i, 2))
                    xMin = corners(i, 2);
                end
                if (yMin > corners(i, 1))
                    yMin = corners(i, 1);
                end
            end

            if (obj.GetOnScreen([yMax, xMax] + center) || ...
                    obj.GetOnScreen([yMin, xMin] + center))
                r = true;
            else
                r = false;
            end
        end

        %%%Render Support Functions%%%
        function obj = RotateRender(obj, mathRef, pixelFunction, focusPosition, direction, maxSize, lockAngle)
            
            %fix max size to be an integer
            maxSize = ceil(maxSize);

            %get angle facing
            rotationAngle = mathRef.CalculateAngle(direction);
            %convert the sign to be a multiple of 45 degrees
            if (lockAngle)
                rotationAngle = pi()/4 * round(rotationAngle / (pi() / 4));
            else
                rotationAngle = pi()/8 * round(rotationAngle / (pi() / 8));
            end

            %loop through all potential pizels that the ant could be rendered on
            for y = -maxSize:maxSize
                for x = -maxSize:maxSize
                        
                    %check the pixel is on the screen
                    if (y + focusPosition(1) > 1 && x + focusPosition(2) > 1 && ...
                            y + focusPosition(1) < obj.m_imageDimensions(1) && ...
                            x + focusPosition(2) < obj.m_imageDimensions(2))

                        %calculate the angle between the pixel and reference point
                        angleBase = atan(y/(x));
            
                        %Check the angle for 0/0 case and control angle based on the x
                        %direction
                        if (isnan(angleBase))
                            %0/0. Angle won't matter since distance is zero but it will
                            %through an error if left as NaN
                            angleBase = 0;
                        elseif (x<0)
                            angleBase = angleBase + pi();
                        end
            
                        %Calculate the angle of the pixel relative to an unrotated
                        %image of the ant
                        unrotatedAngle = angleBase - rotationAngle;
            
                        %Calculate the distance between the pixel and the reference
                        %point
                        distance = mathRef.DistanceXY(x, y);
                        
                        %Calculte the unrotated position of the pixel (as an integer)
                        yPos = round(distance *  sin(unrotatedAngle));
                        xPos = round(distance *  cos(unrotatedAngle));
    
                        originalPos = [y, x];
                        unrotatedPos = [yPos, xPos];
                        
                        obj = feval(pixelFunction, originalPos, unrotatedPos, obj, mathRef, focusPosition);
                    end
                end
            end
        end

        %%%General Render Functions%%%
        function obj = RenderUI(obj, nestRef, mathRef)
            %Render the UI for the player ant
            obj = obj.m_targetLable.Render(obj);
            obj = obj.m_targetDisplay.Render(obj.m_imageDimensions / 2, ...
                obj);

            obj = obj.RotateRender(mathRef, @obj.RotationFunction, [15,10], ...
                nestRef.m_position - obj.m_cameraPosition, 10, false);
        end

        function obj = RenderDot(obj, position, size, color)
            %Caclulate the diemtions so that it is centered at the desired position
            %with the right width 
            extrema = floor(size/2);
            offset = mod(size+1, 2);
        
            %convert the position to an integer
            position = floor(position);
        
            %Calculate points
            y1 = position(1) - extrema;
            y2 = position(1) + extrema + offset;
            x1 = position(2) - extrema;
            x2 = position(2) + extrema + offset;
        
            %Loop through all the require pixels
            obj.m_sceneImage(y1:y2, x1:x2, 1) = color(1);
            obj.m_sceneImage(y1:y2, x1:x2, 2) = color(2);
            obj.m_sceneImage(y1:y2, x1:x2, 3) = color(3); 
        end
        
        function obj = RenderTarget(obj, position, color)
            %convert the position to an integer
            position = floor(position);
        
            %loop through all the points and set the color
            for y = -2:2
                for x = -2:2
                    %check it is a renndable position
                    if (y + position(1) < obj.m_imageDimensions(1) && ...
                            y + position(1) > 1 && ...
                            x + position(2) < obj.m_imageDimensions(2) && ...
                            x + position(2) > 1)
                        %only want the points to form a cross with the middle missing
                        if ((y==0 || x==0) && y~=x) 
                            obj.m_sceneImage(position(1)+y, position(2)+x, 1) = color(1);
                            obj.m_sceneImage(position(1)+y, position(2)+x, 2) = color(2);
                            obj.m_sceneImage(position(1)+y, position(2)+x, 3) = color(3);  
                        end
                    end
                end
            end
        end

        %%%Call back functions%%%
        function cameraRef = RotationFunction(obj, origionalPos, unrotatedPos, cameraRef, mathRef, focusPosition)

            leftCenter = [unrotatedPos(1), 5-unrotatedPos(2)]; 

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

            %arrow head
            if ((abs(angleFinalPixel) < 1 * pi()/4 || abs(angleFinalPixel) > 7 * pi()/4) && unrotatedPos(2) > -2 && unrotatedPos(2) <5)
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 240;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 200;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 20;
            end
            
            %arrow body
            if (unrotatedPos(1) <= 2 && unrotatedPos(1) >= -2 && ...
                    unrotatedPos(2) <= 0 && unrotatedPos(2) >= -5)
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 240;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 200;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 20;
            end

        end

    end%methods
end