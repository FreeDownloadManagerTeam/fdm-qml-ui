import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.1
import org.freedownloadmanager.fdm 1.0
import ".."
import "../BaseElements"

Page {
    id: root

    property string pageName: "SettingsPage"
    property string lastInvalidSettingsMessage: ""
    property var keyboardFocusItem: keyboardFocusItem
    property int navigationColumnWidth: smallSettingsPage ? 180 : 190
    property bool forceAntivirusBlock: false

    property bool smallSettingsPage: width < 910 || height < 430

    Item {
        id: keyboardFocusItem
        focus: true
        Keys.onPressed: {
            // TODO
        }
    }

    Component.onCompleted: {
        keyboardFocusItem.focus = true;
        root.forceActiveFocus();
        if (forceAntivirusBlock) {
            tmr.restart()
        }
    }

    Timer {
        id: tmr
        interval: 500
        running: false
        onTriggered: antivirusHeader.clicked()
    }

    header: MainToolbar {
        forSettingsPage: true
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0
    }

    MessageDialog {
        id: invalidSettingsDlg
        title: qsTr("Invalid settings") + App.loc.emptyString
        text: lastInvalidSettingsMessage + qsTr(". Close anyway?") + App.loc.emptyString
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: root.StackView.view.pop()
    }

    Rectangle {
        anchors.fill: parent
        color: appWindow.theme.background
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout
        {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: navigationColumnWidth
            Layout.topMargin: smallSettingsPage ? 12 : 24

            BaseLabel {
                text: qsTr("Preferences") + App.loc.emptyString
                font.pixelSize: smallSettingsPage ? 18 : 24
                Layout.leftMargin: smallSettingsPage ? 18 : 22
                Layout.bottomMargin: smallSettingsPage ? 6 : 18
            }

            RightItemLabel {
                text: qsTr("General") + App.loc.emptyString
                onClicked: flick.contentY = general.y
                current: flick.currentTab === general
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Browser Integration") + App.loc.emptyString
                onClicked: flick.contentY = browserIntegration.y
                current: flick.currentTab === browserIntegration
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Network") + App.loc.emptyString
                onClicked: flick.contentY = network.y
                current: flick.currentTab === network
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Traffic Limits") + App.loc.emptyString
                onClicked: flick.contentY = tum.y
                current: flick.currentTab === tum
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                id: antivirusHeader
                text: qsTr("Antivirus") + App.loc.emptyString
                onClicked: flick.contentY = antivirus.y
                current: flick.currentTab === antivirus
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Advanced") + App.loc.emptyString
                onClicked: flick.contentY = advanced.y
                current: flick.currentTab === advanced
                Layout.preferredWidth: navigationColumnWidth
            }
        }

        Flickable
        {
            id: flick
            property var currentTab

            boundsBehavior: Flickable.StopAtBounds

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: smallSettingsPage ? 10 : 30

            flickableDirection: Flickable.HorizontalAndVerticalFlick//appWindow.width < 910 ? Flickable.VerticalFlick : Flickable.AutoFlickIfNeeded
            ScrollBar.vertical: ScrollBar {}
            ScrollBar.horizontal: ScrollBar { /*visible: appWindow.width < 910*/}

            contentWidth: all.width
            contentHeight: all.height + 48

            clip: true

            ColumnLayout
            {
                id: all
                spacing: 20
//                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: smallSettingsPage ? 12 : 24
                GeneralSettings {id: general; Layout.fillWidth: true}
                BrowserIntegrationSettings {id: browserIntegration; Layout.fillWidth: true}
                NetworkSettings {id: network; Layout.fillWidth: true}
                TrafficLimitsSettings {id: tum; Layout.fillWidth: true}
                AntivirusSettings {id: antivirus; Layout.fillWidth: true}
                AdvancedSettings {id: advanced; Layout.fillWidth: true}


            }

            onContentYChanged: updateCurrentTab()
            Component.onCompleted: updateCurrentTab()

            function updateCurrentTab()
            {
                if (general.y - contentY >= 0) {
                    flick.currentTab = general;
                } else if (browserIntegration.y - contentY >= 0) {
                    flick.currentTab = browserIntegration;
                } else if (network.y - contentY >= 0) {
                    flick.currentTab = network;
                } else if (tum.y - contentY >= 0) {
                    flick.currentTab = tum;
                } else if (antivirus.y - contentY >= 0) {
                    flick.currentTab = antivirus;
                } else {
                    flick.currentTab = advanced;
                }
            }
        }
    }
}
