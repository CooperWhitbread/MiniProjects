class MenuButtonManager
{
    constructor() {
        this.Buttons = new Map();
        this.Buttons.set("MoveRestrictionButton", false);
        this.Buttons.set("TimedRestrictionButton", false);
        this.Buttons.set("FreeRestrictionButton", true);
        this.Buttons.set("ScoreAimButton", false);
        this.Buttons.set("ItemsAimButton", false);
        this.Buttons.set("FreeAimButton", true);
    }

    Init() {
        //Restriction 
        this.UpdateScreen();
    }

    PressedButton(id) {
        switch (id) {
            case "MovesRestriction":
                {
                    this.Buttons.set("MoveRestrictionButton", true);
                    this.Buttons.set("TimedRestrictionButton", false);
                    this.Buttons.set("FreeRestrictionButton", false);
                    break;
                }
            case "TimedRestriction":
                {
                    this.Buttons.set("MoveRestrictionButton", false);
                    this.Buttons.set("TimedRestrictionButton", true);
                    this.Buttons.set("FreeRestrictionButton", false);
                    break;
                }
            case "FreeRestriction":
                {
                    this.Buttons.set("MoveRestrictionButton", false);
                    this.Buttons.set("TimedRestrictionButton", false);
                    this.Buttons.set("FreeRestrictionButton", true);
                    break;
                }

            case "ScoreAim":
                {
                    this.Buttons.set("ScoreAimButton", true);
                    this.Buttons.set("ItemsAimButton", false);
                    this.Buttons.set("FreeAimButton", false);
                    break;
                }
            case "ItemsAim":
                {
                    this.Buttons.set("ScoreAimButton", false);
                    this.Buttons.set("ItemsAimButton", true);
                    this.Buttons.set("FreeAimButton", false);
                    break;
                }
            case "FreeAim":
                {
                    this.Buttons.set("ScoreAimButton", false);
                    this.Buttons.set("ItemsAimButton", false);
                    this.Buttons.set("FreeAimButton", true);
                    break;
                }
        }
        this.UpdateScreen();
    }

    UpdateScreen() {

        if (this.Buttons.get("MoveRestrictionButton")) {
            document.getElementById("MoveRestrictionButton").src = "Match3Dogs/Images/PressedButton.png";
        }
        else {
            document.getElementById("MoveRestrictionButton").src = "Match3Dogs/Images/UnpressedButton.png";
        }

        if (this.Buttons.get("TimedRestrictionButton")) {
            document.getElementById("TimedRestrictionButton").src = "Match3Dogs/Images/PressedButton.png";
        }
        else {
            document.getElementById("TimedRestrictionButton").src = "Match3Dogs/Images/UnpressedButton.png";
        }

        if (this.Buttons.get("FreeRestrictionButton")) {
            document.getElementById("FreeRestrictionButton").src = "Match3Dogs/Images/PressedButton.png";
        }
        else {
            document.getElementById("FreeRestrictionButton").src = "Match3Dogs/Images/UnpressedButton.png";
        }


        if (this.Buttons.get("ScoreAimButton")) {
            document.getElementById("ScoreAimButton").src = "Match3Dogs/Images/PressedButton.png";
        }
        else {
            document.getElementById("ScoreAimButton").src = "Match3Dogs/Images/UnpressedButton.png";
        }

        if (this.Buttons.get("ItemsAimButton")) {
            document.getElementById("ItemsAimButton").src = "Match3Dogs/Images/PressedButton.png";
        }
        else {
            document.getElementById("ItemsAimButton").src = "Match3Dogs/Images/UnpressedButton.png";
        }

        if (this.Buttons.get("FreeAimButton")) {
            document.getElementById("FreeAimButton").src = "Match3Dogs/Images/PressedButton.png";
        }
        else {
            document.getElementById("FreeAimButton").src = "Match3Dogs/Images/UnpressedButton.png";
        }
    }
};

