(function () {
    const Rx = require('rxjs/Rx');
    let responseHandler = require('./js/handleRequest.js');
    window.game = window.game || {};
    window.game.Window = document.getElementById('game_main');
    window.game.extension = window.game.extension || {};
    try {
        window.game.Selector = require('./lib/dev/querySelectorHelper.js');
    }
    catch(e) {
        // For local develop only
    }
    
    window.game.AsyncWait = (ms) => {
        const p = new Promise((resolve, reject) => {
            setTimeout(() => {
                resolve();
            }, ms);
        });
        return p;
    };
    responseHandler.init();

    // Need WebContents, so call after dom-ready
    window.game.Window.addEventListener('dom-ready', () => {
        let content = window.game.Window.getWebContents();
        window.game.Content = content;
        window.game.Reload = content.reload;
        window.game.LoadURL = content.loadURL;
        responseHandler.initializeHandling();

        try {
            let devs = require('./lib/dev/devSupportMethods.js');
            devs.devInit();
        }
        catch (e) {
            // For local develop only
        }
    }, { once: true });
})();
