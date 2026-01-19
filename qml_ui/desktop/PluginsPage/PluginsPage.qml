import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appsettings
import "../"
import "../BaseElements"
import "../Dialogs"
import "../../common"

Page {
    id: root

    readonly property string pageName: "PluginsPage"
    readonly property bool smallPage: width < 910 || height < 430
    readonly property bool hasPlugins: !App.plugins.model.empty
    readonly property bool allowInstallPlugin: !App.plugins.depsInstaller.running
    property bool checkUpdateAllLaunchedByUser: false
    property string updateAllResult
    property bool updateAllFailed: false

    property string waitingComponentsInstallForDistribPath

    PluginsUiStrings {
        id: uiStrings
    }

    Component {
        id: mainToolbar_v1

        MainToolbar {
            pageId: "plugins"
        }
    }

    Component {
        id: mainToolbar_v2

        MainToolbar_V2 {
            pageId: "plugins"
        }
    }

    header: Loader {
        sourceComponent: appWindow.uiver === 1 ? mainToolbar_v1 : mainToolbar_v2
    }

    Rectangle {
        visible: appWindow.uiver === 1
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
            Layout.topMargin: appWindow.uiver === 1 ?
                                  (smallPage ? 12 : 24)*appWindow.zoom :
                                  16*appWindow.zoom
            Layout.bottomMargin: appWindow.uiver === 1 ?
                                     (smallPage ? 6 : 18)*appWindow.zoom :
                                     16*appWindow.zoom

            spacing: 8*appWindow.zoom

            BaseLabel {
                text: qsTr("Add-ons") + App.loc.emptyString
                font.pixelSize: appWindow.uiver === 1 ?
                                    (smallPage ? 18 : 24)*appWindow.fontZoom :
                                    20**appWindow.fontZoom

                NClicksTrigger {
                    anchors.fill: parent
                    onTriggered: uiSettingsTools.settings.showPluginsDeveloperUi = true
                }
            }

            GearButton
            {
                id: menuBtn

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
                        text: qsTr("Check for updates") + App.loc.emptyString
                        onTriggered: {
                            root.checkUpdateAllLaunchedByUser = true;
                            root.updateAllResult = "";
                            root.updateAllFailed = false;
                            App.plugins.updateMgr.updateAll();
                        }
                    }

                    BaseContextMenuSeparator {}

                    BaseContextMenuItem {
                        enabled: allowInstallPlugin
                        text: qsTr("Install add-on from file...") + App.loc.emptyString
                        onTriggered: installPluginDlg.open()
                    }

                    BaseContextMenuSeparator {}

                    BaseContextMenuItem {
                        text: qsTr("Update add-ons automatically") + App.loc.emptyString
                        checkable: true
                        checked: App.settings.toBool(App.settings.app.value(AppSettings.UpdatePluginsAutomatically))
                        onTriggered: App.settings.app.setValue(AppSettings.UpdatePluginsAutomatically,
                                                               App.settings.fromBool(checked))
                    }

                    BaseContextMenuItem {
                        text: qsTr("Reset all add-ons to update automatically") + App.loc.emptyString
                        enabled: App.plugins.updateMgr.hasPluginsWithDisabledAutoUpdate
                        onTriggered: App.plugins.updateMgr.resetAllPluginsToUpdateAutomatically()
                    }

                    BaseContextMenuSeparator {}

                    BaseContextMenuItem {
                        text: qsTr("Allow add-ons to use web browser cookies") + App.loc.emptyString
                        checkable: true
                        checked: App.settings.toBool(App.settings.app.value(AppSettings.PluginsAllowWbCookies))
                        onTriggered: App.settings.app.setValue(AppSettings.PluginsAllowWbCookies,
                                                               App.settings.fromBool(checked))
                    }
                }
            }

            RowLayout
            {
                visible: root.checkUpdateAllLaunchedByUser && App.plugins.updateMgr.updatingAll

                BaseLabel
                {
                    text: qsTr("Updating installed add-ons...") + App.loc.emptyString
                }

                ProgressIndicator
                {
                    infinityIndicator: true
                    Layout.preferredHeight: (smallPage ? 6 : 10)*appWindow.zoom
                    Layout.preferredWidth: 150*appWindow.zoom
                }
            }

            BaseLabel
            {
                visible: text
                text: root.updateAllResult
                color: root.updateAllFailed ? appWindow.theme.errorMessage : appWindow.theme.foreground
            }
        }

        ColumnLayout
        {
            visible: uiSettingsTools.settings.showPluginsDeveloperUi
            Layout.leftMargin: 16*appWindow.zoom
            Layout.bottomMargin: appWindow.uiver === 1 ?
                                     (smallPage ? 6 : 18)*appWindow.zoom :
                                     16*appWindow.zoom

            BaseLabel {
                text: qsTr("Developer options") + App.loc.emptyString
                font.bold: true
            }

            // developer options
            ColumnLayout
            {
                Layout.leftMargin: 16*appWindow.zoom

                RowLayout {
                    BaseCheckBox
                    {
                        xOffset: 0
                        text: qsTr("Allow unsigned add-ons to access external directories") + App.loc.emptyString
                        checked: uiSettingsTools.settings.pluginsDevAllowedPathsIgnoreSign
                        onClicked: uiSettingsTools.settings.pluginsDevAllowedPathsIgnoreSign = checked
                    }
                    BaseLabel {
                        text: "*"
                        color: "red"
                        font.pixelSize: 14*appWindow.fontZoom
                        font.bold: true
                        Layout.alignment: Qt.AlignTop
                    }
                }

                RowLayout {
                    opacity: 0.5
                    BaseLabel {
                        text: "*"
                        color: "red"
                        font.pixelSize: 14*appWindow.fontZoom
                        font.bold: true
                        Layout.alignment: Qt.AlignTop
                    }
                    BaseLabel {
                        text: qsTr("Restart is required") + App.loc.emptyString
                    }
                }

                BaseHandCursorLabel {
                    text: "<a href='#'>" + qsTr("Hide developer options") + App.loc.emptyString + "</a>"
                    onLinkActivated: uiSettingsTools.settings.showPluginsDeveloperUi = false
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

        BaseHandCursorLabel
        {
            visible: !hasPlugins
            text: "<a href='https://www.freedownloadmanager.org/board/viewtopic.php?f=1&t=18630'>%1</a>."
                  .arg(qsTr("Learn more about %1 add-ons").arg(App.shortDisplayName)) + App.loc.emptyString
            onLinkActivated: (url) => Qt.openUrlExternally(url)
            topPadding: 20*appWindow.zoom
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

        currentFolder: App.tools.urlFromLocalFile(uiSettingsTools.settings.pluginsDistribsPath).url

        onAccepted: {
            uiSettingsTools.settings.pluginsDistribsPath = App.tools.url(currentFolder).toLocalFile();
            var path = App.tools.url(selectedFile).toLocalFile();
            App.plugins.mgr.installPlugin(path);
        }
    }

    AppMessageDialog
    {
        id: errorMsg
        title: qsTr("Failed to install add-on") + App.loc.emptyString
    }

    AppMessageDialog
    {
        id: needInstallComponentsMsg
        property string distributivePath
        title: qsTr("Failed to install add-on") + App.loc.emptyString
        buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
        onAccepted: {
            waitingComponentsInstallForDistribPath = distributivePath;
            App.plugins.depsInstaller.installMissingDeps(distributivePath);
        }
    }

    AppMessageDialog
    {
        id: dangerousPermissionsDlg
        property string distributivePath
        title: qsTr("Warning!") + App.loc.emptyString
        buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
        textFormat: Text.RichText
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

    function pluginUpdateResultText(error, isNoUpdatesFound)
    {
        if (error)
            return error;
        else if (isNoUpdatesFound)
            return qsTr("No updates found");
        else
            return "";
    }

    Connections {
        target: App.plugins.updateMgr
        onUpdateAllResult: (error, isNoUpdatesFound) => {
            if (root.checkUpdateAllLaunchedByUser)
            {
                root.checkUpdateAllLaunchedByUser = false;
                root.updateAllResult = pluginUpdateResultText(error, isNoUpdatesFound);
                root.updateAllFailed = error;
            }
        }
    }
}
