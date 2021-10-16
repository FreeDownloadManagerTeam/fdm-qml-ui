import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../../desktop/BaseElements"

Item
{
    property var downloadId: -1
    property var downloadTools: null
    property var info: downloadId !== -1 ? App.downloads.infos.info(downloadId) : null
    property bool startAllowed: info ? (info.autoStartAllowed && !info.disablePostFinishedTasks) : false
    property bool doneSeeding: info ? (!info.running && startAllowed) : false

    implicitWidth: rl.implicitWidth
    implicitHeight: rl.implicitHeight

    RowLayout
    {
        id: rl

        anchors.verticalCenter: parent.verticalCenter
        Layout.fillWidth: true

        Image
        {
            property int needSize: 16
            visible: doneSeeding
            Layout.preferredWidth: needSize
            Layout.preferredHeight: needSize
            sourceSize.width: needSize
            sourceSize.height: needSize
            Layout.alignment: Qt.AlignVCenter
            source: appWindow.theme.checkmark
        }

        Item
        {
            property bool isPause: info && (info.running || startAllowed)

            enabled: info && (info.lockReason === "" && !info.stopping)
            visible: info && (info.running || !startAllowed)

            Layout.preferredWidth: btnImg.width
            Layout.preferredHeight: btnImg.height

            Layout.alignment: Qt.AlignVCenter

            Image
            {
                id: btnImg
                source: parent.isPause ? appWindow.theme.pause : appWindow.theme.play
                opacity: parent.enabled ? 1 : 0.3
                width: 16
                height: 16
                sourceSize.width: 16
                sourceSize.height: 16
            }

            MouseArea
            {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (parent.isPause)
                    {
                        App.downloads.mgr.stopDownload(downloadId, true);
                    }
                    else
                    {
                        info.disablePostFinishedTasks = false;
                        info.autoStartAllowed = true;
                    }
                }
            }
        }

        BaseLabel
        {
            id: text
            Layout.alignment: Qt.AlignVCenter
            color: appWindow.theme.foreground
            font.pixelSize: appWindow.compactView ? 9 : 11
            text: appWindow.btS.speedHoverText(
                      info ? info.bytesUploaded : 0,
                      downloadTools ? downloadTools.ratioText : "0")
        }
    }    
}
