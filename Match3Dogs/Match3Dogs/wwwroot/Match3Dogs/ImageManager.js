
//The basic tile class for each tile
class ImageTile {
    constructor() {
        this.imageSource;
        this.filePath;
        this.IsChecked = false;
        this.Dead = false;
    }

    Init(imageFilePath, imageName, tileNum) {
        this.imageSource = imageName;
        this.drawImageSource = imageName;
        this.filePath = imageFilePath;
        this.tileNum = tileNum;
        this.IsChecked = false;
    }

    SetImage(imageName) {
        this.imageSource = imageName;
        this.drawImageSource = imageName;
    }

    Draw() {
        document.getElementById(`I${this.tileNum}`).src = `${this.filePath}/${this.drawImageSource }`;
    }
}

//The manager for all the tiles
class ImageManager {
    constructor() {
        this.Images = ["Amber.jpg", "Bailey.jpg", "Jade.jpg", "Kai.jpg", "King.jpg", "Rebbel.jpg", "Rusty.jpg", "Zane.jpg"];

        this.TargetImage = "";
        this.imageTargetValue = 0;
        this.imageTargetMax = 0;
    }

    Init() {
        this.TilesWide = 10;
        this.TilesTall = 10;
        this.TotalTiles = this.TilesWide * this.TilesTall;
        this.score = 0;
        this.moves = 0;
        this.aimScore = 0;
        this.BeforeClick = true;

        this.Matchs = ['N'];
        for (var i = 0; i < this.TotalTiles; i++) {
            this.Matchs[i] = "N";
        }

        this.TileArray = [new ImageTile];
        for (var y = 0; y < this.TilesTall; y++) {
            for (var x = 0; x < this.TilesWide; x++) {
                var pos = y * 10 + x;
                this.TileArray[pos] = new ImageTile();

                var image = Math.floor((Math.random() * 7) + 0);

                this.TileArray[pos].Init("Match3Dogs/Images/Dogs", this.Images[image], `${y}${x}`);
            }
        }

        /*//Temp code
        var image = Math.floor((Math.random() * 7) + 0);
        var pos = 9 * 10 + 7;
        this.TileArray[pos - 1].SetImage(this.Images[image]);
        this.TileArray[pos + 1].SetImage(this.Images[image]);
        this.TileArray[pos + 2].SetImage(this.Images[image]);
        ////////////////////*/


        this.Draw();

        document.getElementById("Reshuffle").src = "Match3Dogs/Images/Reshuffle.png";
        document.getElementById("Settings").src = "Match3Dogs/Images/Settings.png";

    }

    Draw() {
        for (var i = 0; i < this.TotalTiles; i++) {
            this.TileArray[i].Draw();
        }
    }

    //Function used if the tiles are needed to be resuffled
    ReshuffleTiles()
    {
        for (var y = 0; y < this.TilesTall; y++) {
            for (var x = 0; x < this.TilesWide; x++) {
                var pos = y * 10 + x;

                var image = Math.floor((Math.random() * 7) + 0);

                this.TileArray[pos].Init("Match3Dogs/Images/Dogs", this.Images[image], `${y}${x}`);
            }
        }

        this.BeforeClick = true;
        this.Draw();
    }

    //////////////////////////////////////
    //Checking matches private variables//
    //////////////////////////////////////

