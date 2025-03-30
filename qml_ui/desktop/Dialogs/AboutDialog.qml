import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"
import "../../common/Tools"

BaseDialog {
    id: root

    title: qsTr("About") + App.loc.emptyString

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()

        Column {
            id: col

            spacing: 5*appWindow.zoom

            BaseLabel {
                anchors.left: parent.left
                text: App.displayName + App.loc.emptyString
                font.bold: true
                NClicksTrigger {
                    anchors.fill: parent
                    onTriggered: App.testVersion = true
                }
            }

            BaseHandCursorLabel
            {
                anchors.left: parent.left
                visible: App.testVersion
                text: "Test mode is active <a href='#'>turn off</a>"
                onLinkActivated: {App.testVersion = false;}
            }

            BaseSelectableLabel {
                anchors.left: parent.left
                text: qsTr("Version: %1 (%2)").arg(App.version).arg(App.versionHash) + App.loc.emptyString
            }

            BaseLabel {
                anchors.left: parent.left
                text: qsTr("Build date: %1").arg(App.loc.dateToString(App.buildDateTime, true)) + App.loc.emptyString
            }

            Rectangle {
                color: "transparent"
                height: 3*appWindow.zoom
                width: height
            }

            Repeater
            {
                model: App.thirdPartyLibsInfos.size()
                BaseHyperLabel {
                    anchors.left: parent.left
                    text: "<a href='%1'>%2</a>".arg(App.thirdPartyLibsInfos.url(index)).arg(App.thirdPartyLibsInfos.displayName(index))
                              + ' ' + App.thirdPartyLibsInfos.displayVersion(index)
                              + App.loc.emptyString
                }
            }

            Rectangle {
                color: "transparent"
                height: 3
                width: height
            }

            BaseHyperLabel {
                anchors.left: parent.left
                //: © FreeDownloadManager.org, 2004-2023
                text: qsTr("© %1, %2-%3").arg("<a href='https://www.freedownloadmanager.org'>FreeDownloadManager.org</a>")
                      .arg(App.copytightFirstYear()).arg(App.copytightLastYear()) + App.loc.emptyString
            }

            Rectangle {
                color: "transparent"
                height: 5*appWindow.zoom
                width: height
            }

            BaseButton {
                visible: appWindow.uiver === 1
                anchors.right: parent.right
                text: qsTr("OK") + App.loc.emptyString
                blueBtn: true
                onClicked: root.close()
            }
        }
    }

    onCloseClick: root.close()

    onOpened: {
        forceActiveFocus();
    }
}
