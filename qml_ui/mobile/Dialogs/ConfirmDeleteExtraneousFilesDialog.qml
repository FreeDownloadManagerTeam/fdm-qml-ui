import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"

Dialog {
    id: root

    property string currentPath
    property int currentTaskId: -1
    property var taskQueue: []

    parent: Overlay.overlay

    closePolicy: Popup.NoAutoClose

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: qsTr("Extraneous files are detected") + App.loc.emptyString

    contentItem: ColumnLayout {

        BaseLabel {
            text: qsTr("The following folder contains extraneous files. Do you still want to delete it?") +
                  App.loc.emptyString
            Layout.maximumWidth: appWindow.width*0.8
            wrapMode: Text.WordWrap
        }

        BaseLabel {
            text: currentPath
            Layout.fillWidth: true
            Layout.maximumWidth: appWindow.width*0.8
            Layout.topMargin: 7
            Layout.bottomMargin: 7
            elide: Text.ElideMiddle
        }

        RowLayout {
            Layout.fillWidth: true

            DialogButton
            {
                text: qsTr("Delete anyway") + App.loc.emptyString
                onClicked: continueClicked()
            }

            DialogButton
            {
                Layout.column: appWindow.smallScreen ? 0 : 3
                Layout.row: appWindow.smallScreen ? 3 : 0
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: abortClicked()
            }
        }
    }

    onOpened: forceActiveFocus()
    onClosed: checkTaskQueue()

    function checkTaskQueue() {
        if (taskQueue.length > 0) {
            let currentTask = taskQueue.shift();
            currentTaskId = currentTask.taskId;
            currentPath = currentTask.path;
            root.open();
        }
        else {
            currentTaskId = -1;
        }
    }

    function continueClicked() {
        App.filesOps.continueRemoveFiles(currentTaskId, false, false);
        root.close();
    }

    function abortClicked() {
        App.filesOps.abortRemoveFiles(currentTaskId);
        root.close();
    }

    Connections {
        target: App.filesOps
        onExtraneousFilesDetected: (taskId, path) => {
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
