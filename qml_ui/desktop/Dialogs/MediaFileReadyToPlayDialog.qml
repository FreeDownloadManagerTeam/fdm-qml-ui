import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

BaseDialog {
    id: root

    property var downloadId: -1
    property int fileIndex: -1

    readonly property string target: (downloadId != -1 && fileIndex != -1) ?
                                        App.tools.fileNamePart(App.downloads.infos.info(downloadId).fileInfo(fileIndex).path) :
                                     downloadId != -1 ? App.downloads.infos.info(downloadId).title :
                                     ""

    contentItem: BaseDialogItem {
        titleText: qsTr("Ready to play") + App.loc.emptyString

        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.playAndClose()
        onCloseClick: root.close()

        Column {
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            Layout.bottomMargin: 10*appWindow.zoom
            spacing: 5*appWindow.zoom

            BaseLabel
            {
                bottomPadding: 10*appWindow.zoom
                text: qsTr("%1 is ready to play").arg(target) + App.loc.emptyString
                wrapMode: Text.WordWrap
            }

            Row
            {
                anchors.right: parent.right
                spacing: 5*appWindow.zoom

                CustomButton {
                    id: playButton
                    text: qsTr("Play") + App.loc.emptyString
                    blueBtn: true
                    onClicked: root.playAndClose()
                }

                CustomButton {
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }
            }
        }
    }

    onOpened: forceActiveFocus()

    function playAndClose()
    {
        App.downloads.mgr.openDownload(downloadId, fileIndex);
        close();
    }
}
