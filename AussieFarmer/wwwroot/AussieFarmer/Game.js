class GameManager {

    ////////////////
    //Initializers//
    ////////////////
    constructor() {
        this.a_gameScreens = Object.freeze({"Start": 1, "Login": 4, "Beginning": 2, "TheGame": 3});
        this.a_currentGameScreen = this.a_gameScreens.Start;
        this.setStartScreen();
        this.TractorPos = 100;
    }

    Init() {
        this.TheGameSave = new GameSaver();

        this.min = 1000;
        this.max = 2000;
        this.MaxLoadingTime = Math.floor(Math.random() * (this.max - this.min)) + this.min; 
        this.currentTime = 0;
        //GameVariables
        this.Currency = 0;
        this.TotalCurrency = 0;

        this.timeforclick = true;

        //Animals
        this.Chicken = new Animals();
        this.Pig = new Animals();
        this.Sheep = new Animals();
        this.Cow = new Animals();
        this.Kangaroo = new Animals();
        this.Deer = new Animals();
        this.Koala = new Animals();
        this.Echidna = new Animals();
        this.Eagle = new Animals();

        //Init animals
        this.Chicken.Init(2, 0, 1, 1, "Chicken", "Egg");
        this.Pig.Init(50, 30, 10, 5, "Pig", "HamLeg");
        this.Sheep.Init(150, 100, 30, 10, "Sheep", "Wool");
        this.Cow.Init(1500, 1000, 300, 20, "Cow", "Milk");
        this.Kangaroo.Init(15000, 10000, 3000, 40, "Kangaroo", "Camera");
        this.Deer.Init(150000, 100000, 30000, 80, "Deer", "Camera");
        this.Koala.Init(1500000, 1000000, 300000, 120, "Koala", "Camera");
        this.Echidna.Init(100000000, 5000000, 3000000, 180, "Echidna", "Camera");
        this.Eagle.Init(1000000000, 150000000, 30000000, 250, "Eagle", "Feather");

        this.Chicken.AddHead(this.Currency);

        //Achievements

        this.TheAchievements = [
            new Achievements("Pig Unlocked", 1, "You have unlocked pigs!", "TheAchievements[0]"),
            new Achievements("Sheep Unlocked", 1, "You have unlocked sheep!", "TheAchievements[1]"),
            new Achievements("Cow Unlocked", 1, "You have unlocked cows!", "TheAchievements[2]"),
            new Achievements("Kanagroo Unlocked", 1, "You have unlocked kangaroos!", "TheAchievements[3]"),
            new Achievements("Deer Unlocked", 1, "You have unlocked deer!", "TheAchievements[4]"),
            new Achievements("Koala Unlocked", 1, "You have unlocked koalas!", "TheAchievements[5]"),
            new Achievements("Echidna Unlocked", 1, "You have unlocked echidnas!", "TheAchievements[6]"),
            new Achievements("Eagle Unlocked", 1, "You have unlocked eagles!", "TheAchievements[7]")
        ];
    }

    ////////////////////
    //Public Functions//
    ////////////////////
    Play() {
        switch (this.a_currentGameScreen) {
            case this.a_gameScreens.Start:
                break;
            case this.a_gameScreens.Beginning:
                if (this.currentTime < this.MaxLoadingTime) this.currentTime++;
                else {
                    this.a_currentGameScreen = this.a_gameScreens.TheGame;
                    this.setGameScreen();
                }
                break;
            case this.a_gameScreens.TheGame:
                this.playGameScreen();
                break;
        }
    }

    //////////////////////
    //Private Game Plays//
    //////////////////////
    StartGame(checked, restart) {
        if (checked) {
            if (restart) {
                this.TheGameSave.Save(0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
                this.TheGameSave.LoadSave();
                this.TheGameSave.firstLoad = false;
            }
            this.a_currentGameScreen = this.a_gameScreens.Beginning;
            this.setBeginningScreen();
        }
        else {
            this.TheGameSave.username = document.getElementById("UserNameImput").value;
            if (this.TheGameSave.LoadSave()) {
                this.PlayFromOldSpot();
            }
            else {
                this.a_currentGameScreen = this.a_gameScreens.Beginning;
                this.TheGameSave.firstLoad = false;
                this.setBeginningScreen();
            }
        }
    }

    LoginBegin() {
        this.a_currentGameScreen = this.a_gameScreens.Login;
        this.setLoginScreen();
    }

    PlayFromOldSpot() {
        document.getElementById('LoadOld').innerHTML = `
            <div id="AchievementDiv">
            Do you want to start from old save?
            <button href="#" class="cfkbutto" id="NoStart"
                onclick="a_game.StartGame(true, true)"> No </button>
            <button href="#" class="cfkbutto" id="YesStart"
                onclick="a_game.StartGame(true, false)"> Yes </button>

            </div>
        `;
    }

    playGameScreen() {
        document.getElementById('CurrencyDisplay').innerHTML = this.Currency;

        if (this.TheGameSave.GetItemsFromSave) {
            this.Currency = this.TheGameSave.save.Money;
            this.TotalCurrency = this.TheGameSave.save.Money;
            this.Chicken.Load(this.TheGameSave.save.ChickenNum);
            this.Pig.Load(this.TheGameSave.save.PigNum);
            this.Sheep.Load(this.TheGameSave.save.SheepNum);
            this.Cow.Load(this.TheGameSave.save.CowNum);
            this.Kangaroo.Load(this.TheGameSave.save.KangarooNum);
            this.Deer.Load(this.TheGameSave.save.DeerNum);
            this.Koala.Load(this.TheGameSave.save.KoalaNum);
            this.Echidna.Load(this.TheGameSave.save.EchidnaNum);
            this.Eagle.Load(this.TheGameSave.save.EagleNum);
            this.TheGameSave.GetItemsFromSave = false;
        }

        //Update Animals//
        this.TotalCurrency += this.Chicken.Update();
        this.TotalCurrency += this.Pig.Update();
        this.TotalCurrency += this.Sheep.Update();
        this.TotalCurrency += this.Cow.Update();
        this.TotalCurrency += this.Kangaroo.Update();
        this.TotalCurrency += this.Deer.Update();
        this.TotalCurrency += this.Koala.Update();
        this.TotalCurrency += this.Echidna.Update();
        this.TotalCurrency += this.Eagle.Update();

        //Update Currency
        if (this.TotalCurrency - this.Currency < 200 && this.TotalCurrency - this.Currency > 0) {
            this.Currency++;
        }
        else if (this.TotalCurrency - this.Currency > -200 && this.TotalCurrency - this.Currency < 0) {
                this.Currency--;
        }
        else {
            this.Currency += Math.floor((this.TotalCurrency - this.Currency) / 60);
        }

        //Update Achievements//
        this.TheAchievements[0].CheckAchievement(this.Pig.Heads);
        this.TheAchievements[1].CheckAchievement(this.Sheep.Heads);
        this.TheAchievements[2].CheckAchievement(this.Cow.Heads);
        this.TheAchievements[3].CheckAchievement(this.Kangaroo.Heads);
        this.TheAchievements[4].CheckAchievement(this.Deer.Heads);
        this.TheAchievements[5].CheckAchievement(this.Koala.Heads);
        this.TheAchievements[6].CheckAchievement(this.Echidna.Heads);
        this.TheAchievements[7].CheckAchievement(this.Eagle.Heads);
    }

    ///////////////////////////
    //Private GamePage Setups//
    ///////////////////////////
    setStartScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            </br></br></br></br></br></br></br>
            <h1 class="StartScreenTitle">
                Aussie Farmer
            </h1>
            <h1 class="StartScreenBy">
                By Cooper Whitbread
            </h1>
            </br></br></br>
            <button class="StartScreenPlayButton" 
                onclick="a_game.LoginBegin()">
                Press Here to Begin!
            </button>
            </br></br></br></br></br></br></br></br></br></br></br>
        `
    }

    setLoginScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            </br></br></br></br>
            <p class=InputTestLable">
                Enter User Name
            </p>
            <input id="UserNameImput"/>
            <button id="UserNameButton" onclick="a_game.StartGame(false, false)">Enter</button>
            </br></br></br></br></br></br></br>
            <div id="LoadOld"></div>
        `;
    }

    setBeginningScreen() {
        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `
            </br></br></br></br></br></br></br>
            <img class="BeginningTractor"
                 src="AussieFarmer/Images/TractorAndTrailer.png" />
            </br></br></br></br>
            <h1 class="BeginningScreenLoading">
                Loading...
            </h1>
            </br></br></br></br></br></br></br>
        `;
    }

    
    setGameScreen() {

        document.getElementById('GameBox').style.backgroundColor = "#05ff00";
        document.getElementById('GameBox').innerHTML = `

            <!--<button href="#" class="cfkbutto" id="SaveButton" 
            onclick="a_game.TheGameSave.DrawCheckSave()">Save</button>-->

            <div id="CoinDiv">
            <img id="CoinImage" src="AussieFarmer/Images/Coin.png"/>
                <span class="CoinTextNumber" id="CurrencyDisplay"></span>
            
            </div>


            <div class="animalDiv">
                <Button 
                    onclick="a_game.Chicken.WhenPressed()"
                    id="ChickenPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Chicken.png" 
                    class="animalImage"/>
                <div id="ChickenInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="ChickenAdd" 
                    onclick="a_game.Chicken.AddHead(a_game.TotalCurrency)">
                    Add Chicken</button>
                <div class="ItemImage" id="ChickenItemDiv"></div>
            </div>
            
            <div class="animalDiv">
                <Button 
                    onclick="a_game.Pig.WhenPressed()"
                    id="PigPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Pig.png" 
                    class="animalImage"/>
                <div id="PigInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="PigAdd" 
                    onclick="a_game.Pig.AddHead(a_game.TotalCurrency)">
                    Add Pig</button>
                <div class="ItemImage" id="PigItemDiv"></div>
            </div>

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Sheep.WhenPressed()"
                    id="SheepPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Sheep.png" 
                    class="animalImage"/>
                <div id="SheepInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="SheepAdd" 
                    onclick="a_game.Sheep.AddHead(a_game.TotalCurrency)">
                    Add Sheep</button>
                <div class="ItemImage" id="SheepItemDiv"></div>
            </div>
            

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Cow.WhenPressed()"
                    id="CowPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Cow.png" 
                    class="animalImage"/>
                <div id="CowInfo" class="AnimalText"></div>
                
                <button class="cfkbutto AddButton" id="CowAdd" 
                    onclick="a_game.Cow.AddHead(a_game.TotalCurrency)">
                    Add Cow</button>
                <div class="ItemImage" id="CowItemDiv"></div>
            </div>

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Kangaroo.WhenPressed()"
                    id="KangarooPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Kangaroo.png" 
                    class="animalImage"/>
                <div id="KangarooInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="KangarooAdd" 
                    onclick="a_game.Kangaroo.AddHead(a_game.TotalCurrency)">
                    Add Kangaroo</button>
                <div class="ItemImage" id="KangarooItemDiv"></div>
            </div>

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Deer.WhenPressed()"
                    id="DeerPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Deer.png" 
                    class="animalImage"/>
                <div id="DeerInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="DeerAdd" 
                    onclick="a_game.Deer.AddHead(a_game.TotalCurrency)">
                    Add Deer</button>
                <div class="ItemImage" id="DeerItemDiv"></div>
            </div>

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Koala.WhenPressed()"
                    id="KoalaPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Koala.png" 
                    class="animalImage"/>
                <div id="KoalaInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="KoalaAdd" 
                    onclick="a_game.Koala.AddHead(a_game.TotalCurrency)">
                    Add Koala</button>
                <div class="ItemImage" id="KoalaItemDiv"></div>
            </div>

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Echidna.WhenPressed()"
                    id="EchidnaPaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Echidna.png" 
                    class="animalImage"/>
                <div id="EchidnaInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="EchidnaAdd" 
                    onclick="a_game.Echidna.AddHead(a_game.TotalCurrency)">
                    Add Echidna</button>
                <div class="ItemImage" id="EchidnaItemDiv"></div>
            </div>

            <div class="animalDiv">
                <Button 
                    onclick="a_game.Eagle.WhenPressed()"
                    id="EaglePaddock"
                    class="AnimalPaddock">
                </Button>
                <img src="AussieFarmer/Images/Eagle.png" 
                    class="animalImage"/>
                <div id="EagleInfo" class="AnimalText"></div>
                <button class="cfkbutto AddButton" id="EagleAdd" 
                    onclick="a_game.Eagle.AddHead(a_game.TotalCurrency)">
                    Add Eagle</button>
                <div class="ItemImage" id="EagleItemDiv"></div>
            </div>

            <!--Comment the Load button in for testing-->
            <!--
            <button href="#" class="cfkbutto" id="LoadButton" 
            onclick="a_game.TheGameSave.DrawCheckLoad()">Load</button>
            -->

            <div id="AchievementDiver"></div>

            <div id="CheckSaveLoad"></div>

            
        `;
    }
};
