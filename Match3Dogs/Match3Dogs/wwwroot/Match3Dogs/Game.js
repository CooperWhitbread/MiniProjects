class GameManager {

    ////////////////
    //Initializers//
    ////////////////
    constructor() {
        this.a_gameScreens = new Map([["Start", 0], ["Beginning", 1], ["TheGame", 2], ["Menu", 3]]);

        //Sets the right screen to start
        this.a_currentGameScreen = this.a_gameScreens.get("Start");
        this.setStartScreen();
        this.ModeRestirct = new Map([["Timed", 1], ["Moves", 2], ["Free", 3]]);
        this.ModeAim = new Map([["Score", 1], ["Items", 2], ["Free", 3]]);

        this.TractorPos = 100;
        this.MenuButtonManager = new MenuButtonManager();

        this.timem = 0;
        this.times = 0;
        this.PausedGame = false;
        this.theFirstEndRound = false;

        this.aimText = "";
        this.ScoreToGet = 0;
    }

    Init() {
        this.min = 1000;
        this.max = 2000;
        this.MaxLoadingTime = 10;//Math.floor(Math.random() * (this.max - this.min)) + this.min; 
        this.currentTime = 0;
        this.ImageManager = new ImageManager();
        this.Selected = false;
        this.TheSelectedItem = 0;
    }

    //////////////////
    //Tile functions//
    //////////////////
    //The function to call if a tile is pressed
    WhenClicked(id) {
        if (this.Selected) {
            this.ImageManager.BeforeClick = false;
            id = id.substr(1);
            document.getElementById(this.TheSelectedItem).style.opacity = "1.0";
            var oldSelect = this.TheSelectedItem.substr(1);

            this.Swap(id, oldSelect); //Swap the tiles

            if (this.ImageManager.CheckValidMove(id, oldSelect)) {//See if they are next to each other
                this.ImageManager.Draw();//draw if true
                if (!this.ImageManager.CheckNextToEachOther()) { //Test to see if they work. If true, the tiles is next to each other
                    this.Swap(id, oldSelect); //Swap the tiles back
                }
                else {
                    if (this.MenuButtonManager.Buttons.get("MoveRestrictionButton")) {
                        this.ImageManager.moves--;
                    }
                    else {
                        this.ImageManager.moves++;
                    }
                }
            }
            else {
                this.Swap(id, oldSelect)//swap back if false
            }
            

            this.TheSelectedItem = 0;
            this.Selected = false;
        }
        else {
            this.TheSelectedItem = id;
            this.Selected = true;
            document.getElementById(id).style.opacity = "0.4";
        }
    }

    //The function to swap two tiles around
    Swap(first, second) {
        var str = String(second);
        if (str.startsWith("0")) {
            second = str.substr(1);
        }
        str = String(first);
        if (str.startsWith("0")) {
            first = str.substr(1);
        }
        
        var origional = this.ImageManager.TileArray[first].imageSource;
        this.ImageManager.TileArray[first].drawImageSource = this.ImageManager.TileArray[second].imageSource;
        this.ImageManager.TileArray[second].drawImageSource = origional;
        this.ImageManager.TileArray[first].imageSource = this.ImageManager.TileArray[second].imageSource;
        this.ImageManager.TileArray[second].imageSource = origional;
        this.ImageManager.Draw();
    }

    //////////////////
    //Game Functions//
    //////////////////
    //Controls which game screen is playing
    Play() {
        switch (this.a_currentGameScreen) {
            case this.a_gameScreens.get("Start"):
                break;
            case this.a_gameScreens.get("Beginning"):
                {
                    if (this.currentTime < this.MaxLoadingTime) {
                        this.currentTime++;
                    }

                    else {
                        this.InitMenu();
                    }
                    break;
                }
            /*case this.a_gameScreens.Menu:
                {

                    break;
                }*/
            case this.a_gameScreens.get("TheGame"):
                this.playGameScreen();
                break;
        }
    }

    //Function called to initialize the start of the game
    StartGame() {
        this.a_currentGameScreen = this.a_gameScreens.get("Beginning");
        this.setBeginningScreen();
    }

    InitMenu() {
        this.a_currentGameScreen = this.a_gameScreens.get("Menu");
        this.setMenuScreen();
        this.MenuButtonManager.Init();
    }

    //Start A Game Function
    StartAGame() {

        this.a_currentGameScreen = this.a_gameScreens.get("TheGame");
        this.setGameScreen();
        this.ImageManager.Init();
        if (this.MenuButtonManager.Buttons.get("TimedRestrictionButton")) {
            this.timem = 3;
            this.times = 0;
        }
        else {
            this.timem = 0;
            this.times = 0;
        }
        if (this.MenuButtonManager.Buttons.get("MoveRestrictionButton")) {
            this.ImageManager.moves = 40;
        }
        else {
            this.ImageManager.moves = 0;
        }

        if (this.MenuButtonManager.Buttons.get("ScoreAimButton")) {
            //Score set
            this.aimText = " ";
            this.theFirstEndRound = true;
            this.ScoreToGet = 50;
            document.getElementById("AimImage").src = "Match3Dogs/Images/gap.png";
        }
        else if (this.MenuButtonManager.Buttons.get("ItemsAimButton")) {
            //items set
            this.aimText = " : ";
            this.ImageManager.imageTargetMax = 25;
            var image = Math.floor((Math.random() * 7) + 0);
            this.ImageManager.TargetImage = this.ImageManager.Images[image];
            this.theFirstEndRound = true;
            document.getElementById("AimImage").src = `Match3Dogs/Images/Dogs/${this.ImageManager.Images[image]}`;
        }
        else {
            //No aim
            this.aimText = "";
            document.getElementById("AimImage").src = "Match3Dogs/Images/gap.png";
        }

        this.PausedGame = false;
    }

    //The actual game run function
    playGameScreen() {
        this.ImageManager.CheckNextToEachOther();
        var currentscore = this.ImageManager.score;
        var theDisplayScore = 0;
        if (this.MenuButtonManager.Buttons.get("ScoreAimButton")) {
            theDisplayScore = this.ScoreToGet - currentscore;
            if (theDisplayScore <= 0) {
                if (this.theFirstEndRound) {
                    theDisplayScore = 0;
                    if (this.MenuButtonManager.Buttons.get("MoveRestrictionButton")) {
                        this.setEndGameMessage("You have won!", `You had ${this.ImageManager.moves} moves left.`);
                    }
                    else if (this.MenuButtonManager.Buttons.get("TimedRestrictionButton")) {
                        this.setEndGameMessage("You have won!", `You had ${this.timem} minute/s ${this.times} second/s left.`);
                    }
                    else {
                        this.setEndGameMessage("You have won!", `You took ${this.ImageManager.moves} moves and ${this.timem} minutes ${this.times} seconds.`);
                    }
                    this.theFirstEndRound = false;
                }
            }
        }
        else {
            theDisplayScore = currentscore;
        }

        if (this.MenuButtonManager.Buttons.get("ItemsAimButton")) {
            if (this.ImageManager.imageTargetValue >= this.ImageManager.imageTargetMax) {
                if (this.theFirstEndRound) {
                    theDisplayScore = 0;
                    if (this.MenuButtonManager.Buttons.get("MoveRestrictionButton")) {
                        this.setEndGameMessage("You have won!", `You had ${this.ImageManager.moves} moves left.`);
                    }
                    else if (this.MenuButtonManager.Buttons.get("TimedRestrictionButton")) {
                        this.setEndGameMessage("You have won!", `You had ${this.timem} minute/s ${this.times} second/s left.`);
                    }
                    else {
                        this.setEndGameMessage("You have won!", `You took ${this.ImageManager.moves} moves and ${this.timem} minutes ${this.times} seconds.`);
                    }
                    this.theFirstEndRound = false;
                }
            }
        }

        if (this.MenuButtonManager.Buttons.get("ItemsAimButton")) {
            this.aimText = `${this.ImageManager.imageTargetValue} : ${this.ImageManager.imageTargetMax}`;
        }
        else {
            this.aimText = "";
        }

        document.getElementById("ScoreSpan").innerHTML = `Score: ${theDisplayScore}`;
        document.getElementById("MoveSpan").innerHTML = `Moves: ${this.ImageManager.moves}`;
        document.getElementById("AimSpan").innerHTML = `${this.aimText}`;
        document.getElementById("TimerSpan").innerHTML = `Time: ${this.timem}:${this.times}`;
    }

    UpdateTimer() {
        if (this.a_currentGameScreen == this.a_gameScreens.get("TheGame")) {
            if (this.PausedGame == false) {
                var test = this.MenuButtonManager.Buttons.get("TimedRestrictionButton");
                if (this.MenuButtonManager.Buttons.get("TimedRestrictionButton")) {
                    this.times--;
                    if (this.times == -1) {
                        this.timem--;
                        this.times = 59;
                    }
                    if (this.timem == -1) {
                        this.timem = 0;
                        this.times = 0;
                        this.setEndGameScreen();
                    }
                }
                else {
                    this.times++;
                    if (this.times == 60) {
                        this.timem++;
                        this.times = 0;
                    }
                }
            }
        }
    }

    //Sets the initial screen seen at start of the game
    setStartScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            </br></br></br></br></br></br></br>
            <h1 class="StartScreenTitle">
                Match3Dogs
            </h1>
            <h1 class="StartScreenBy">
                By Cooper Whitbread
            </h1>
            </br></br></br>
            <button class="StartScreenPlayButton" 
                onClick="a_game.StartGame()">
                Press Here to Begin!
            </button>
        `;
    }

    //Sets the laoding screen
    setBeginningScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            </br></br></br></br></br></br></br>
            <img class="BeginningImageLoading"
                 src="Match3Dogs/Images/RunningDog.gif" />
            </br></br>
            <h1 class="BeginningScreenLoading">
                Loading...
            </h1>
        `;
    }

    //Sets the initial screen seen at start of the game
    setMenuScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            </br>
            <h1 class="MenuScreenTitle">
                Match3Dogs
            </h1>
            <p class="MenuInfo">
                Game Setup
            </p>
            
            <div class="MenuBounding">
                <div class="MenuDiv">
                     <button class="ModeSelect" 
                        id="TimedRestriction"
                        onClick="a_game.MenuButtonManager.PressedButton(this.id)">
                        Timed Restriction (3 minutes)
                    </button>
                    <img class="DotButtonImage"
                        id="TimedRestrictionButton"/>
                </div>
                </br>
            
                <div class="MenuDiv">
                    <button class="ModeSelect" 
                        id="MovesRestriction"
                        onClick="a_game.MenuButtonManager.PressedButton(this.id)">
                        Move Restriction (40 moves)
                    </button>
                    <img class="DotButtonImage"
                        id="MoveRestrictionButton"/>
                </div>
                </br>
            
                <div class="MenuDiv">
                    <button class="ModeSelect"
                        id="FreeRestriction"
                        onClick="a_game.MenuButtonManager.PressedButton(this.id)">
                        No Restriction
                    </button>
                    <img class="DotButtonImage"
                        id="FreeRestrictionButton"/>
                </div>
                </br>
            </div>

            <div class="MenuBounding">
                <div class="MenuDiv">
                    <button class="ModeSelect"  
                        id="ScoreAim"
                        onClick="a_game.MenuButtonManager.PressedButton(this.id)">
                        Score Aim (50 points)
                    </button>
                    <img class="DotButtonImage"
                        id="ScoreAimButton"/>
                </div>
                </br>
            
                <div class="MenuDiv">
                    <button class="ModeSelect"  
                        id="ItemsAim"
                        onClick="a_game.MenuButtonManager.PressedButton(this.id)">
                        Item Aim (25 tiles)
                    </button>
                    <img class="DotButtonImage"
                        id="ItemsAimButton"/>
                </div>
                </br>
            
                <div class="MenuDiv">
                    <button class="ModeSelect" 
                        id="FreeAim"
                        onClick="a_game.MenuButtonManager.PressedButton(this.id)">
                        No Aim
                    </button>
                    <img class="DotButtonImage"
                        id="FreeAimButton"/>
                </div>
                </br>
            </div>

            </br>

            <img src="Match3Dogs/Images/gap.png" width="100%"/>
            <img src="Match3Dogs/Images/gap.png" width="100%"/>
            <img src="Match3Dogs/Images/gap.png" width="100%"/>

            
            <button class="MenuScreenPlayButton" 
                onClick="a_game.StartAGame()">
                Press Here to Begin!
            </button>
        `;
    }

    

    //Sets the main game screen
    setGameScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            
            
            <div id="OverBar"">
                <div style="float: left; width: 20%;">
                    <span id="ScoreSpan"></span>
                </div>
                <div style="float: left; width: 20%;">
                    <div id="Timeer">
                        <span id="MoveSpan"></span>
                    </div>
                </div>
                <div style="float: left; width: 20%;">
                    <div id="MoveLeft">
                        <span id="TimerSpan"></span>
                    </div>
                </div>
                <div style="float: left; width: 20%;">
                    <div id="Aim">
                        <img id="AimImage"/>
                        <span id="AimSpan"></span>
                    </div>
                </div>
                <div style="float: left; width: 20%;">
                    <img onmouseup="(a_game.setPauseScreen())" id="Settings"/>
                    <img onmouseup="(a_game.ImageManager.ReshuffleTiles())" id="Reshuffle"/>
                </div> 
            </div>
            <img src="Match3Dogs/Images/gap.png" width="100%"/>

            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I00"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I01"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I02"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I03"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I04"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I05"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I06"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I07"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I08"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I09"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I10"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I11"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I12"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I13"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I14"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I15"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I16"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I17"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I18"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I19"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I20"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I21"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I22"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I23"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I24"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I25"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I26"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I27"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I28"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I29"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I30"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I31"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I32"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I33"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I34"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I35"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I36"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I37"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I38"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I39"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I40"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I41"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I42"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I43"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I44"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I45"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I46"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I47"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I48"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I49"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I50"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I51"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I52"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I53"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I54"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I55"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I56"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I57"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I58"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I59"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I60"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I61"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I62"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I63"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I64"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I65"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I66"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I67"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I68"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I69"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I70"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I71"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I72"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I73"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I74"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I75"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I76"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I77"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I78"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I79"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I80"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I81"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I82"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I83"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I84"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I85"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I86"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I87"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I88"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I89"></div></div>
            </br>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I90"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I91"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I92"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I93"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I94"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I95"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I96"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I97"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I98"></div></div>
            <div class="TileDiv"><div class="Dummy"></div><div class="TileImage"><image class="Image" onmouseup="(a_game.WhenClicked(this.id))" id="I99"></div></div>
            </br>

            <div id="PauseScreen"></div>
            `;
    }

    setPauseScreen() {
        this.PausedGame = true;
        document.getElementById('PauseScreen').innerHTML = `
            <div id="BPauseScreen">
            </div>
            <div id="APauseScreen">
                </br></br></br></br>
                <button class="PauseMenueButton" 
                    onClick="a_game.InitMenu()">
                    Exit Game
                </button>
                </br></br></br>
                <button class="PauseMenueButton" 
                    onClick="a_game.removePauseScreen()">
                    Back to game
                </button>
            </div>
        `;
    }

    setEndGameScreen() {
        this.PausedGame = true;
        document.getElementById('PauseScreen').innerHTML = `
            <div id="BPauseScreen">
            </div>
            <div id="APauseScreen">
                </br></br></br>
                <span id="EndGameTitle> 
                    You Ran Out Of Time!
                </span>
                <span id="EndGameMessage>
                    Your score was ${this.ImageManager.score}!
                </span>
                </br>
                <button class="PauseMenueButton" 
                    onClick="a_game.InitMenu()">
                    Click Here To Play Again
                </button>
            </div>
        `;
    }

    setEndGameMessage(messageTitle, messageText) {
        this.PausedGame = true;
        document.getElementById('PauseScreen').innerHTML = `
            <div id="BPauseScreen">
            </div>
            <div id="APauseScreen">
                </br></br></br>
                <span id="EndGameTitle> 
                    ${messageTitle}
                </span>
                </br>
                <span id="EndGameMessage>
                    ${messageText}
                </span>
                </br>
                <button class="PauseMenueButton" 
                    onClick="a_game.InitMenu()">
                    Click Here To Play Again
                </button>
            </div>
        `;
    }


    removePauseScreen() {
        this.PausedGame = false;
        document.getElementById('PauseScreen').innerHTML = `
            
        `;
    }
};
