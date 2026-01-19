import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.freedownloadmanager.fdm
import "../BaseElements"

BaseDialog {
    id: root

    property var downloadId: -1
    property int fileIndex: -1

    readonly property string target: (downloadId != -1 && fileIndex != -1) ?
                                        App.tools.fileNamePart(App.downloads.infos.info(downloadId).fileInfo(fileIndex).path) :
                                     downloadId != -1 ? App.downloads.infos.info(downloadId).title :
                                     ""

    title: qsTr("Ready to play") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.playAndClose()

        Column {
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

                BaseButton {
                    id: playButton
                    text: qsTr("Play") + App.loc.emptyString
                    blueBtn: true
                    onClicked: root.playAndClose()
                }

                BaseButton {
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
