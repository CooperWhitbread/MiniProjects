let a_game = new GameManager();

a_game.Init();

window.setInterval(function () {
    a_game.Play();
}, Math.floor(100 / 60));


window.setInterval(function () {
    a_game.UpdateTimer();
}, Math.floor(1000));