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

    WaSvgImage
    {
        id: img
        source: model.icon.toString() ?
                    model.icon :
                    Qt.resolvedUrl("../../images/desktop/plugin.svg")
        Layout.preferredHeight: 64
        Layout.preferredWidth: Layout.preferredHeight
    }

    ColumnLayout
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.leftMargin: 15

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

                    x: parent.width + 10

                    BaseContextMenuItem {
                        text: qsTr("Allow Automatic Updates") + App.loc.emptyString
                        checkable: true
                        checked: !model.autoUpdateDisabled
                        onTriggered: App.plugins.updateMgr.disableAutoUpdate(model.uuid, !checked)
                    }

                    BaseContextMenuItem {
                        text: qsTr("Check for Updates") + App.loc.emptyString
                        onTriggered: App.plugins.updateMgr.update(model.uuid)
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
                visible: model.updating

                BaseLabel
                {
                    text: qsTr("Updating...") + App.loc.emptyString
                }

                DownloadsItemProgressIndicator
                {
                    infinityIndicator: true
                    Layout.preferredHeight: smallPage ? 6 : 10
                    Layout.preferredWidth: 150
                }
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
                Layout.leftMargin: 10
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
}
