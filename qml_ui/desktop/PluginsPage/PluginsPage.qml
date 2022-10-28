import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import "../"
import "../BaseElements"
import "../../common"

Page {
    id: root

    readonly property string pageName: "PluginsPage"
    readonly property bool smallPage: width < 910 || height < 430
    readonly property bool hasPlugins: !App.plugins.model.empty
    readonly property bool allowInstallPlugin: !App.plugins.depsInstaller.running

    property string waitingComponentsInstallForDistribPath

    PluginsUiStrings {
        id: uiStrings
    }

    header: MainToolbar {
        pageId: "plugins"
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0
    }

    Rectangle {
        anchors.fill: parent
        color: appWindow.theme.background
    }

    ColumnLayout {       
        anchors.fill: parent
        anchors.leftMargin: (smallPage ? 18 : 22)*appWindow.zoom

        spacing: 0

        ColumnLayout
        {
            visible: App.plugins.depsInstaller.componentName

            BaseLabel {
                text: qsTr("Recently installed dependency") + App.loc.emptyString
                font.pixelSize: (smallPage ? 18 : 24)*appWindow.fontZoom
                Layout.topMargin: (smallPage ? 12 : 24)*appWindow.zoom
                Layout.bottomMargin: (smallPage ? 6 : 18)*appWindow.zoom
            }

            PluginsDepsInstallerView
            {
            }

            Layout.bottomMargin: (smallPage ? 6 : 18)*appWindow.zoom
        }

        RowLayout
        {
            BaseLabel {
                text: qsTr("Add-ons") + App.loc.emptyString
                font.pixelSize: (smallPage ? 18 : 24)*appWindow.fontZoom
                Layout.topMargin: (smallPage ? 12 : 24)*appWindow.zoom
                Layout.bottomMargin: (smallPage ? 6 : 18)*appWindow.zoom
            }

            GearButton
            {
                id: menuBtn

                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: 26*appWindow.zoom
                Layout.preferredWidth: Layout.preferredHeight

                onClicked: menu.opened ? menu.close() : menu.open()

                BaseContextMenu
                {
                    id: menu

                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                    x: parent.width + 10*appWindow.zoom

                    BaseContextMenuItem {
                        enabled: App.plugins.model.atLeast1PluginSupportsAutoUpdate
                        text: qsTr("Check for Updates") + App.loc.emptyString
                        onTriggered: App.plugins.updateMgr.updateAll()
                    }

                    BaseContextMenuSeparator {}

                    BaseContextMenuItem {
                        enabled: allowInstallPlugin
                        text: qsTr("Install Add-on From File...") + App.loc.emptyString
                        onTriggered: installPluginDlg.open()
                    }

                    BaseContextMenuSeparator {}

                    BaseContextMenuItem {
                        text: qsTr("Update Add-ons Automatically") + App.loc.emptyString
                        checkable: true
                        checked: App.settings.toBool(App.settings.app.value(AppSettings.UpdatePluginsAutomatically))
                        onTriggered: App.settings.app.setValue(AppSettings.UpdatePluginsAutomatically,
                                                               App.settings.fromBool(checked))
                    }

                    BaseContextMenuItem {
                        text: qsTr("Reset All Add-ons to Update Automatically") + App.loc.emptyString
                        enabled: App.plugins.updateMgr.hasPluginsWithDisabledAutoUpdate
                        onTriggered: App.plugins.updateMgr.resetAllPluginsToUpdateAutomatically()
                    }
                }
            }

            RowLayout
            {
                visible: App.plugins.updateMgr.updatingAll

                BaseLabel
                {
                    text: qsTr("Updating installed add-ons...") + App.loc.emptyString
                }

                DownloadsItemProgressIndicator
                {
                    infinityIndicator: true
                    Layout.preferredHeight: (smallPage ? 6 : 10)*appWindow.zoom
                    Layout.preferredWidth: 150*appWindow.zoom
                }
            }
        }

        PluginsView
        {
            visible: hasPlugins
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        RowLayout
        {
            visible: !hasPlugins

            BaseLabel
            {
                text: qsTr("There are no installed add-ons.") + App.loc.emptyString
            }

            BaseHandCursorLabel
            {
                enabled: allowInstallPlugin
                text: "<a href='#'>%1</a>.".arg(qsTr("Install add-on from file")) + App.loc.emptyString
                onLinkActivated: installPluginDlg.open()
            }
        }

        Rectangle
        {
            visible: !hasPlugins
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }

    FileDialog
    {
        id: installPluginDlg

        acceptLabel: qsTr("Install") + App.loc.emptyString
        rejectLabel: qsTr("Cancel") + App.loc.emptyString

        nameFilters: [ qsTr("%1 add-ons files").arg(App.shortDisplayName) + " (" + "*.fda" + ")" + App.loc.emptyString ]

        folder: App.tools.urlFromLocalFile(uiSettingsTools.settings.pluginsDistribsPath).url

        onAccepted: {
            uiSettingsTools.settings.pluginsDistribsPath = App.tools.url(folder).toLocalFile();
            var path = App.tools.url(file).toLocalFile();
            App.plugins.mgr.installPlugin(path);
        }
    }

    MessageDialog
    {
        id: errorMsg
        title: qsTr("Failed to install add-on") + App.loc.emptyString
    }

    MessageDialog
    {
        id: needInstallComponentsMsg
        property string distributivePath
        title: qsTr("Failed to install add-on") + App.loc.emptyString
        ////////////////////////////////////////////////////////////////
        /// https://bugreports.qt.io/browse/QTBUG-98311
        readonly property int btnYes: MessageDialog.Yes
        readonly property int btnNo: MessageDialog.No
        buttons: btnYes | btnNo
        ////////////////////////////////////////////////////////////////
        onAccepted: {
            waitingComponentsInstallForDistribPath = distributivePath;
            App.plugins.depsInstaller.installMissingDeps(distributivePath);
        }
    }

    MessageDialog
    {
        id: dangerousPermissionsDlg
        property string distributivePath
        title: qsTr("Warning!") + App.loc.emptyString
        ////////////////////////////////////////////////////////////////
        /// https://bugreports.qt.io/browse/QTBUG-98311
        readonly property int btnYes: MessageDialog.Yes
        readonly property int btnNo: MessageDialog.No
        buttons: btnYes | btnNo
        ////////////////////////////////////////////////////////////////
        onAccepted: App.plugins.mgr.acceptDangerousPermissions(distributivePath, true)
        onRejected: App.plugins.mgr.acceptDangerousPermissions(distributivePath, false)
    }

    Connections {
        target: App.plugins.mgr

        onInstallerDangerousPermissions: function(path, names, descriptions) {
            var msg = names.length > 1 ?
                        qsTr("Add-on requests dangerous permissions:") :
                        qsTr("Add-on requests dangerous permission:");

            msg += uiStrings.permissionsHtml(names, descriptions);

            msg += "<div>";

            msg += qsTr("Please install add-ons from trusted sources only.") +
                    "<br>" + qsTr("Would you like to continue the installation?");

            msg += "</div>";

            dangerousPermissionsDlg.text = msg;
            dangerousPermissionsDlg.distributivePath = path;
            dangerousPermissionsDlg.open();
        }

        onInstallerMissingComponents: function(path, components, hasInstaller) {
            var msg;
            if (components.length > 1)
                msg = qsTr("The following required components are missing:") + "\n" + components.join("\n");
            else
                msg = qsTr("%1 is required.").arg(components[0]);
            if (!hasInstaller)
            {
                errorMsg.text = msg;
                errorMsg.open();
            }
            else
            {
                msg += "\n\n";
                msg += components.length > 1 ? qsTr("Would you like to install them?") :
                                               qsTr("Would you like to install it?");
                needInstallComponentsMsg.text = msg;
                needInstallComponentsMsg.distributivePath = path;
                needInstallComponentsMsg.open();
            }
        }

        onInstallerError: function(install, path, uuid, error) {
            errorMsg.text = error;
            errorMsg.open();
        }
    }

    Connections {
        target: App.plugins.depsInstaller
        onFinishedInstallingDeps: function(path, error) {
            if (waitingComponentsInstallForDistribPath === path)
            {
                waitingComponentsInstallForDistribPath = "";
                if (!error)
                    App.plugins.mgr.installPlugin(path);                    
            }
        }
    }
}
