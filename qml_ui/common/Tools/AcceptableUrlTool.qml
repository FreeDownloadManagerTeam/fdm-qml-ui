import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0

Item {

    property variant callbacks: ({})

    function checkIfAcceptableUrl(text, callbackFn) {
        if (text.toString().trim() === "") {
            callbackFn(false, null, null);
        } else {
            if (typeof callbacks[text] === "undefined") {
                callbacks[text] = [];
            }
            callbacks[text].push(callbackFn);
            App.downloads.creator.checkIfAcceptableUrl(text);
        }
    }

    Connections
    {
        target: App.downloads.creator
        onAcceptableUrl: (text, acceptable, modulesUids, urlDescriptions, downloadsTypes) => {
            //console.log("[onAcceptableUrl] modulesUids: ", modulesUids, "; urlDescriptions: ", urlDescriptions, "; types: ", downloadsTypes);
            if (typeof callbacks[text] === "object") {
                var arr = callbacks[text];
                for (var i = 0; i < arr.length; i++) {
                    arr[i](acceptable, modulesUids, urlDescriptions, downloadsTypes);
                }
            }
            delete callbacks[text];
        }
    }
}
