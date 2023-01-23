class Achievements {

    ////////////////
    //Initializers//
    ////////////////
    constructor(name, value, text, path) {
        this.Name = name;
        this.Value = value;
        this.Text = text;
        this.Completed = false;
        this.Path = path;
    }

    ////////////////////
    //Public Functions//
    ////////////////////

    CheckAchievement(testValue) {
        if (testValue >= this.Value && !this.Completed) {
            this.Completed = true;
            this.DrawDisplay();
            return this.Completed;
        }
        return false;
    }

    StopDisplay() {
        document.getElementById("AchievementDiver").innerHTML = ``;
    }

    /////////////////////
    //Private Functions//
    /////////////////////

    DrawDisplay() {
        document.getElementById("AchievementDiver").innerHTML = `

        <div id="AchievementDiv">

        ${this.Name}
        </br>
        </br>
        ${this.Text}

        <button href="#" class="cfkbutto" id="AchievementButton"
            onclick="a_game.${this.Path}.StopDisplay()"> OK </button>

        </div>

        `;
    }
}