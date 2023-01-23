class GameSaver {

    ////////////////
    //Initializers//
    ////////////////
    constructor() {
        this.save = {
            Money: 0,
            ChickenNum: 0,
            PigNum: 0,
            SheepNum: 0,
            CowNum: 0,
            KangarooNum: 0,
            DeerNum: 0,
            KoalaNum: 0,
            EchidnaNum: 0,
            EagleNum: 0
        }
        this.GetItemsFromSave = false;
        this.username = "";
        this.firstLoad = true;
    }

    //Update the save variable
    SaveMoney(money) { 
        this.save.Money = money;
    }

    Save(money, chickens, pigs, sheep, cows, kangaroos, deer, koalas, echidnas, eagles) {
        this.save.Money = money;
        this.save.ChickenNum = chickens;
        this.save.PigNum = pigs;
        this.save.SheepNum = sheep;
        this.save.CowNum = cows;
        this.save.KangarooNum = kangaroos;
        this.save.DeerNum = deer;
        this.save.KoalaNum = koalas;
        this.save.EchidnaNum = echidnas;
        this.save.EagleNum = eagles;
        this.UploadSave();
        this.StopDisplay();
    }

    //Save the save variable
    UploadSave() {
        localStorage.setItem(this.username, JSON.stringify(this.save));
    }

    //Load the save variable
    LoadSave() {
        var savegame = JSON.parse(localStorage.getItem(this.username));
        this.There = true;
        if (savegame == null)
        {
            this.There = false;
        }

        if (this.There) {
            this.save.Money = savegame.Money;
            this.save.ChickenNum = savegame.ChickenNum;
            this.save.PigNum = savegame.PigNum;
            this.save.SheepNum = savegame.SheepNum;
            this.save.CowNum = savegame.CowNum;
            this.save.KangarooNum = savegame.KangarooNum;
            this.save.DeerNum = savegame.DeerNum;
            this.save.KoalaNum = savegame.KoalaNum;
            this.save.EchidnaNum = savegame.EchidnaNum;
            if (savegame.EagleNum != null) {
                this.save.EagleNum = savegame.EagleNum;
            }
            else {
                this.save.EagleNum = 0;
            }

            this.GetItemsFromSave = true;
        }

        this.StopDisplay();
        return this.There;
    }

    DrawCheckSave() {
        document.getElementById("CheckSaveLoad").innerHTML = `

        <div id="AchievementDiv">
    
        Save
        </br>
        </br>
        Do you want to save current progress?

        <button class="cfkbutto" id="CancelButton"
            onclick="a_game.TheGameSave.StopDisplay()"> Cancel </button>

        <button class="cfkbutto" id="OKButton"
            onclick="a_game.TheGameSave.Save(a_game.Currency,
            a_game.Chicken.Heads,
            a_game.Pig.Heads,
            a_game.Sheep.Heads,
            a_game.Cow.Heads,
            a_game.Kangaroo.Heads,
            a_game.Deer.Heads,
            a_game.Koala.Heads,
            a_game.Echidna.Heads,
            a_game.Eagle.Heads,)">
            OK </button>
        </div>

        `;
    }

    DrawCheckLoad() {
        document.getElementById("CheckSaveLoad").innerHTML = `

        <div id="AchievementDiv">
    
        Load
        </br>
        </br>
        Do you want to load last save? Your current progress will be lost.

        <button href="#" class="cfkbutto" id="CancelButton"
            onclick="a_game.TheGameSave.StopDisplay()"> Cancel </button>

        <button href="#" class="cfkbutto" id="OKButton"
            onclick="a_game.TheGameSave.LoadSave()"> OK </button>
        </div>

        `;
    }

    StopDisplay() {
        if (!this.firstLoad) {
            document.getElementById("CheckSaveLoad").innerHTML = ``;
        }
    }
};