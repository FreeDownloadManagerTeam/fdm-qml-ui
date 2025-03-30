import QtQuick 2.0
import Qt.labs.platform 1.0
import org.freedownloadmanager.fdm 1.0
import "../Dialogs"

Item
{
    property string waitingComponentsInstallForUpdateDistribPath
    property string waitingComponentsInstallForUpdateUuid

    PluginsUiStrings
    {
        id: uiStrings
    }

    AppMessageDialog
    {
        id: newDependenciesMissingFatalMsg
        property string uuid
        title: qsTr("Failed to update add-on") + App.loc.emptyString
        onClosed: App.plugins.updateMgr.installedAllNewDependencies(uuid, false)
    }

    AppMessageDialog
    {
        id: newDependenciesMissingMsg
        property string distributivePath
        property string uuid
        title: qsTr("Failed to update add-on") + App.loc.emptyString
        buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
        textFormat: Text.RichText
        onAccepted: {
            waitingComponentsInstallForUpdateDistribPath = distributivePath;
            waitingComponentsInstallForUpdateUuid = uuid;
            App.plugins.depsInstaller.installMissingDeps(distributivePath);
        }
        onRejected: {
            App.plugins.updateMgr.installedAllNewDependencies(uuid, false);
        }
    }

    AppMessageDialog
    {
        id: newDangerousPermissionsDlg
        property string uuid
        title: qsTr("Warning!") + App.loc.emptyString
        buttons: AppMessageDialog.Ok | AppMessageDialog.Cancel
        textFormat: Text.RichText
        onAccepted: App.plugins.updateMgr.acceptAllNewPermissions(uuid, true)
        onRejected: App.plugins.updateMgr.acceptAllNewPermissions(uuid, false)
    }

    Connections
    {
        target: App.plugins.updateMgr

        onNewDangerousPermissionsRequired: function(uuid, names, descriptions)
        {
            var addonName = App.plugins.mgr.pluginName(uuid);
            var msg = names.length > 1 ?
                        qsTr("New version of %1 add-on requests dangerous permissions:").arg(addonName) :
                        qsTr("New version of %1 add-on requests dangerous permission:").arg(addonName);

            msg += uiStrings.permissionsHtml(names, descriptions);

            msg += "<div>";

            msg += qsTr("Please install add-ons from trusted sources only.") +
                    "<br>" + qsTr("Would you like to continue the installation?");

            msg += "</div>";

            newDangerousPermissionsDlg.text = msg;
            newDangerousPermissionsDlg.uuid = uuid;
            newDangerousPermissionsDlg.open();

            appWindow.showWindow(false);
        }

        onNewDependenciesMissing: function(uuid, distributivePath, components, hasInstaller)
        {
            var addonName = App.plugins.mgr.pluginName(uuid);

            var msg = components.length > 1 ?
                        qsTr("New version of %1 add-on requires additional components:\n%2").arg(addonName).arg(components.join("\n")):
                        qsTr("New version of %1 add-on requires %2.").arg(addonName).arg(components[0]);

            if (!hasInstaller)
            {
                newDependenciesMissingFatalMsg.text = msg;
                newDependenciesMissingFatalMsg.uuid = uuid;
                newDependenciesMissingFatalMsg.open();
            }
            else
            {
                msg += "\n\n";
                msg += components.length > 1 ? qsTr("Would you like to install them?") :
                                               qsTr("Would you like to install it?");
                newDependenciesMissingMsg.text = msg;
                newDependenciesMissingMsg.uuid = uuid;
                newDependenciesMissingMsg.distributivePath = distributivePath;
                newDependenciesMissingMsg.open();
            }

            appWindow.showWindow(false);
        }
    }

    Connections
    {
        target: App.plugins.depsInstaller

        onFinishedInstallingDeps: function(path, error)
        {
            if (waitingComponentsInstallForUpdateDistribPath === path)
            {
                waitingComponentsInstallForUpdateDistribPath = "";
                App.plugins.updateMgr.installedAllNewDependencies(
                            waitingComponentsInstallForUpdateUuid,
                            !error);
            }
        }
    }
}
