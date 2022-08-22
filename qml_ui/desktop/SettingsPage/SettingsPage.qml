import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
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
        pageId: "settings"
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0
    }

    MessageDialog {
        id: invalidSettingsDlg
        title: qsTr("Invalid settings") + App.loc.emptyString
        text: lastInvalidSettingsMessage + qsTr(". Close anyway?") + App.loc.emptyString
        buttons: buttonOk | buttonCancel
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
                onClicked: flick.contentY = general.y + 5
                current: flick.currentTab === general
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Browser Integration") + App.loc.emptyString
                onClicked: flick.contentY = browserIntegration.y + 5
                current: flick.currentTab === browserIntegration
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Network") + App.loc.emptyString
                onClicked: flick.contentY = network.y + 5
                current: flick.currentTab === network
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Traffic Limits") + App.loc.emptyString
                onClicked: flick.contentY = tum.y + 5
                current: flick.currentTab === tum
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                id: antivirusHeader
                text: qsTr("Antivirus") + App.loc.emptyString
                onClicked: flick.contentY = antivirus.y + 5
                current: flick.currentTab === antivirus
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                visible: appWindow.btSupported
                text: appWindow.btSupported ? appWindow.btS.protocolName : ""
                onClicked: flick.contentY = bt.y + 5
                current: flick.currentTab === bt
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                visible: rc.visible
                text: qsTr("Remote Access") + App.loc.emptyString
                onClicked: flick.contentY = rc.y + 5
                current: flick.currentTab === rc
                Layout.preferredWidth: navigationColumnWidth
            }

            RightItemLabel {
                text: qsTr("Advanced") + App.loc.emptyString
                readonly property int adjust: Math.max(0, flick.height - advanced.height)
                onClicked: {
                    if (advanced.hidden)
                    {
                        advanced.hidden = false;
                        advancedTabTimer.start();
                    }
                    else
                    {
                        flick.contentY = advanced.y + 5;
                    }
                }
                current: flick.currentTab === advanced
                Layout.preferredWidth: navigationColumnWidth
                Timer {
                    id: advancedTabTimer
                    interval: 100
                    onTriggered: flick.contentY = advanced.y + 5
                }
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
                anchors.top: parent.top
                anchors.topMargin: smallSettingsPage ? 12 : 24
                GeneralSettings {id: general; Layout.fillWidth: true}
                BrowserIntegrationSettings {id: browserIntegration; Layout.fillWidth: true}
                NetworkSettings {id: network; Layout.fillWidth: true}
                TrafficLimitsSettings {id: tum; Layout.fillWidth: true}
                AntivirusSettings {id: antivirus; Layout.fillWidth: true}
                Loader {
                    id: bt
                    visible: appWindow.btSupported
                    active: appWindow.btSupported
                    Layout.fillWidth: true
                    source: "../../bt/desktop/BtSettings.qml"
                }
                RemoteControlSettings {id: rc; Layout.fillWidth: true}
                AdvancedSettings {id: advanced; Layout.fillWidth: true}
            }

            onContentYChanged: updateCurrentTab()
            Component.onCompleted: updateCurrentTab()

            function updateCurrentTab()
            {
                if (general.y - contentY + 5 >= 0) {
                    flick.currentTab = general;
                } else if (browserIntegration.y - contentY + 5 >= 0) {
                    flick.currentTab = browserIntegration;
                } else if (network.y - contentY + 5 >= 0) {
                    flick.currentTab = network;
                } else if (tum.y - contentY + 5 >= 0) {
                    flick.currentTab = tum;
                } else if (antivirus.y - contentY + 5 >= 0) {
                    flick.currentTab = antivirus;
                } else if (appWindow.btSupported && bt.y - contentY + 5 >= 0) {
                    flick.currentTab = bt;
                } else if (rc.visible && rc.y - contentY + 5 >= 0) {
                    flick.currentTab = rc;
                }else {
                    flick.currentTab = advanced;
                }
            }
        }
    }
}
