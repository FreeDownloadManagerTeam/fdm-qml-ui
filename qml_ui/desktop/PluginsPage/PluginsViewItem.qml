import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../../common"
import "../BaseElements"
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

RowLayout
{
    id: root

    property bool checkUpdateThisLaunchedByUser: false
    property string updateResult
    property bool updateFailed: false
    readonly property bool checkUpdateLaunchedByUser: checkUpdateThisLaunchedByUser || checkUpdateAllLaunchedByUser

    WaSvgImage
    {
        id: img
        source: model.icon.toString() ?
                    model.icon :
                    Qt.resolvedUrl("../../images/desktop/plugin.svg")
        zoom: appWindow.zoom
        Layout.preferredHeight: 64*zoom
        Layout.preferredWidth: Layout.preferredHeight
    }

    ColumnLayout
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.leftMargin: 15*appWindow.zoom

        RowLayout
        {
            BaseLabel
            {
                text: model.name
                font.bold: true
            }

            GearButton
            {
                onClicked: menu.opened ? menu.close() : menu.open()

                BaseContextMenu
                {
                    id: menu

                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                    x: parent.width + 10*appWindow.zoom

                    BaseContextMenuItem {
                        enabled: model.supportsAutoUpdate
                        text: qsTr("Allow Automatic Updates") + App.loc.emptyString
                        checkable: true
                        checked: model.supportsAutoUpdate && !model.autoUpdateDisabled
                        onTriggered: App.plugins.updateMgr.disableAutoUpdate(model.uuid, !checked)
                    }

                    BaseContextMenuItem {
                        enabled: model.supportsAutoUpdate
                        text: qsTr("Check for Updates") + App.loc.emptyString
                        onTriggered: {
                            root.checkUpdateThisLaunchedByUser = true;
                            root.updateResult = "";
                            root.updateFailed = false;
                            App.plugins.updateMgr.update(model.uuid);
                        }
                    }

                    BaseContextMenuSeparator {}

                    BaseContextMenuItem {
                        text: qsTr("Remove") + App.loc.emptyString
                        onTriggered: removePlugin()
                    }
                }
            }

            RowLayout
            {
                visible: root.checkUpdateLaunchedByUser && model.updating

                BaseLabel
                {
                    text: qsTr("Updating...") + App.loc.emptyString
                }

                DownloadsItemProgressIndicator
                {
                    infinityIndicator: true
                    Layout.preferredHeight: (smallPage ? 6 : 10)*appWindow.zoom
                    Layout.preferredWidth: 150*appWindow.zoom
                }
            }

            BaseLabel
            {
                visible: text && text !== updateAllResult
                text: root.updateResult
                color: root.updateFailed ? appWindow.theme.errorMessage : appWindow.theme.foreground
            }
        }

        BaseLabel
        {
            text: model.description
        }

        RowLayout
        {
            BaseLabel
            {
                text: qsTr("Version: %1").arg(model.version) + App.loc.emptyString
            }

            WaSvgImage
            {
                visible: errorMsg.visible
                source: Qt.resolvedUrl("../../images/warning.svg")
                zoom: appWindow.zoom
                Layout.leftMargin: 10*appWindow.zoom
                Layout.preferredHeight: errorMsg.height
                Layout.preferredWidth: Layout.preferredHeight
            }

            BaseLabel
            {
                id: errorMsg
                visible: model.error
                text: model.error
                color: appWindow.theme.errorMessage
                Layout.fillWidth: true
            }
        }
    }

    Item
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
    }

    MessageDialog
    {
        id: okToRemoveMsg
        text: qsTr("OK to remove?")
        buttons: buttonOk | buttonCancel
        onAccepted: removePluginWithoutConfirmation()
    }

    function removePlugin()
    {
        okToRemoveMsg.open();
    }

    function removePluginWithoutConfirmation()
    {
        App.plugins.mgr.uninstallPlugin(model.uuid);
    }

    Connections {
        target: App.plugins.updateMgr
        onUpdatePluginResult: (uuid, error, isNoUpdatesFound) => {
            if (model.uuid !== uuid)
                return;
            if (root.checkUpdateLaunchedByUser)
            {
                root.checkUpdateThisLaunchedByUser = false;
                root.updateResult = pluginUpdateResultText(error, isNoUpdatesFound);
                root.updateFailed = error;
            }
        }
    }
}
