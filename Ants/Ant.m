%Ant Class

classdef Ant
    properties
        %General Properties
        m_position = [0,0];
        m_targetPosition = [0,0];
        m_direction = [0,0];
        m_speed = 0;
        m_screenPosition = [0,0]; %integer
        m_onScreen = false;
        m_food = 0;

        %AI Properties
        m_isInNest = false;
        m_timer = 0;
        m_nestMaxTime = 3;
        m_nestReappear = 1;
        m_foodCollected = false;
        m_canMove = true;
        m_movementStage = 2; %to food = 0, to nest = 1, idle = 2
    end

    methods
        %Constructor
        function obj = Ant(position, direction, speed, cameraRef)
            if nargin > 0
                obj.m_position = position;
                obj.m_targetPosition = position;
                obj.m_direction = direction;
                obj.m_speed = speed;
                obj.m_screenPosition = cameraRef.GetScreenPos(obj.m_position);
                obj.m_onScreen = cameraRef.GetOnScreen(obj.m_position);

            end
        end

        function obj = UpdateTargetPosition(obj, targetPosition)
            obj.m_targetPosition = targetPosition;
            if (obj.m_targetPosition(1)-obj.m_position(1) ~= 0 || ...
                    obj.m_targetPosition(2)-obj.m_position(2) ~= 0)
                obj.m_direction = obj.m_targetPosition-obj.m_position;
            end
        end

        %AI Functions
        function [obj, foodRef, nestRef] = UpdateAntAI(obj, cameraRef, mathRef, nestRef, foodRef, isFood)

            %%%Check targetPosition is still valid%%%
            switch (obj.m_movementStage)
                case 0 %going to get food
                    if (~isFood)
                        %cant go to nest so go to idle
                        obj.m_movementStage = 2;
    
                    elseif (foodRef.IsColliding(obj.m_position, mathRef))
                        %pause to get food
                        if (~obj.m_foodCollected)
                            %Fist time
                            obj.m_foodCollected = true;
                            obj.m_timer = 1.5;
                            obj.m_canMove = false;
                            obj.m_food = 1;
                            foodRef.m_life = foodRef.m_life - 1;
                            obj = obj.UpdateTargetPosition(obj.m_position);
                        end
        
                        obj.m_timer = obj.m_timer - cameraRef.m_deltaTime;
        
                        if (obj.m_timer <=0)
                            %finish up the pause
                            obj.m_canMove = true;
                            obj = obj.UpdateTargetPosition(nestRef.m_position);
                            obj.m_movementStage = 1;
                        end

                    else %set the target position to the food, incase the target food has changed
                        obj = obj.UpdateTargetPosition(foodRef.m_position + 30 * rand(1, 2) - 15);
                    end
                case 1 %going to nest
                    
                    wasInNest = obj.m_isInNest;
                    obj.m_isInNest = nestRef.IsColliding(obj.m_position, mathRef);
                    if (~wasInNest && obj.m_isInNest)
                        %First time reaching the nest
                        obj.m_timer = obj.m_nestMaxTime;
                        obj.m_position = nestRef.m_position;
        
                        obj.m_targetPosition = obj.m_position;
                        obj.m_direction = [-1,0];
        
                        nestRef.m_food = nestRef.m_food + obj.m_food;
                        obj.m_food = 0;
                        obj.m_foodCollected = false;
                    end
                
                    %Update the nest timer
                    if (obj.m_timer > 0)
                        obj.m_timer = obj.m_timer - cameraRef.m_deltaTime;
                        if (obj.m_timer <= obj.m_nestReappear)

                            %finished at the nest
                            obj.m_movementStage = 0;
                            obj.m_timer = -50; %ensure time to get out of nest
                        
                        end
                    end
                case 2 %idle
                    
                    initialMode = false;
                    %Check colliding with nest
                    if (obj.m_timer < 0 && mod(obj.m_timer, 1) == 0)
                        obj.m_timer = obj.m_timer + 1;
                        initialMode = true;
                        obj = obj.UpdateTargetPosition(nestRef.m_position + [20,0]);
                    elseif (nestRef.IsColliding(obj.m_position, mathRef))
                        obj.m_movementStage = 1;
                        obj = obj.UpdateTargetPosition(nestRef.m_position);
                    end

                    %check if food is now avaliable
                    if (isFood)
                        obj.m_movementStage = 0;
                        obj.m_timer = 0;
                    
                    %Go back to nexst if got food
                    elseif (obj.m_foodCollected)

                        obj.m_movementStage = 1;
                        obj.m_timer = 0;
                        obj = obj.UpdateTargetPosition(nestRef.m_position);
                    
                    %check not in initial mode
                    elseif (~initialMode)
                        %check if timer has run out
                        if (obj.m_timer < 0)
                            %chance the position
                            rng("shuffle");
                            tempDir = 2*rand([1,2])-1;
                            while (tempDir == [0,0])
                                %make sure it is a valid direction
                                tempDir = 2*rand([1,2])-1;
                            end
    
                            obj = obj.UpdateTargetPosition(nestRef.m_position + ...
                                mathRef.Normalize(tempDir) * (40*rand(1) + 15));
    
                            obj.m_timer = 5;
                        else 
                            obj.m_timer = obj.m_timer  - cameraRef.m_deltaTime;
                        end
                    end
                    

                otherwise 
                    disp("Not valid ant ai move state");
            end

            %%%Update Position%%%
            %Only move the ant if not in the nest and is set to move
            if ((obj.m_movementStage ~= 1 || (obj.m_timer < obj.m_nestReappear && obj.m_timer >= 0)) ...
                    || obj.m_canMove)
                %update the position
                if (mathRef.Magnitude(obj.m_targetPosition - obj.m_position) <= cameraRef.m_deltaTime * obj.m_speed || ...
                        mathRef.Magnitude(obj.m_targetPosition - obj.m_position)^2 <= 2)
                    %moving normally will overshoot the position so just set the player
                    %to the position;
                    obj.m_position = obj.m_targetPosition;
                else
                    obj.m_position = obj.m_position + mathRef.Normalize(obj.m_targetPosition - obj.m_position) ...
                    * cameraRef.m_deltaTime * obj.m_speed;
                end
            end

            obj.m_screenPosition = cameraRef.GetScreenPos(obj.m_position);

            %Display if on screen and not in the nest
            if (obj.m_movementStage == 1)
                obj.m_onScreen = (cameraRef.GetOnScreenCDR(obj.m_screenPosition, ...
                [2, 6], obj.m_direction, mathRef) && ...
                (obj.m_timer <= obj.m_nestReappear));
            else
                obj.m_onScreen = (cameraRef.GetOnScreenCDR(obj.m_screenPosition, ...
                [2, 6], obj.m_direction, mathRef));
            end
        end

        %Player Function
        function [obj, actionUIRef, targetUIRef] = UpdateGameLogicPlayer(obj, cameraRef, ...
                mathRef, foodRef, actionUIRef, targetUIRef, targetIndex)
            
            moveSpeed = obj.m_speed;

            %Only move the ant if not in the nest
            if (obj.m_timer < obj.m_nestReappear)
                if (obj.m_timer > 0)
                    %adjust speed when exiting nest
                    moveSpeed = moveSpeed / 2;
                end

                %update the position
                if (mathRef.Magnitude(obj.m_targetPosition - obj.m_position) <= cameraRef.m_deltaTime * obj.m_speed || ...
                        mathRef.Magnitude(obj.m_targetPosition - obj.m_position)^2 <= 2)
                    %moving normally will overshoot the position so just set the player
                    %to the position;
                    obj.m_position = obj.m_targetPosition;
                else
                    obj.m_position = obj.m_position + mathRef.Normalize(obj.m_targetPosition - obj.m_position) ...
                    * cameraRef.m_deltaTime * moveSpeed;
                end
            end
            
            %Check colliding with any food
            actionUIRef.m_show = false;
            targetUIRef.m_show = false;
            for i = 1:length(foodRef)
                if (foodRef(i).IsColliding(obj.m_position, mathRef))
                    actionUIRef.m_show = true;
                    targetUIRef.m_show = true;

                    if (i == targetIndex)
                        targetUIRef.m_textColor = [200, 20, 20];
                    else
                        targetUIRef.m_textColor = [255, 255, 255];
                    end

                    break;
                end
            end
        end

        function [obj, nestRef, playerItemUI] = UpdateCameraLogicPlayer(obj, cameraRef, mathRef, nestRef, playerItemUI)
            obj.m_screenPosition = cameraRef.GetScreenPos(obj.m_position);

            %check if first time colliding with nest
            wasInNest = obj.m_isInNest;
            obj.m_isInNest = nestRef.IsColliding(obj.m_position, mathRef);
            if (~wasInNest && obj.m_isInNest)
                %Set up the process for ant in the nest
                obj.m_timer = obj.m_nestMaxTime;
                obj.m_position = nestRef.m_position;
                obj.m_targetPosition = [nestRef.m_position(1)-15, nestRef.m_position(2)];
                obj.m_direction = obj.m_targetPosition - obj.m_position;

                %food updating
                nestRef.m_food = nestRef.m_food + obj.m_food;
                obj.m_food = 0;
                playerItemUI.m_display = '';
            end
            
            %Update the nest timer
            if (obj.m_timer > 0)
                obj.m_timer = obj.m_timer - cameraRef.m_deltaTime;
            end

            %Display if on screen and not in the nest
            obj.m_onScreen = (cameraRef.GetOnScreenCDR(obj.m_screenPosition, ...
                [2, 6], obj.m_direction, mathRef) && obj.m_timer <= obj.m_nestReappear);
        end

        function cameraRef = RenderAnt(obj, cameraRef, mathRef)
            %If ant is off screen, don't render
            if (obj.m_onScreen)
                cameraRef = cameraRef.RotateRender(mathRef, @obj.RotationFunction, ...
                    obj.m_screenPosition, obj.m_direction, 3, true);

            end
    
        end

        function cameraRef = RotationFunction(obj, origionalPos, unrotatedPos, cameraRef, mathRef, focusPosition)
            %Check if is head is between (-2,0) to (-1,1) 
            if (unrotatedPos(2) >= 1 && unrotatedPos(2) <= 2 && unrotatedPos(1) <= 0 && unrotatedPos(1) >= -1)
                %head
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 100;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 100;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 100;
            %check if the body is between (0,0) to (2,1)
            elseif (unrotatedPos(2) >= -2  && unrotatedPos(2) <= 0 && unrotatedPos(1) <= 0 && unrotatedPos(1) >= -1)
                %body
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 1) = 0;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 2) = 0;
                cameraRef.m_sceneImage(origionalPos(1) + focusPosition(1), origionalPos(2) + focusPosition(2), 3) = 0;
            end
        end
    end %method
end