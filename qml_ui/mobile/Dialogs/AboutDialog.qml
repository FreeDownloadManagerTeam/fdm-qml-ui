import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import QtQuick.Controls.Material 2.4
import "../../common"
import "../../common/Tools"
import "../BaseElements"

CenteredDialog
{
    id: root
    width: 320

    modal: true

    contentItem: ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors.margins: 20

        ColumnLayout {
            spacing: 0

            DialogTitle {
                text: App.displayName
                Layout.fillWidth: true
                NClicksTrigger {
                    anchors.fill: parent
                    onTriggered: App.testVersion = true
                }
            }

            DialogTitle {
                visible: !appWindow.hasDownloadMgr
                text: qsTr("remote control") + App.loc.emptyString
                Layout.fillWidth: true
            }
        }

        Label
        {
            text: qsTr("Version %1 (%2)").arg(App.version).arg(App.versionHash) + App.loc.emptyString
            topPadding: 20
            bottomPadding: 10
            Layout.fillWidth: true
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
        }

        Label
        {
            visible: App.testVersion
            bottomPadding: 10
            text: "Test mode is active <a href='#'>turn off</a>"
            onLinkActivated: {App.testVersion = false;}
            Material.accent: appWindow.theme.link
        }

        Repeater
        {
            model: App.thirdPartyLibsInfos.size()

            Label {
                text: "<a href='%1'>%2</a>".arg(App.thirdPartyLibsInfos.url(index)).arg(App.thirdPartyLibsInfos.displayName(index))
                          + ' ' + qsTr("version %1").arg(App.thirdPartyLibsInfos.displayVersion(index))
                          + App.loc.emptyString
                onLinkActivated: Qt.openUrlExternally(link)
                Material.accent: appWindow.theme.link
            }
        }

        Label
        {
            topPadding: 20
            //: © FreeDownloadManager.org, 2004-2023
            text: qsTr("© %1, %2-%3").arg("<a href='https://www.freedownloadmanager.org'>FreeDownloadManager.org</a>")
                    .arg(App.copytightFirstYear()).arg(App.copytightLastYear()) + App.loc.emptyString
            onLinkActivated: Qt.openUrlExternally(link)
            Material.accent: appWindow.theme.link
        }
    }
}
