import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseDialog {
    id: root

    property string currentPath
    property int currentTaskId: -1
    property bool ignoreAllMode: false
    property var taskQueue: []

    title: qsTr("Download deleting failed") + App.loc.emptyString
    onCloseClick: ignoreClicked()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: ignoreClicked()
        Keys.onReturnPressed: tryAgainClicked()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                text: App.toNativeSeparators(currentPath)
                Layout.fillWidth: true
                Layout.maximumWidth: appWindow.width*0.9
                Layout.bottomMargin: 7*appWindow.zoom
                elide: Text.ElideMiddle
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                BaseButton {
                    text: qsTr("Try again") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: abortBtn.isPressed || ignoreAllBtn.isPressed || ignoreBtn.isPressed
                    onClicked: tryAgainClicked()
                }

                BaseButton {
                    id: ignoreBtn
                    text: qsTr("Ignore") + App.loc.emptyString
                    onClicked: ignoreClicked()
                }

                BaseButton {
                    id: ignoreAllBtn
                    text: qsTr("Ignore all") + App.loc.emptyString
                    onClicked: ignoreAllClicked()
                }

                BaseButton {
                    id: abortBtn
                    text: qsTr("Abort") + App.loc.emptyString
                    onClicked: abortClicked()
                }
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
