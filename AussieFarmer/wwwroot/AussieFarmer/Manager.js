let a_game = new GameManager(); //Get a version of the game

a_game.Init(); //Initialize the Game

window.setInterval(function () { //The game loop
    a_game.Play();
}, Math.floor(100 / 60));

window.setInterval(function () { //Auto Save
    if (a_game.a_currentGameScreen == a_game.a_gameScreens.TheGame) {
        a_game.TheGameSave.Save(
            a_game.TotalCurrency,
            a_game.Chicken.Heads,
            a_game.Pig.Heads,
            a_game.Sheep.Heads,
            a_game.Cow.Heads,
            a_game.Kangaroo.Heads,
            a_game.Deer.Heads,
            a_game.Koala.Heads,
            a_game.Echidna.Heads,
            a_game.Eagle.Heads
        );
    }
}, 3000);