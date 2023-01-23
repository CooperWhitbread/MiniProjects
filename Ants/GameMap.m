%Game Map class

classdef GameMap
    properties
        m_mapDimensions = [1000,1000]; 
        m_landFocusPoints = [ %x, y, distance from this point
            350, 350, 100;
            250, 500, 200;
            250, 750, 200;
            500, 250, 150;
            500, 500, 200;
            700, 250, 200;
            700, 500, 200;
            750, 750, 230;
        ];

        m_gameMap = [];
        m_waveData = [];

    end

    methods 
        %Constructor
        function obj = GameMap(mapDimensions)
            if nargin > 0
                obj.m_mapDimensions = mapDimensions;
                obj.m_waveData = zeros(size(obj.m_landFocusPoints, 1), 15, 3);
            end
        end

        function obj = Initialise(obj, mathRef)
            obj.m_gameMap = obj.CreateMap(mathRef);
            obj = obj.GenerateWaves();
        end

        function map = CreateMap(obj, mathRef)
            %Creates a map of the surface type of each pixel

            %initialising the map
            %default is 2 for beaches (makes code below simpler)
            map = ones(obj.m_mapDimensions(1), obj.m_mapDimensions(2), 'uint8');
            
            %Determine the colour and surface of every pixel
            for rows = 1 : obj.m_mapDimensions(1)
                for cols = 1 : obj.m_mapDimensions(2)
                    %Used to see if pixel has already been classed as part of land
                    isLand = false;
        
                    %Check through each vertex being used to define land
                    for i = 1:size(obj.m_landFocusPoints, 1)
                        %Distance between where land is defined and pixel
                        distTo = mathRef.DistanceXY(obj.m_landFocusPoints(i,2) - cols, ...
                            obj.m_landFocusPoints(i,1) - rows) - obj.m_landFocusPoints(i,3);
        
                        if (distTo <= 0) 
                            %Pixel is on land
                            if (distTo < -30)
                                %skip any that are on the beach 
                                % (They get base colour)
                                map(rows, cols) = 0;
                            end
        
                            %Regardless of whether grass or beach
                            isLand = true;
                        end
                    end
                    
                    %Check through the points again to see if just off coast
                    %Done seperatly to allow for the test to see if the pixel is
                    %defined as land
                    if (~isLand)
        
                        for i = 1:size(obj.m_landFocusPoints, 1)
                            %Distance between where land is defined and pixel
                            distTo = mathRef.DistanceXY(obj.m_landFocusPoints(i,2) - cols, ...
                                obj.m_landFocusPoints(i,1) - rows) - obj.m_landFocusPoints(i,3);
            
                            if (distTo <= 40 && ~isLand) 
                                %Within 40 pixels of the coast
                                map(rows, cols) = 2;
                            end
                        end
        
                        %if it is not land but is still beach (1) then set to deep
                        %ocean (3)
                        if (map(rows, cols) == 1)
                            map(rows, cols) = 3;
                        end
                    end
                end
            end
        end

        function obj = GenerateWaves(obj)
            rng("shuffle"); %Completely randomise the wave set up
            for i = 1:size(obj.m_landFocusPoints, 1)
                generatingWaves = true;
                j=0;
                
                obj.m_waveData(i,1, 1) =-pi();
            
                while generatingWaves
                    j = j + 1;
            
                    %Offset the waves so that they crash at different times (40 is
                    %range of positions a wave could be in)
                    obj.m_waveData(i,j, 3) = 40*rand(1); 
                
                    %randomise the wave width
                    waveWidth = pi()/10*rand(1)+pi()/10; %pi/5 to pi/10
            
                    %Ensure the widthy doesn't loop back on itself
                    if (waveWidth + obj.m_waveData(i,j, 1) >= pi() || j == 15)
                        %Force set the wave to finish it off
                        waveWidth = obj.m_waveData(i,j, 1) - 2*pi() + obj.m_waveData(i,1, 1);
                        generatingWaves = false;
                    end
            
                    %Set the end point of the wave
                    obj.m_waveData(i,j, 2) = obj.m_waveData(i,j,1)+waveWidth; 
            
                    %only set the next one if still generating waves
                    if (generatingWaves) 
                        %set to make angle width 0.3 radians
                        obj.m_waveData(i,j+1, 1) = obj.m_waveData(i,j,2); 
                    end
            
                end
            end
        end
        
        function cameraRef = RenderGround(obj, cameraRef, mathRef)
            %precalculate the position of top left corner of screen in relation to
            %the game
            topLeft = cameraRef.m_cameraPosition - cameraRef.m_imageDimensions / 2;
        
            %Scale game time to slow down the speed of the waves
            gameTime = cameraRef.m_gameTime * 0.4;
        
            %Calculate the generic position of the wave in relation to the time
            waveMovement = 40 - (gameTime - floor(gameTime))*40;
        
            %Serialise the randomness so that each frame the logic remains the same
            rng(10202);

            %set up the image
            for imageY = 1 : cameraRef.m_imageDimensions(1)
                for imageX = 1 : cameraRef.m_imageDimensions(2)
                    %check what type of surface it is
                    switch (obj.m_gameMap(floor(topLeft(1)+imageY), floor(topLeft(2)+imageX)))
                        case 0 %Land
                            cameraRef.m_sceneImage(imageY, imageX, 1) = 20;
                            cameraRef.m_sceneImage(imageY, imageX, 2) = 200;
                            cameraRef.m_sceneImage(imageY, imageX, 3) = 50;
                        case 1 %Beach
                            cameraRef.m_sceneImage (imageY, imageX, 1) = 260;
                            cameraRef.m_sceneImage (imageY, imageX, 2) = 260;
                            cameraRef.m_sceneImage (imageY, imageX, 3) = 90;
                        case 3 %Deep Ocean
                            cameraRef.m_sceneImage(imageY, imageX, 1) = 20;
                            cameraRef.m_sceneImage(imageY, imageX, 2) = 140;
                            cameraRef.m_sceneImage(imageY, imageX, 3) = 220;
                        case 2 %Shallow Ocean
                            %Generate the waves

                            cameraRef = obj.RenderWaves(cameraRef, imageY, ...
                                imageX, topLeft,  waveMovement, mathRef);

                        otherwise
                            %Render Black so we know something is not set
                            cameraRef.m_sceneImage(imageY, imageX, 1) = 0;
                            cameraRef.m_sceneImage(imageY, imageX, 2) = 0;
                            cameraRef.m_sceneImage(imageY, imageX, 3) = 0;
                    end
                end
            end
        end

        function cameraRef = RenderGroundTotal(obj, cameraRef, mathRef)
            %precalculate the position of top left corner of screen in relation to
            %the game
            topLeft = [1,1];

            scale  = obj.m_mapDimensions(1) / cameraRef.m_imageDimensions(1);
        
            %Scale game time to slow down the speed of the waves
            gameTime = cameraRef.m_gameTime * 0.4;
        
            %Calculate the generic position of the wave in relation to the time
            waveMovement = 40 - (gameTime - floor(gameTime))*40;
        
            %Serialise the randomness so that each frame the logic remains the same
            rng(10202);

            %set up the image
            for imageY = 1 : cameraRef.m_imageDimensions(1)
                for imageX = 1 : cameraRef.m_imageDimensions(2)
                    %check what type of surface it is
                    switch (obj.m_gameMap(floor(imageY * scale), floor(imageX * scale)))
                        case 0 %Land
                            cameraRef.m_sceneImage(imageY, imageX, 1) = 20;
                            cameraRef.m_sceneImage(imageY, imageX, 2) = 200;
                            cameraRef.m_sceneImage(imageY, imageX, 3) = 50;
                        case 1 %Beach
                            cameraRef.m_sceneImage (imageY, imageX, 1) = 260;
                            cameraRef.m_sceneImage (imageY, imageX, 2) = 260;
                            cameraRef.m_sceneImage (imageY, imageX, 3) = 90;
                        case 3 %Deep Ocean
                            cameraRef.m_sceneImage(imageY, imageX, 1) = 20;
                            cameraRef.m_sceneImage(imageY, imageX, 2) = 140;
                            cameraRef.m_sceneImage(imageY, imageX, 3) = 220;
                        case 2 %Shallow Ocean
                            %Generate the waves
                            
                            %Adjust the left position of the image to take
                            %into account the change in the scale
                            cameraRef = obj.RenderWaves(cameraRef, imageY, ...
                                imageX, [-imageY + imageY*scale,-imageX + imageX * scale],  waveMovement, mathRef);

                        otherwise
                            %Render Black so we know something is not set
                            cameraRef.m_sceneImage(imageY, imageX, 1) = 0;
                            cameraRef.m_sceneImage(imageY, imageX, 2) = 0;
                            cameraRef.m_sceneImage(imageY, imageX, 3) = 0;
                    end
                end
            end
        end

        function cameraRef = RenderWaves(obj, cameraRef, imageY, imageX, topLeft, ...
                waveMovement, mathRef)

            yPos = topLeft(1)+imageY;
            xPos = topLeft(2)+imageX;

            cameraRef.m_sceneImage(imageY, imageX, 1) = 20;
            cameraRef.m_sceneImage(imageY, imageX, 2) = 140;
            cameraRef.m_sceneImage(imageY, imageX, 3) = 220;

            %Loop through all the potential points
            for i = 1:size(obj.m_landFocusPoints, 1)
                %variable to indicate whether the loop is nessisary to
                %keep looping through 
                % (reducing unneeded math calculations)
                terminateLoop = false;

                %Distance of the pixel to the vertex
                yShift = yPos-obj.m_landFocusPoints(i,1);
                xShift = xPos - obj.m_landFocusPoints(i,2);
                distToLand = mathRef.DistanceXY(yShift, xShift);
            
                %Skip if the pixel is not just off the coast of this vertex
                if (distToLand < obj.m_landFocusPoints(i,3) + 40 && ...
                    distToLand > obj.m_landFocusPoints(i,3))
                    
                    %Calculate the angle between x axis and the vecotr
                    %from the vertex to the p
                    %magnitude
                    angle = acos((xShift)/distToLand);
                    
                    %angle
                    if (yShift < 0)
                        angle = -angle;
                    end
                    
                    %Reduce math calculations by doing this common step
                    %initially
                    distToLand = distToLand - obj.m_landFocusPoints(i,3);

                    %Loop through all the possible wave angles 
                    %The first dimension is the same size as pointsMatrix
                    for j = 1: size(obj.m_waveData,2)
                        %check it is in a valid range
                        if (angle >= obj.m_waveData(i, j, 1) && ...
                            angle <= obj.m_waveData(i, j, 2))
                            
                            %Repeated math equation extracted to save
                            %computational power
                            input = distToLand - mathRef.CycleValue(waveMovement + ...
                                obj.m_waveData(i, j, 3), 0, 40);

                            %Calculate the colour of the pixel
                            %representing the wave based on a set
                            %function that uses the games time, pixel's
                            %position and the wave's delay
                            cameraRef.m_sceneImage(imageY, imageX, 1) = mathRef.WaveFunction(input, 20);
                            cameraRef.m_sceneImage(imageY, imageX, 2) = mathRef.WaveFunction(input, 140);
                            cameraRef.m_sceneImage(imageY, imageX, 3) = mathRef.WaveFunction(input, 220);

                            %No need to check for this pixel against
                            %other vertexes since we only want one set
                            %of waves per region. Saves processing
                            %power
                            terminateLoop = true;
                            break;
                        end
                    end
                    
                    %extend the termination from just above
                    if (terminateLoop)
                        break;
                    end
                    
                end
            end
        end

        function position = GenerateRandomPositionOnLand(obj)
            position = randi([1,obj.m_mapDimensions(1)], [1,2]);
            while (obj.m_gameMap(position(1), position(2)) ~= 0)
                position = randi([1,obj.m_mapDimensions(1)], [1,2]);
            end
        end

    end %methods

end