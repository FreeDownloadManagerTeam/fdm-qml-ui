import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common/Tools"

Dialog {
    id: root

    property int downloadId
    property string errorMessage

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    title: qsTr("Moving download failed") + App.loc.emptyString
    width: Math.round(appWindow.width * 0.8)

    contentItem: ColumnLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        spacing: 3

        Label {
            Layout.fillWidth: true
            text: qsTr("Error: %1").arg(errorMessage) + App.loc.emptyString
            Layout.bottomMargin: 7
        }

        Label {
            id: lbl
            visible: downloadsItemTools.tplPathAndTitle.length > 0
            Layout.fillWidth: true
            elide: Text.ElideMiddle
            color: "#737373"
            DownloadsItemTools {
                id: downloadsItemTools
                itemId: root.downloadId
            }
            text: qsTr("Unable to move: %1").arg(downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle) + App.loc.emptyString
        }

        RowLayout {
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.alignment: Qt.AlignRight

            spacing: 5

            DialogButton {
                text: qsTr("Try again") + App.loc.emptyString
                onClicked: root.retryMoving()
            }

            DialogButton {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: root.abortMoving()
            }
        }
    }

    onClosed: {
        downloadId = -1;
        errorMessage = "";
    }

    onRejected: {
        abortMoving();
    }

    function abortMoving()
    {
        App.downloads.moveFilesMgr.abortMove(downloadId);
        root.close();
    }

    function retryMoving()
    {
        App.downloads.moveFilesMgr.retryFailedMove(downloadId);
        root.close();
    }

    function movingFailedAction(id, error)
    {
        root.downloadId = id;
        root.errorMessage = error;
        root.open();
    }
}
