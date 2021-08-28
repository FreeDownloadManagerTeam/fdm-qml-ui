import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.0
import org.freedownloadmanager.fdm 1.0

Drawer {
    id: root
    width: 285
    height: parent.height
    interactive: stackView.depth == 1

    Material.background: appWindow.theme.drawerBackground

    ListView {
        focus: true
        currentIndex: -1
        anchors.fill: parent
        headerPositioning: ListView.OverlayHeader

        header: Rectangle {
            id: header
            z: 2
            width: parent.width
            height: 108
            color: appWindow.theme.primary

            Image {
                id: logo
                sourceSize.width: 64
                sourceSize.height: 64
                source: Qt.resolvedUrl("../images/mobile/fdmlogo.svg")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: logo.right
                anchors.leftMargin: 10
                text: App.displayName
                color: appWindow.theme.toolbarTextColor
                font.pixelSize: 16
            }
        }

        delegate: ItemDelegate {
            opacity: model.enabled ? 1 : 0.3

            width: parent.width
            highlighted: ListView.isCurrentItem
            leftPadding: 20

            onClicked: {
                if (model.enabled)
                {
                    root.close()
                    listModel.actions[model.actionLabel]();
                }
            }

            contentItem: Row {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                spacing: 15
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: model.icon
                    sourceSize.width: 24
                    sourceSize.height: 24

                    layer {
                        effect: ColorOverlay {
                            color: appWindow.theme.drawerIcon
                        }
                        enabled: true
                    }
                }
                Label {
                    text: qsTr(model.text) + App.loc.emptyString
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    width: parent.width - 24 - parent.spacing
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        model: listModel
    }

    ListModel {
        id: listModel

        property var actions : {
            "startAllDownloadsWithPostFinishedTasks": function(){ App.downloads.mgr.startAllDownloadsWithPostFinishedTasks();},
            "stopAllDownloadsWithPostFinishedTasks": function(){ App.downloads.mgr.stopAllDownloadsWithPostFinishedTasks();},
            "browser": function(){ root.browserBtnClicked()},
            "settings": function(){ stackView.waPush(Qt.resolvedUrl("SettingsPage/SettingsPage.qml")) },
            "support": function(){ Qt.openUrlExternally('https://www.freedownloadmanager.org/support.htm?origin=menu&' + App.serverCommonGetParameters); },
            "about": function(){ aboutDlg.open(); },
            "quit": function(){ App.quit(); },
            "selfTest": function(){ App.launchSelfTest(); }
        }

        function startListModel() {
            clear();
            if (appWindow.btSupported &&
                    App.downloads.tracker.hasPostFinishedTasksDownloadsCount)
            {
                append({"text": appWindow.btS.startAllSeedingDownloadsUiText,
                           "icon": Qt.resolvedUrl("../images/mobile/play.svg"),
                           'actionLabel': "startAllDownloadsWithPostFinishedTasks",
                       "enabled": App.downloads.tracker.finishedHasDisabledPostFinishedTasks});
                append({"text": appWindow.btS.stopAllSeedingDownloadsUiText,
                           "icon": Qt.resolvedUrl("../images/mobile/pause.svg"),
                           'actionLabel': "stopAllDownloadsWithPostFinishedTasks",
                       "enabled": App.downloads.tracker.finishedHasEnabledPostFinishedTasks});
            }
            append({"text": QT_TR_NOOP("Browser"), "icon": Qt.resolvedUrl("../images/mobile/browser.svg"), 'actionLabel': "browser", "enabled": true});
            append({"text": QT_TR_NOOP("Settings"), "icon": Qt.resolvedUrl("../images/mobile/settings.svg"), 'actionLabel': "settings", "enabled": true});
            append({"text": QT_TR_NOOP("Contact support"), "icon": Qt.resolvedUrl("../images/mobile/support.svg"), 'actionLabel': "support", "enabled": true});
            append({"text": QT_TR_NOOP("About"), "icon": Qt.resolvedUrl("../images/mobile/about.svg"), 'actionLabel': "about", "enabled": true});
            append({"text": QT_TR_NOOP("Quit"), "icon": Qt.resolvedUrl("../images/mobile/quit.svg"), 'actionLabel': "quit", "enabled": true});
            if (App.isSelfTestAvail)
                append({"text": "Self Test", "icon": Qt.resolvedUrl("../images/mobile/self_test.svg"), 'actionLabel': "selfTest", "enabled": true});
        }
    }

    Rectangle {
        width: parent.width
        height: 38
        anchors.bottom: parent.bottom
        color: appWindow.theme.primary

        Image {
            id: plus
            source: Qt.resolvedUrl("../images/mobile/plus.svg")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            sourceSize.width: 24
            sourceSize.height: 24
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add new download") + App.loc.emptyString
            color: appWindow.theme.toolbarTextColor
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.close();
                appWindow.createDownloadDialog();
            }
        }
    }

    function browserBtnClicked() {
        if (uiSettingsTools.settings.browserIntroShown) {
            appWindow.openBrowser();
        } else {
            uiSettingsTools.settings.browserIntroShown = true;
            browserIntroDlg.open();
        }
    }

    Component.onCompleted: {
        listModel.startListModel();
    }

    Connections
    {
        target: App
        onIsSelfTestAvailChanged: listModel.startListModel()
    }

    Connections
    {
        target: App.downloads.tracker
        onHasPostFinishedTasksDownloadsCountChanged: listModel.startListModel()
        onFinishedHasDisabledPostFinishedTasksChanged: listModel.startListModel()
        onFinishedHasEnabledPostFinishedTasksChanged: listModel.startListModel()
    }
}
