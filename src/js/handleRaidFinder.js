'use strict';

const {ipcRenderer} = require('electron');

document.addEventListener('DOMContentLoaded', () => {
    let mo = new MutationObserver((records) => {
        records.forEach((record) => {
            if(record.type==="childList") {
                for(let i = 0;i < record.addedNodes.length; i++) {
                    if(record.addedNodes[i].querySelectorAll) {
                        if (Array.from(record.addedNodes[i].classList).indexOf('gbfrf-column') != -1) {
                            let sum_name_ = record.addedNodes[i].innerText.split(/\r\n|\r|\n/)[0];
                            ipcRenderer.sendToHost("MultiStreamEvent", {
                                    EventType: "Watch",
                                    Name: sum_name_
                                });
                        }
                    }

                    if (record.addedNodes[i].className === "gbfrf-tweet gbfrf-js-tweet mdl-list__item") {
                        let sum_name = record.target.parentNode.parentNode.childNodes[1].innerText.split(/\r\n|\r|\n/)[0];
                        ipcRenderer.sendToHost("MultiStreamEvent", {
                                EventType: "Add",
                                Id: record.addedNodes[i].dataset.raidid,
                                Name: sum_name
                        });
                    }
                }
            }
        });
    });

    let init = setInterval(() => {
        try
        {
            mo.observe(document.querySelector('body > div > div.gbfrf-main-content > div.gbfrf-columns'),{
                childList:true,
                subtree:true
            });
            clearInterval(init);
        }
        catch(e)
        {
            console.error(e);
        }
    }, 1000);
});
