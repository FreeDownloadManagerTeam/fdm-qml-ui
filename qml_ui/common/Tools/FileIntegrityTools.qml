import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0

Item {
    id: root

    property var downloadModel: null
    property int fileIndex
    property int currentAlg: -1
    property int nextAlg: -1
    property string title: !downloadModel ? "" : (fileIndex > 0 ? downloadModel.fileInfo(fileIndex).path : downloadModel.title)
    property int size: !downloadModel ? 0 : (fileIndex > 0 ? downloadModel.fileInfo(fileIndex).size : downloadModel.selectedSize)
    property bool calculatingInProgress: !downloadModel ? false : downloadModel.lockReason == 'calculateHash'
    property int calculatingProgress: !downloadModel ? 0 : (downloadModel.loProgress > 0 ? downloadModel.loProgress : 0)

    function start(requestId, fileIndex)
    {
        root.downloadModel = App.downloads.infos.info(requestId);
        root.fileIndex = fileIndex;
        clearHashCombo();
        calculateHash(hashCombo.model[hashCombo.currentIndex].algorithm, "");
    }

    function calculateHash(algorithm, hash)
    {
        if (hash !== "") {
            currentHash.text = hash;
            if (currentAlg != -1) {
                abortHashCalculating()
            }
            currentAlg = algorithm;
            nextAlg = -1;
        } else if (downloadModel.lockReason == 'calculateHash') {
            if (nextAlg == -1) {
                abortHashCalculating()
            }
            nextAlg = algorithm;
        } else {
            currentAlg = algorithm;
            nextAlg = -1;
            currentHash.text = "";
            App.downloads.filesHash.calculate(downloadModel.id, fileIndex, currentAlg);
        }
    }

    function abortHashCalculating()
    {
        App.downloads.filesHash.abortCalculate(downloadModel.id, fileIndex);
    }

    function saveHash(algorithm, hash)
    {
        var m = hashCombo.model;
        var index = -1;

        for (var i = 0; i < hashCombo.model.length; i++) {
            if (m[i].algorithm == algorithm) {
                m.splice(i,1,{text: hashCombo.model[i].text, algorithm: hashCombo.model[i].algorithm, hash: hash});
                index = i;
                break;
            }
        }

        hashCombo.model = m;
        hashCombo.currentIndex = index;
    }

    function clearHashCombo()
    {
        var m = hashCombo.model;

        for (var i = 0; i < hashCombo.model.length; i++) {
            m.splice(i,i,{text: hashCombo.model[i].text, algorithm: hashCombo.model[i].algorithm, hash: ""});
        }

        hashCombo.model = m;
        hashCombo.currentIndex = 0;
    }

    Connections
    {
        target: App.downloads.filesHash
        onFinished: {
            if (downloadId == downloadModel.id && fileIndex == root.fileIndex) {
                if (hash != "") {
                    currentHash.text = hash;
                    saveHash(currentAlg, hash);
                }
                if (error != "") {
                    currentHash.text = "";
                    errorLabel.text = error;
                }
                if (nextAlg !== -1) {
                    calculateHash(nextAlg, "");
                }
            }
        }
    }

}
