# Ants

This game was the project for the Matlab and C class I undertook in my first year of university. Our task was to create a game using the graphical language Matlab. The only requirments were a playable game that took in user input and provided the user with appropriate output. It was strongly incouraged to include some form of visual feedback as well. This was my final product.

## Explanation 
The aim of the game is to grow the nest and keep the queen ant fed. Leaves are randomly spawned around an island and food can be collected from the leaves and be taken back to the nest. The queen requires a set amount of food and she eats it every minute. Any remaining food can be used to grow new ants which then can automate this process. 

## How to Play
Download the latest version of matlab. Read through the tutorial provided at the top of the Main.m file in the comments before running this file. 

## Systems
Matlab does not come with many systems to support game development so I was forced to create my own. The main systems are:

- #### Rendering

###### Uses a matrix to represent an image which can then be modified to change individual pixels. Everything rednered in the game is drawn and rotated through code.

- #### Buttons

###### Uses the mouse position provided through a mouse down function call back to do collision detection. Support functions allow the button to be rendered. 

- #### UI

###### There are two seperate rendering based systems for UI, Game Object based and Screen Fixed. They use the button and rendering systems to efficiently create simple UI. 

- #### Camera

###### The camera was set up like a normal camera in a game would be set up, with the math used in the functions adjusted to align with how the rendering system was set up. 

## Challenges

There were many challenges assositated with creating a game in matlab. The following were the key challenges faced when creating the game.

- #### Frame Rate with Rendering

###### The method chosen to render the game was inefficient and slow. It required each individual pixel to be potentially updated, setting each of the three colour channels one at a time. There was no alternative due to matlab's design as a matrix and graphing language although this meant that matrix opperations were optimised as far as practical. The screen resolution had to be dropped from 1000 x 1000 pixels to 100 x 100 pixels which managed to achieve a playable although still laggy game. This then had other consequences to do with the UI and how to make it readable without taking up too mcuh of the screen. 

- #### Classes in a procedural language

###### The use of classes is essential in any game but matlab is a procedural langauge so objects are handeled awkwardly. Classes return an object which then has to be passed into its own functions to be used. From there, if any variables were updated, the object would need to be returned and reassigned to the origional object. Functions and variables could be accessed from anywhere so variables and fucntions used naming conventions based on what they were and how they were used. 

- #### Rotating Rendered Game Objects

###### Rotating the game objects was difficult with a small resolution game. Certain angle looked ugly or unrecognisable. Rotation was done mathematically with sine and cosine functions which took me a while to work out when having to calculate each pixel seperatly. 

- #### Game Map And Waves

###### This was all included before a proper game had even been set up. It was one of the first things I worked on and it took a while working out how to create a random looking island that is able to render waves that crash onto the beach. Identifying the right math model for rendering the waves took some time and multiple methods were tested for creating and rendering the island. 

## Game Play

![Ants](/Resources/Ants.mp4?raw=true "Ants")