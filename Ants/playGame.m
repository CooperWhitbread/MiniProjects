function playGame(camera, math, UIColor, IMAGE, FIGURE_HANDLE)
    %Used to communicate between the user and the code through 
    %mouse clicking only
    global mouseDownPositionGlobal;
    mouseDownPositionGlobal = [0,0];

    %Game Map
    gameMap = GameMap([1000,1000]);
    gameMap = gameMap.Initialise(math);

    %Nest
    nest = Nest(gameMap.GenerateRandomPositionOnLand(), camera, math); 
    
    %The player
    playerAnt = Ant(nest.m_position + [-25, 0], [-1,0], 30, camera);
    
    %Food
    food(1) = Food(playerAnt.m_position + [-25, 0], [-1,-1], camera, UIColor, 10);
    for i = 2:25
        %Calcuate a position on land
        tempPos = gameMap.GenerateRandomPositionOnLand();
        
        %calculate a valid direction
        tempDir = math.GenerateRandomDirection45();
    
        food(i) = Food(tempPos, tempDir, camera, UIColor, 100);
    end
    targetFood = 0;
    
    %Ants
    ants = Ant.empty;
    
    %UI
    exitButton = UIFixed([1,94], [7,100], [200,10,10], 'x');
    for i = 0:1
        timer(2*i+1) = UIFixed([1,1 + i*15], [7, 5 + i*15], UIColor, '0');
        timer(2*i+2) = UIFixed([1,6 + i*15], [7, 10 + i*15], UIColor, '0');
    end
    timer(5) = UIFixed([1,11], [7, 15],  UIColor, ':');
    actionButton = UIFixed([89,44], [100, 55], UIColor, 'A');
    targetButton = UIFixed([89,57], [100, 68], UIColor, 'T');
    for i = 0:3
        foodDisp(i+1) = UIFixed([93, 11 + i*5], [100, 15 + i*5], UIColor, '0');
        queenDisp(i+1) = UIFixed([85, 11 + i*5], [92, 15 + i*5], UIColor, '0');
    end
    foodDisp(5) = UIFixed([93,1], [100, 5], UIColor, 'F');
    foodDisp(6) = UIFixed([93,6], [100, 10], UIColor, ':');
    queenDisp(1).m_display = '-';
    queenDisp(5) = UIFixed([85,1], [92, 5], UIColor, 'Q');
    queenDisp(6) = UIFixed([85,6], [92, 10], UIColor, ':');
    playerItem = UIFixed([92,92], [100, 100], UIColor, '');
    playerItem.m_textColor = [20, 150, 40];
    addAnt1 = UIFixed([63,1], [70, 8], UIColor, '+');
    addAnt2 = UIFixed([63,9], [70, 16], UIColor, 'As');
    for i = 0:3
        antCost(i+1) = UIFixed([71, 1 + i*5], [78, 5 + i*5], UIColor, '0');
    end
    antCost(1).m_display = '-';
    
    gameRunning = true;

    %Start the game time
    camera.m_gameTime = 0;
    tic;
    
    %%%%%%%%%%%%%%%
    %%%Game Loop%%%
    %%%%%%%%%%%%%%%

    while (gameRunning)
    
        %Get the deltaTime and update the game's time
        camera = camera.UpdateGameTime(toc);
        tic;
    
        %debugging
        %disp(camera.m_deltaTime);
    
        %%%Get and process the input%%%
        if (mouseDownPositionGlobal(1) ~= 0 || mouseDownPositionGlobal(2) ~= 0)
            %Check collisions with buttons
            if (exitButton.PressingButton(mouseDownPositionGlobal))
                gameRunning = false;
            elseif (actionButton.PressingButton(mouseDownPositionGlobal))
                if (playerAnt.m_food == 0)
                    for i = 1:length(food)
                        if (food(i).IsColliding(playerAnt.m_position, math))
                            playerAnt.m_food = 1;
                            food(i).m_life = food(i).m_life - 1;
                            playerItem.m_display = 'Leaf';
                        end
                    end
    
                end
    
            elseif (targetButton.PressingButton(mouseDownPositionGlobal))
                for i = 1:length(food)
                    if (food(i).IsColliding(playerAnt.m_position, math))
                        targetFood = i;
                    end
                end
            elseif (addAnt1.PressingButton(mouseDownPositionGlobal) || ...
                    addAnt2.PressingButton(mouseDownPositionGlobal))
                if (nest.m_food >= nest.m_foodForNextAnt)
                    ants(length(ants)+1) = Ant(nest.m_position, [1, 0], 20, camera);
                    nest.m_food = nest.m_food - nest.m_foodForNextAnt;
                    nest.m_foodForNextAnt = floor(1.2 * nest.m_foodForNextAnt);
                end
            else %Set player target
                position = playerAnt.m_position + mouseDownPositionGlobal - camera.m_imageDimensions/2;
                %Check the position is on land
                if (gameMap.m_gameMap(floor(position(1)), floor(position(2))) == 0 || ...  
                        gameMap.m_gameMap(floor(position(1)), floor(position(2))) == 1)
                    playerAnt = playerAnt.UpdateTargetPosition(position);
                end
            end
    
            %Reset the coordinates
            mouseDownPositionGlobal = [0,0];
        end
    
        %%%Update%%%
        [playerAnt, actionButton, targetButton] = playerAnt.UpdateGameLogicPlayer(camera, ...
            math, food, actionButton, targetButton, targetFood);
        camera = camera.Update(playerAnt.m_position, gameMap, math, food, targetFood);
        [playerAnt, nest, playerItem] = playerAnt.UpdateCameraLogicPlayer(camera, math, nest, playerItem);
    
        %Food
        for i = 1:length(food)
            [food(i), tempRemoveTarget, generateFood] = food(i).Update(camera, math, (i == targetFood));
            if (tempRemoveTarget)
                targetFood = 0;
            end
    
            if (generateFood)
                food(i) = Food(gameMap.GenerateRandomPositionOnLand(), math.GenerateRandomDirection45(), camera, ...
                    UIColor, 100);
            end
        end
        
        %nest
        [nest, tempDeath] = nest.Update(camera, math);
        if (tempDeath)
            gameRunning = false;
        end
    
        %ants
        for i = 1:length(ants)
            if (targetFood ~= 0)
                [ants(i), food(targetFood), nest] = ants(i).UpdateAntAI(camera, math, nest, food(targetFood), true);
            else
                [ants(i), ~, nest] = ants(i).UpdateAntAI(camera, math, nest, food(1), false);
            end
        end
    
        %GameTime
        [hour, minute] = math.ConvertTime(camera.m_gameTime);
        for i = 1:length(timer) - 1
            timer(i).m_display = int2str(math.GetNumberAtIndex((hour * 100 + minute), 5-i));
        end
    
        %food display
        for i = 1: length(foodDisp) - 2
            foodDisp(i).m_display =  int2str(math.GetNumberAtIndex(nest.m_food, 5-i));
        end
        if (nest.m_food < floor(camera.m_gameTime + 60) / 60 + 1)
            %Check if the player has enough food to feed the queen next
            %time

            %Set the color to flash red and white
            if (mod(floor(camera.m_gameTime), 2) == 0)
                tempColor = [200, 30, 30];
            else
                tempColor = [255, 255, 255];
            end

            for i = 1:length(foodDisp)
                foodDisp(i).m_textColor = tempColor;
            end
        else 
            for i = 1:length(foodDisp)
                foodDisp(i).m_textColor = [255, 255, 255];
            end
        end

        %Queen UI dispay
        for i = 2: length(queenDisp) - 2
            queenDisp(i).m_display =  int2str(math.GetNumberAtIndex( ...
                ceil((camera.m_gameTime + 60) / 60 + 1), 5-i));
        end

        %ant cost UI dispay
        for i = 2: length(antCost)
            antCost(i).m_display =  int2str(math.GetNumberAtIndex( ...
                nest.m_foodForNextAnt, 5-i));
        end
    
        %add ant button
        if (nest.m_food >= nest.m_foodForNextAnt)
            addAnt1.m_textColor = [255, 255, 255];
            addAnt2.m_textColor = [255, 255, 255];
        else
            addAnt1.m_textColor = [200, 20, 20];
            addAnt2.m_textColor = [200, 20, 20];
        end
    
        %%%Rendering%%%
        camera = gameMap.RenderGround(camera, math);
        camera = nest.Render(camera, math);
        if (playerAnt.m_position ~= playerAnt.m_targetPosition) %only reender if away from player
            camera = camera.RenderTarget(camera.GetScreenPos(playerAnt.m_targetPosition), ...
                [200, 20, 20]);
        end
        camera = playerAnt.RenderAnt(camera, math);
        for i = 1:length(ants)
            camera = ants(i).RenderAnt(camera, math);
        end
    
        %food
        for i = 1:length(food)
            camera = food(i).RenderFood(camera, math);
        end
    
        %UI
        camera = exitButton.Render(camera);
        for i = 1:length(timer)
            camera = timer(i).Render(camera);
        end
        for i = 1:length(foodDisp)
            camera = foodDisp(i).Render(camera);
            camera = queenDisp(i).Render(camera);
        end
        for i = 1:length(antCost)
            camera = antCost(i).Render(camera);
        end
        camera = actionButton.Render(camera);
        camera = targetButton.Render(camera);
        camera = playerItem.Render(camera);
        camera = addAnt1.Render(camera);
        camera = addAnt2.Render(camera);
        camera = camera.RenderUI(nest, math);
    
        %%%Update Figure%%%
        %if the figure is open, update the data
        %else end the script
        if (ishandle(FIGURE_HANDLE))
            set(IMAGE,'CData', camera.m_sceneImage);
        else
            gameRunning = false;
            disp("window closed");
        end
        
        %%%Pause%%%
        %Pause long enough to get the desired frame rate
        pauseTime = 1/camera.m_desiredFrameRate - camera.m_deltaTime;
        if (pauseTime < 0)
            %without the pause function, it only renders a white image
            pauseTime = 0;
        end
        pause(pauseTime);

    end %while
end