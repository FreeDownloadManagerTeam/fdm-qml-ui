import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    property string currentPath
    property int currentTaskId: -1
    property var taskQueue: []

    contentItem: BaseDialogItem {
        titleText: qsTr("Extraneous files are detected") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: abortClicked()
        Keys.onReturnPressed: continueClicked()
        onCloseClick: abortClicked()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 3*appWindow.zoom

            BaseLabel {
                text: qsTr("The following folder contains extraneous files. Do you still want to delete it?") +
                      App.loc.emptyString
            }

            BaseLabel {
                text: App.toNativeSeparators(currentPath)
                Layout.fillWidth: true
                Layout.maximumWidth: appWindow.width*0.9
                Layout.topMargin: 7*appWindow.zoom
                Layout.bottomMargin: 7*appWindow.zoom
                elide: Text.ElideMiddle
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                CustomButton {
                    text: qsTr("Delete anyway") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: abortBtn.isPressed
                    onClicked: continueClicked()
                }

                CustomButton {
                    id: abortBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: abortClicked()
                }
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
