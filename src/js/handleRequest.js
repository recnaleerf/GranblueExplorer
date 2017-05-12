'use strict';

const Rx = require('rxjs/Rx');

function initializeHandling() {
    let content = window.game.Content;
    let webSocketIds = {};

    try {
        content.debugger.attach('1.2');
    } catch (err) {
        console.log('Debugger attach failed : ', err);
    };

    content.debugger.on('detach', (event, reason) => {
        console.log('Debugger detached due to : ', reason);
    });

    content.debugger.on('message', (event, method, params) => {
        if (method === 'Network.responseReceived') {
            if (params.response.mimeType === 'application/json' && /^http:\/\/game\.granbluefantasy\.jp\/.+$/.test(params.response.url)) {
                content.debugger.sendCommand(
                    'Network.getResponseBody',
                    { 'requestId': params.requestId },
                    (e, r) => {
                        window.game.jsonResponse.next({
                            URL: params.response.url,
                            Body: r.body
                        });
                        //// cannot handling /user/content/index ...why?
                        // console.log(params.response.url);
                        // console.dir(r.body);
                    }
                );
            }
        } else if(method === 'Network.requestWillBeSent') {
            // console.log('willBeSent');
        } else if (method === 'Network.webSocketFrameReceived') {
            let body = params.response.payloadData;
            let arstr = body.indexOf("[");
            let brstr = body.indexOf("{");
            let mindex = 0;

            if (arstr == -1 && brstr == -1) {
                return;
            } else if (arstr == -1) {
                mindex = brstr;
            } else if (brstr == -1) {
                mindex = arstr;
            } else {
                mindex = Math.min(brstr, arstr);
            }

            window.game.websocketResponse.next({
                URL: webSocketIds[params.requestId],
                Body: body.slice(mindex)});
            // console.log(params.response.payloadData);
        } else if (method === 'Network.webSocketCreated') {
            console.log("WebSocket Created: ", params.requestId, params.url);
            webSocketIds[params.requestId] = params.url;
        }
    });

    content.debugger.sendCommand('Network.enable');

    console.log('Begin Network');
}

module.exports = {
    // Call top-level
    init: () => {
        window.game.jsonResponse = window.game.jsonResponse || new Rx.Subject();
        window.game.websocketResponse = window.game.websocketResponse || new Rx.Subject();
    },
    // Call after webview emitted dom-ready
    initializeHandling: initializeHandling,
};