    //The main match 3 checking function
    CheckNextToEachOther() {

        //check to see if tiles are in a three or more
        this.ResetMatches();
        for (var i = 0; i < this.TotalTiles; i++) {
            var Second = i + 1;
            var Third = i + 2;
            var Bellow = i + this.TilesWide;
            var Low = Bellow + this.TilesWide;
            var Before = i - 1;
            var Above = i - this.TilesWide;
            if (this.TileArray[i].IsChecked == false) {

                this.TileArray[i].IsChecked = true;
                //Check horezontal
                if (this.CheckRight(i) && this.CheckRight(Second)) {
                    if (!this.OverEdge(i) && !this.OverEdge(Second)) {
                        this.Matchs[i] = 'H';
                        this.TileArray[i].IsChecked = true;
                        this.Matchs[Second] = 'H';
                        this.TileArray[Second].IsChecked = true;
                        this.Matchs[Third] = 'H';
                        this.TileArray[Third].IsChecked = true;

                        //Check the score can be added
                        if (!this.BeforeClick) {
                            this.score++
                        }
                    }
                }

                //Check vertical
                if (this.CheckDown(i) && this.CheckDown(Bellow)) {
                    if (Low < this.TotalTiles) {
                        this.Matchs[i] = 'V';
                        this.TileArray[i].IsChecked = true;
                        this.Matchs[Bellow] = 'V';
                        this.TileArray[Bellow].IsChecked = true;
                        this.Matchs[Low] = 'V';
                        this.TileArray[Low].IsChecked = true;

                        //Check the score can be added
                        if (!this.BeforeClick) {
                            this.score++
                        }
                    }
                }

                //Check left
                if (Before >= 0 && Before < this.TotalTiles) {
                    if (this.CheckRight(Before) && !this.OverEdge(Before)) {
                        if (this.Matchs[Before] == 'H') {
                            this.Matchs[i] = 'H';
                            this.TileArray[i].IsChecked = true;

                            //Check the score can be added
                            if (!this.BeforeClick) {
                                this.score++
                            }
                        }
                    }
                }

                //Check right
                if (Above >= 0 && Above < this.TotalTiles) {
                    if (this.CheckDown(Above)) {
                        if (this.Matchs[Above] == 'V') {
                            this.Matchs[i] = 'V';
                            this.TileArray[i].IsChecked = true;

                            //Check the score can be added
                            if (!this.BeforeClick) {
                                this.score++
                            }
                        }
                    }
                }
            }
        }

        var match = false;

        //destroy them if they are.
        for (var i = 0; i < this.TotalTiles; i++) {
            if (this.Matchs[i] == 'H' || this.Matchs[i] == 'V') {
                this.TileArray[i].Dead = true;
                match = true;
                if (this.TileArray[i].imageSource == this.TargetImage && !this.BeforeClick) {
                    this.imageTargetValue++;
                }
            }
        }

        //Dop the items.
        for (var i = this.TotalTiles - 1; i >= 0; i--) {
            if (this.TileArray[i].Dead) {
                this.DropImage(i);
                match = true;
            }
        }

        return match;
    }

    //Resets all the matches back to N
    ResetMatches() {
        for (var i = 0; i < this.TotalTiles; i++) {
            this.Matchs[i] = "N";

            this.TileArray[i].IsChecked = false;
        }
    }

    //Checks if move is valid
    CheckValidMove(Second, First) {
        //check next to
        if (Number(First) + 1 == Second || Number(First) - 1 == Number(Second)) {
            return true;
        }
        //Check Above
        if (Number(First) - this.TilesWide - 1 == Number(Second) || Number(First) - this.TilesWide == Number(Second) || Number(First) - this.TilesWide + 1 == Number(Second)) {
            return true;
        }
        //Check Below
        if (Number(First) + this.TilesWide - 1 == Number(Second) || Number(First) + this.TilesWide == Number(Second) || Number(First) + this.TilesWide + 1 == Number(Second)) {
            return true;
        }
        return false;
    }

    //Checks if right move is valid
    CheckRight(start) {
        if (start < this.TotalTiles - 1) {
            var follow = start + 1;
            if (this.TileArray[start].imageSource == this.TileArray[follow].imageSource) {
                return true;
            }
            else return false;
        }
        else return false;
    }

    //Checks if bellow move is valid
    CheckDown(start) {
        var max = this.TotalTiles - (this.TilesWide);
        if (start < max) {
            var next = start + this.TilesWide;
            if (this.TileArray[start].imageSource == this.TileArray[next].imageSource) {
                return true;
            }
            else return false;
        }
        else return false;
    }

    //Checks if the tile is in the right most column
    OverEdge(i) {
        for (var N = 0; N < this.TilesTall; N++)
        {
            if (i == N * 10 + 9) {
                return true;
                break;
            }
        }
        return false;
    }

    //Function used to drop images down if they need to be dropped.
    DropImage(i) {
        if (i >= this.TilesWide) {
            if (this.TileArray[i].Dead) {
                var Above = i - this.TilesWide;

                if (this.TileArray[Above].Dead) {
                    while (this.TileArray[Above].Dead) {
                        Above -= this.TilesWide;
                        if (Above < 0) {
                            //Set new image random
                            var image = Math.floor((Math.random() * 7) + 0);
                            this.TileArray[i].imageSource = this.Images[image];
                            this.TileArray[i].drawImageSource = this.Images[image];
                            this.Draw();
                            return;
                        }
                    }
                    if (Above >= 0) {
                        this.TileArray[i].imageSource = this.TileArray[Above].imageSource;
                        this.TileArray[i].drawImageSource = this.TileArray[Above].imageSource;
                        this.TileArray[Above].Dead = true;
                    }
                }
                else {
                    this.TileArray[i].imageSource = this.TileArray[Above].imageSource;
                    this.TileArray[i].drawImageSource = this.TileArray[Above].imageSource;
                    this.TileArray[Above].Dead = true;
                }
            }
        }
        else {
            //Set new image random
            var image = Math.floor((Math.random() * 7) + 0);
            this.TileArray[i].imageSource = this.Images[image];
            this.TileArray[i].drawImageSource = this.Images[image];
        }
        this.TileArray[i].Dead = false;
        this.Draw();
    }
};