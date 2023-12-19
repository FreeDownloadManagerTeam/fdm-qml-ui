import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.4
import "../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appfeatures 1.0

Drawer {
    id: root
    width: listview.implicitWidth
    height: parent.height
    interactive: stackView.depth === 1

    Material.background: appWindow.theme.drawerBackground

    edge: appWindow.LayoutMirroring.enabled ? Qt.RightEdge : Qt.LeftEdge

    ListView {
        id: listview
        focus: true
        currentIndex: -1
        width: parent.width
        height: parent.height - addNewDownloadBlock.height
        headerPositioning: ListView.OverlayHeader

        Label {
            id: l
            visible: false
            font.pixelSize: 16
        }
        FontMetrics {
            id: fm
            font: l.font
        }

        implicitWidth: {
            // icon + text
            let h = 64 + fm.advanceWidth(App.displayName);
            for (let i = 0; i < listModel.count; ++i)
                h = Math.max(h, 24 + fm.advanceWidth(listModel.get(i).text));
            // left padding + spacing between icon and text + h + right padding
            return 20 + 10 + h + 20;
        }

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

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: logo.right
                anchors.leftMargin: 10

                Label {
                    text: App.displayName
                    color: appWindow.theme.toolbarTextColor
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    visible: !appWindow.hasDownloadMgr
                    text: qsTr("remote control") + App.loc.emptyString
                    color: appWindow.theme.toolbarTextColor
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        delegate: ItemDelegate {
            opacity: model.enabled ? 1 : 0.3

            width: listview.width
            highlighted: ListView.isCurrentItem
            leftPadding: qtbug.leftPadding(20, 0)
            rightPadding: qtbug.rightPadding(20, 0)

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
                    text: model.text
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
            "bugReport": function() {bugReportDlg.open();},
            "connectToRemoteApp": function() {connectToRemoteAppDlg.open();},
            "disconnectFromRemoteApp": function() {App.rc.client.disconnectFromRemoteApp();},
            "about": function(){ aboutDlg.open(); },
            "quit": function(){ App.quit(); },
            "selfTest": function(){ App.launchSelfTest(); }
        }

        function build() {
            // WARNING: QTBUG-96397. Qt.resolvedUrl must be called the last when defining item's properties

            clear();

            if (appWindow.btSupported &&
                    App.downloads.tracker.hasPostFinishedTasksDownloadsCount)
            {
                append({"text": appWindow.btS.startAllSeedingDownloadsUiText,
                       "actionLabel": "startAllDownloadsWithPostFinishedTasks",
                       "enabled": App.downloads.tracker.finishedHasDisabledPostFinishedTasks,
                       "icon": Qt.resolvedUrl("../images/mobile/play.svg"),});
                append({"text": appWindow.btS.stopAllSeedingDownloadsUiText,
                        "actionLabel": "stopAllDownloadsWithPostFinishedTasks",
                        "enabled": App.downloads.tracker.finishedHasEnabledPostFinishedTasks,
                        "icon": Qt.resolvedUrl("../images/mobile/pause.svg"),});
            }

            if (App.features.hasFeature(AppFeatures.BuiltinWebBrowser))
            {
                append({
                           "text": qsTr("Browser"),
                           "actionLabel": "browser",
                           "enabled": true,
                           "icon": Qt.resolvedUrl("../images/mobile/browser.svg")
                       });
            }

            if (!App.rc.client.active)
                append({"text": qsTr("Settings"), "actionLabel": "settings", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/settings.svg")});

            append({"text": qsTr("Contact support"), 'actionLabel': "support", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/support.svg")});

            if (App.features.hasFeature(AppFeatures.SubmitBugReport))
                append({"text": qsTr("Submit a bug report"), 'actionLabel': "bugReport", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/bug_report.svg")});

            if (App.features.hasFeature(AppFeatures.RemoteControlClient))
            {
                if (App.rc.client.active)
                    append({"text": qsTr("Disconnect from remote %1").arg(App.shortDisplayName), "actionLabel": "disconnectFromRemoteApp", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/rc.svg")});
                else
                    append({"text": qsTr("Connect to remote %1").arg(App.shortDisplayName), "actionLabel": "connectToRemoteApp", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/rc.svg")});
            }

            append({"text": qsTr("About"), "actionLabel": "about", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/about.svg")});

            append({"text": qsTr("Quit"), "actionLabel": "quit", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/quit.svg")});

            if (App.isSelfTestAvail)
                append({"text": "Self Test", "actionLabel": "selfTest", "enabled": true, "icon": Qt.resolvedUrl("../images/mobile/self_test.svg")});
        }
    }

    Rectangle {
        id: addNewDownloadBlock

        visible: appWindow.hasDownloadMgr

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
        listModel.build();
    }

    Connections
    {
        target: App
        onIsSelfTestAvailChanged: listModel.build()
    }

    Connections
    {
        target: App.downloads.tracker
        onHasPostFinishedTasksDownloadsCountChanged: listModel.build()
        onFinishedHasDisabledPostFinishedTasksChanged: listModel.build()
        onFinishedHasEnabledPostFinishedTasksChanged: listModel.build()
    }

    Connections
    {
        target: App.loc
        onCurrentTranslationChanged: listModel.build()
    }

    Connections {
        target: stackView
        onCurrentItemChanged: if (root.opened) root.close()
    }
}
