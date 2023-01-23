%The Main Running File

%%%%%%%%%%%%%%%%%
%%%How to Play%%%
%%%%%%%%%%%%%%%%%

%-Move around by pressing where you want to go on the screen
%-Go up to the leaf and press the action "A" button that appears to collect
%food
%-Take the food back to the nest to put it in you storage by clicking on
%the nest
%-Get a worker ant by clicking on the "+A" button (red indicates you don't
%have enough food). The number under this indicates how much the next ant
%is going to cost. 
%-Go back to the leaf and press the target "T" button to get you worker ant
%to collect food for you
%-When the leaf runs out, go and seach for a new leaf and repeat the
%process
%-Make sure you have enough food to keep you queen ant fed. She eats the
%indicated amout of food every 60 seconds. Not having enough food will kill
%the colony
%-The bar at the top of the screen indicates how much food is left on the
%target leaf.
%-The arrow at the top left of the screen indicates the direction of the
%nest in relationsion to the ant
%-If the amount of food you have is flashing red, it means you don't have
%enough to survive the next time the queen ant needs to eat at this point
%in time.

%%%%%%%%%%%
%%%Notes%%%
%%%%%%%%%%%

%Run this file to run the game

%Running this file will close any other matlab windows that are open

%if frame rate drops at any point, try clearing matlab's memory and
%re-running the program

%The use of capital letters for class functions is a reminder that they
%should only be called from the gameobject reference

%Obj is used in all classdef functions even if not used to ensure
%consistancy of dot referencing

%%%%%%%%%%%%%%%%
%%%References%%%
%%%%%%%%%%%%%%%%

%The use of set,ButtonDownFcn, to check input
%https://stackoverflow.com/questions/4546499/matlab-buttondownfcn

%The use of set, CData, to update the image without simply replacing it
%https://stackoverflow.com/questions/10853633/fast-way-to-update-image-objects-in-matlab-figure

%The use of the function 'ones' to create a white image
%https://au.mathworks.com/matlabcentral/answers/260483-how-to-create-a-white-image

%The use of mouseClick function and getting coordinates to determine where
%the mouse was clicked
%https://au.mathworks.com/matlabcentral/answers/508598-how-do-i-use-the-buttondownfcn-for-a-plot-in-app-designer

%The use of classdef to create classes
%https://au.mathworks.com/matlabcentral/answers/328959-how-to-call-functions-from-another-m-file

%%%%%%%%%%%%%%%%%%%%%%%%
%%%Core GameVariables%%%
%%%%%%%%%%%%%%%%%%%%%%%%

%Used to communicate between the user and the code through 
%mouse clicking only
global mouseDownPositionGlobal;
mouseDownPositionGlobal = [0,0];

%Set to be completely random
rng("shuffle");

%global constants
UICOLOR = [20, 100, 150];

%Math library
math = Math();

%The main camera
camera = Camera([100,100], [200,200], UICOLOR);

%GameMap
gameMap = GameMap([1000,1000]);
gameMap = gameMap.Initialise(math);

%Figure and Image Data
close all; %close any otherwise open matlab windows
FIGURE_HANDLE = figure;
figure(1), IMAGE = imshow(camera.m_sceneImage, 'InitialMagnification', 'fit');

%set mouse press call back
set(IMAGE,'ButtonDownFcn', @mouseClick);
set(FIGURE_HANDLE, 'MenuBar', 'None', 'NumberTitle', 'Off')

%UI
%Green background for title
AntText(1) = UIFixed([20,40], [31, 51], [20, 100, 20], 'A');
AntText(2) = UIFixed([20,52], [31, 63], [20, 100, 20], 'N');
AntText(3) = UIFixed([20,64], [31, 75], [20, 100, 20], 'T');
AntText(4) = UIFixed([20,76], [31, 87], [20, 100, 20], 'S');
%UI color background for buttons
exitButton(1) = UIFixed([65,20], [76, 31], UICOLOR, 'E');
exitButton(2) = UIFixed([65,32], [76, 43], UICOLOR, 'X');
exitButton(3) = UIFixed([65,44], [76, 55], UICOLOR, 'I');
exitButton(4) = UIFixed([65,56], [76, 67], UICOLOR, 'T');
playButton(1) = UIFixed([45,15], [56, 26], UICOLOR, 'P');
playButton(2) = UIFixed([45,27], [56, 38], UICOLOR, 'L');
playButton(3) = UIFixed([45,39], [56, 50], UICOLOR, 'A');
playButton(4) = UIFixed([45,51], [56, 62], UICOLOR, 'Y');

%Game Variables
gameRunning = true;

%Start the game time
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
        for i = 1:length(playButton) 
            if (playButton(i).PressingButton(mouseDownPositionGlobal))
                %Reset the mouse down position before starting the game
                mouseDownPositionGlobal = [0,0];
                playGame(camera, math, UICOLOR, IMAGE, FIGURE_HANDLE)
            elseif (exitButton(i).PressingButton(mouseDownPositionGlobal))
                gameRunning = false;
            end
        end

        %Reset the coordinates
        mouseDownPositionGlobal = [0,0];
    end

    %Render
    camera = gameMap.RenderGroundTotal(camera, math);
    for i = 1:length(playButton)
        camera = playButton(i).Render(camera);
        camera = exitButton(i).Render(camera);
        camera = AntText(i).Render(camera);
    end
    
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

%close the game window before exiting
close;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Input Function Callback%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mouseClick(~,eventData)
    coordinates = eventData.IntersectionPoint; 
    if (~isnan(coordinates))
        global mouseDownPositionGlobal;
        %Get it in x, y form so convert to y, x form
        mouseDownPositionGlobal(1) = coordinates(2);
        mouseDownPositionGlobal(2) = coordinates(1); 
    end
end
