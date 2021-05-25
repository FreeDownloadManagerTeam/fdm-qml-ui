import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Dialog {
    id: root

    property string currentPath
    property int currentTaskId: -1
    property bool ignoreAllMode: false
    property var taskQueue: []

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: qsTr("Download deleting failed") + App.loc.emptyString
    width: Math.round(appWindow.width * 0.8)

    contentItem: ColumnLayout {
        width: parent.width

        BaseLabel {
            text: currentPath
            Layout.fillWidth: true
            Layout.bottomMargin: 7
            elide: Text.ElideMiddle
        }

        GridLayout {
            Layout.fillWidth: true

            DialogButton
            {
                text: qsTr("Try again") + App.loc.emptyString
                onClicked: tryAgainClicked()
            }

            DialogButton
            {
                Layout.column: appWindow.smallScreen ? 0 : 1
                Layout.row: appWindow.smallScreen ? 1 : 0
                text: qsTr("Ignore") + App.loc.emptyString
                onClicked: ignoreClicked()
            }

            DialogButton
            {
                Layout.column: appWindow.smallScreen ? 0 : 2
                Layout.row: appWindow.smallScreen ? 2 : 0
                text: qsTr("Ignore all") + App.loc.emptyString
                onClicked: ignoreAllClicked()
            }

            DialogButton
            {
                Layout.column: appWindow.smallScreen ? 0 : 3
                Layout.row: appWindow.smallScreen ? 3 : 0
                text: qsTr("Abort") + App.loc.emptyString
                onClicked: abortClicked()
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: checkTaskQueue()

    Timer {
        id: ignoreAllTimer
        interval: 10000;
        running: false;
        repeat: false
        onTriggered: {
            ignoreAllMode = false;
        }
    }

    function checkTaskQueue() {
        if (taskQueue.length > 0) {
            var currentTask;
            if (ignoreAllMode) {
                while (currentTask = taskQueue.shift())
                {
                    ignoreAll(currentTask.taskId);
                }
            } else {
                currentTask = taskQueue.shift();
                currentTaskId = currentTask.taskId;
                currentPath = currentTask.path;
                root.open();
                return;
            }
        }
        currentTaskId = -1;
    }

    function tryAgainClicked() {
        ignoreAllMode = false;
        ignoreAllTimer.stop();
        App.filesOps.continueRemoveFiles(currentTaskId, false, false);
        root.close();
    }

    function ignoreClicked() {
        ignoreAllMode = false;
        ignoreAllTimer.stop();
        App.filesOps.continueRemoveFiles(currentTaskId, true, false);
        root.close();
    }

    function ignoreAllClicked() {
        ignoreAllMode = true;
        ignoreAllTimer.restart();
        ignoreAll(currentTaskId);
        root.close();
    }

    function ignoreAll(taskId) {
        App.filesOps.continueRemoveFiles(taskId, true, true);
    }

    function abortClicked() {
        console.log("abortClicked", currentTaskId);
        ignoreAllMode = false;
        ignoreAllTimer.stop();
        App.filesOps.abortRemoveFiles(currentTaskId);
        root.close();
    }

    Connections {
        target: App.filesOps
        onGotErrorRemovingFile: {
            if (ignoreAllMode) {
                ignoreAll(taskId);
            } else {
                if (currentTaskId !== -1) {
                    taskQueue.push({'taskId': taskId, 'path': path});
                } else {
                    currentTaskId = taskId;
                    currentPath = path;
                    root.open();
                }
            }
        }
    }
}
