import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import "BaseElements"

BaseToolBar {
    id: root

    signal hamburgerClicked()

    signal switchMainViewSelectMode()
    signal switchSearchView()

    property int currentTumMode: App.settings.tum.currentMode

    function afterCurrentTumModeChanged()
    {
        if (!tumModeDialog.dontShowDialogAgain) {
            tumModeDialog.open();
        }
    }

    //Hamburger menu button
    ToolbarButton {
        id: hamburgerMenuBtn
        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.verticalCenter: parent.verticalCenter

        icon.source: Qt.resolvedUrl("../images/mobile/burger.svg")
        onClicked: hamburgerClicked()

        z: 1 // to be over MainToolbarStatus control
    }

    Rectangle {
        implicitWidth: modeCol.implicitWidth
        implicitHeight: modeCol.implicitHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"

        Column {
            id: modeCol
            spacing: root.width - mainToolbarStatus.width < 100 ? 16 : 6 // don't mess with left and right buttons

            //App name
            Label {
                id: shortAppName
                text: App.displayName
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 14
                font.family: "Roboto"
                font.weight: Font.DemiBold
                opacity: enabled ? 1 : 0.3
                color: appWindow.theme.toolbarTextColor
            }
            Label {
                visible: !appWindow.hasDownloadMgr
                text: qsTr("remote control") + App.loc.emptyString
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 14
                font.family: "Roboto"
                font.weight: Font.DemiBold
                opacity: enabled ? 1 : 0.3
                color: appWindow.theme.toolbarTextColor
            }

            MainToolbarStatus {
                id: mainToolbarStatus
                visible: appWindow.hasDownloadMgr
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: { if (!mainToolbarStatus.notice) tumModeDialog.open(); }
        }
    }


    // Search button
    ToolbarButton {
        id: searchBtn

        visible: appWindow.hasDownloadMgr

        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter

        icon.source: Qt.resolvedUrl("../images/mobile/search.svg")
        onClicked: switchSearchView()

        enabled: !App.downloads.infos.empty

        z: 1 // to be over MainToolbarStatus control
    }
}
