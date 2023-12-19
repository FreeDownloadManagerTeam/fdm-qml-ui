import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm 1.0
import "../../common"
import "../BaseElements"

CenteredDialog
{
    id: root

    property var requiredPermissions: []
    property var optionalPermissions: []

    readonly property bool missingRequiredPermissions: requiredPermissions.length > 0
    readonly property bool missingOptionalPermissions: optionalPermissions.length > 0

    modal: true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape

    title: qsTr("%1 is missing permissions").arg(App.shortDisplayName)

    contentItem: ColumnLayout
    {
        spacing: 10

        ColumnLayout
        {
            Repeater
            {
                model: root.requiredPermissions.concat(optionalPermissions)

                ColumnLayout
                {
                    RowLayout
                    {
                        spacing: 10

                        Label
                        {
                            text: App.osPermissionsMgr.permissionDisplayName(modelData) + App.loc.emptyString
                            font.bold: true
                        }

                        Label
                        {
                            visible: index < root.requiredPermissions.length
                            text: qsTr("(required)") + App.loc.emptyString
                            color: appWindow.theme.errorMessage
                            font.italic: true
                        }
                    }

                    Label
                    {
                        text: App.osPermissionsMgr.permissionRationaleText(modelData) + App.loc.emptyString
                        wrapMode: Label.Wrap
                        Layout.maximumWidth: appWindow.width*0.8
                    }
                }
            }
        }

        Label
        {
            text: qsTr("You can grant these permissions using the Application details screen within your system's settings.") + App.loc.emptyString
            wrapMode: Label.Wrap
            Layout.maximumWidth: appWindow.width*0.8
        }

        BaseCheckBox
        {
            visible: !root.missingRequiredPermissions
            text: qsTr("Don't show again") + App.loc.emptyString
            onClicked: uiSettingsTools.settings.dontShowOsPermissionsDialog = checked
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter

            DialogButton
            {
                text: qsTr("Grant permissions") + App.loc.emptyString
                onClicked: {
                    App.openAppOsPermissionsSettings();
                    root.close();
                }
            }

            DialogButton
            {
                text: (root.missingRequiredPermissions ? qsTr("Quit") : qsTr("Close")) + App.loc.emptyString
                onClicked: root.close()
            }
        }
    }

    onClosed: {
        if (root.missingRequiredPermissions)
            App.quit();
    }
}
