import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import ".."
import "../BaseElements"
import "../BaseElements/V2"
import "../Dialogs"
import "../../common"

Page {
    id: root

    property string pageName: "SettingsPage"
    property string lastInvalidSettingsMessage: ""
    property var keyboardFocusItem: keyboardFocusItem
    property bool forceAntivirusBlock: false

    property bool smallSettingsPage: width < 910*appWindow.zoom || height < 430*appWindow.zoom

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

    Component {
        id: mainToolbar_v1

        MainToolbar {
            pageId: "settings"
        }
    }

    Component {
        id: mainToolbar_v2

        MainToolbar_V2 {
            pageId: "settings"
        }
    }

    header: Loader {
        sourceComponent: appWindow.uiver === 1 ? mainToolbar_v1 : mainToolbar_v2
    }

    AppMessageDialog {
        id: invalidSettingsDlg
        title: qsTr("Invalid settings") + App.loc.emptyString
        text: lastInvalidSettingsMessage + qsTr(". Close anyway?") + App.loc.emptyString
        buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
        onAccepted: root.StackView.view.pop()
    }

    Rectangle {
        visible: appWindow.uiver === 1
        anchors.fill: parent
        color: appWindow.theme.background
    }

    RowLayout {
        id: meat

        readonly property color sideBarBgColor: appWindow.uiver === 1 ?
                                                    "transparent" :
                                                    appWindow.theme_v2.bg200

        readonly property int sideBarAddWidth: appWindow.uiver === 1 ?
                                                   0 :
                                                   (smallSettingsPage ? 18 : 22)*appWindow.zoom

        readonly property int myTopMargin: appWindow.uiver === 1 ? 0 : 16*appWindow.zoom

        anchors.fill: parent
        anchors.topMargin: appWindow.uiver === 1 ?
                               (smallSettingsPage ? 12 : 24)*appWindow.zoom :
                               0

        spacing: 0

        Rectangle
        {
            Layout.fillHeight: true

            color: meat.sideBarBgColor

            implicitWidth: tabsPanel.implicitWidth + meat.sideBarAddWidth
            implicitHeight: tabsPanel.implicitHeight

            clip: true

            ColumnLayout
            {
                id: tabsPanel

                anchors.fill: parent
                anchors.topMargin: meat.myTopMargin

                BaseLabel {
                    id: preferencesLabel
                    Layout.leftMargin: qtbug.leftMargin((smallSettingsPage ? 18 : 22)*appWindow.zoom, meat.sideBarAddWidth)
                    Layout.rightMargin: qtbug.rightMargin((smallSettingsPage ? 18 : 22)*appWindow.zoom, meat.sideBarAddWidth)
                    Layout.bottomMargin: (smallSettingsPage ? 6 : 18)*appWindow.zoom
                    text: qsTr("Preferences") + App.loc.emptyString
                    font.pixelSize: appWindow.uiver === 1 ?
                                        ((smallSettingsPage ? 18 : 24)*appWindow.fontZoom) :
                                        20*appWindow.fontZoom
                    NClicksTrigger {
                        anchors.fill: parent
                        onTriggered: uiSettingsTools.settings.showTroubleshootingUi = true
                    }
                }

                Flickable
                {
                    id: tabsFlickable

                    implicitHeight: tabsCol.implicitHeight
                    implicitWidth: tabsCol.implicitWidth + sbar.myWrapSize

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.leftMargin: qtbug.leftMargin(0, Math.max(0, meat.sideBarAddWidth - sbar.myWrapSize))
                    Layout.rightMargin: qtbug.rightMargin(0, Math.max(0, meat.sideBarAddWidth - sbar.myWrapSize))

                    contentHeight: tabsCol.implicitHeight

                    clip: true

                    ScrollBar.vertical: BaseScrollBar_V2
                    {
                        id: sbar
                        visible: tabsFlickable.height < tabsFlickable.contentHeight
                        policy: ScrollBar.AlwaysOn
                    }

                    ColumnLayout
                    {
                        id: tabsCol

                        width: parent.width - sbar.myWrapSize

                        RightItemLabel {
                            text: qsTr("General") + App.loc.emptyString
                            onClicked: flick.contentY = general.y
                            current: flick.currentTab === general
                            Layout.fillWidth: true
                        }

                        RightItemLabel {
                            text: qsTr("Browser Integration") + App.loc.emptyString
                            onClicked: flick.contentY = browserIntegration.y
                            current: flick.currentTab === browserIntegration
                            Layout.fillWidth: true
                        }

                        RightItemLabel {
                            text: qsTr("Network") + App.loc.emptyString
                            onClicked: flick.contentY = network.y
                            current: flick.currentTab === network
                            Layout.fillWidth: true
                        }

                        RightItemLabel {
                            text: qsTr("Traffic Limits") + App.loc.emptyString
                            onClicked: flick.contentY = tum.y
                            current: flick.currentTab === tum
                            Layout.fillWidth: true
                        }

                        RightItemLabel {
                            id: antivirusHeader
                            text: qsTr("Antivirus") + App.loc.emptyString
                            onClicked: flick.contentY = antivirus.y
                            current: flick.currentTab === antivirus
                            Layout.fillWidth: true
                        }

                        RightItemLabel {
                            visible: appWindow.btSupported
                            text: appWindow.btSupported ? appWindow.btS.protocolName : ""
                            onClicked: flick.contentY = bt.y
                            current: flick.currentTab === bt
                            Layout.fillWidth: true
                        }

                        RightItemLabel {
                            visible: rc.visible
                            text: qsTr("Remote Access") + App.loc.emptyString
                            onClicked: flick.contentY = rc.y
                            current: flick.currentTab === rc
                            Layout.fillWidth: true
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
                                    flick.contentY = advanced.y;
                                }
                            }
                            current: flick.currentTab === advanced
                            Layout.fillWidth: true
                            Timer {
                                id: advancedTabTimer
                                interval: 100
                                onTriggered: flick.contentY = advanced.y
                            }
                        }

                        RightItemLabel {
                            visible: troubleshooting.visible
                            text: qsTr("Troubleshooting") + App.loc.emptyString
                            onClicked: flick.contentY = troubleshooting.y
                            current: flick.currentTab === troubleshooting
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Rectangle {
                visible: appWindow.uiver !== 1
                color: meat.sideBarBgColor
                Layout.fillWidth: true
                Layout.preferredHeight: 1*appWindow.zoom
            }

            Item {
                visible: appWindow.uiver !== 1
                implicitWidth: 1
                implicitHeight: meat.myTopMargin - 1*appWindow.zoom
            }

            Flickable
            {
                id: flick
                property var currentTab

                boundsBehavior: Flickable.StopAtBounds

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.leftMargin:  qtbug.leftMargin(30*appWindow.zoom, 0)
                Layout.rightMargin: qtbug.rightMargin(30*appWindow.zoom, 0)

                flickableDirection: Flickable.HorizontalAndVerticalFlick

                ScrollBar.vertical: BaseScrollBar_V2 {}
                ScrollBar.horizontal: BaseScrollBar_V2 {}

                // there is no known way to specify contentWidth in a way it would work fine in all cases
                // so just do NOT specify it
                //contentWidth: Math.max(all.implicitWidth, width)
                contentHeight: all.implicitHeight + 48*appWindow.zoom

                implicitWidth: all.implicitWidth + 30*appWindow.zoom
                implicitHeight: all.implicitHeight + 48*appWindow.zoom

                clip: true

                ColumnLayout
                {
                    id: all
                    width: parent.width - 16*appWindow.zoom/*scrollbar width*/
                    spacing: 20*appWindow.zoom
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
                    TroubleshootingSettings {id: troubleshooting; Layout.fillWidth: true}
                }

                onContentYChanged: updateCurrentTab()
                Component.onCompleted: updateCurrentTab()

                function updateCurrentTab()
                {
                    if (isCurrentTab(general)) {
                        flick.currentTab = general;
                    } else if (isCurrentTab(browserIntegration)) {
                        flick.currentTab = browserIntegration;
                    } else if (isCurrentTab(network)) {
                        flick.currentTab = network;
                    } else if (isCurrentTab(tum)) {
                        flick.currentTab = tum;
                    } else if (isCurrentTab(antivirus)) {
                        flick.currentTab = antivirus;
                    } else if (appWindow.btSupported && isCurrentTab(bt)) {
                        flick.currentTab = bt;
                    } else if (rc.visible && isCurrentTab(rc)) {
                        flick.currentTab = rc;
                    }else if (isCurrentTab(advanced)) {
                        flick.currentTab = advanced;
                    } else if (troubleshooting.visible && isCurrentTab(troubleshooting)) {
                        flick.currentTab = troubleshooting;
                    }
                    else {
                        flick.currentTab = advanced;
                    }
                }

                function isCurrentTab(tab)
                {
                    return flick.contentY - tab.y <= 40*appWindow.fontZoom ||
                            tab.y + tab.height - flick.contentY >= flick.height / 3;
                }
            }
        }
    }
}
