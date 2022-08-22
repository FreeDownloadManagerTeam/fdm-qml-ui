import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import org.freedownloadmanager.fdm 1.0
import "BaseElements"
import "../common/Tools"

Page
{
    id: root

    property double downloadId: 0
    property int fileIndex: 0

    RenameDownloadFileTools {
        id: tools
        newNameField: newNameField
        onFinished: stackView.pop()
    }

    Component.onCompleted: {
        tools.initialize(root.downloadId, root.fileIndex);
        newNameField.forceActiveFocus();
    }

    header: Column
    {
        BaseToolBar {
            RowLayout {
                anchors.fill: parent

                ToolbarBackButton {
                    onClicked: stackView.pop()
                }

                ToolbarLabel {
                    text: qsTr("Rename file") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                DialogButton {
                    text: qsTr("OK") + App.loc.emptyString
                    Layout.rightMargin: 10
                    textColor: appWindow.theme.toolbarTextColor
                    enabled: !tools.renaming && (tools.canBeRenamed || !tools.hasChanges)
                    onClicked: tools.doOK()
                }
            }
        }

        ToolBarShadow {}
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 2

        BaseLabel {
            Layout.topMargin: 20
            text: qsTr("Enter new name") + ':' + App.loc.emptyString
        }

        TextField {
            id: newNameField
            selectByMouse: true
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            focus: true
            Layout.fillWidth: true
        }

        BaseLabel
        {
            visible: tools.alreadyExistsError
            text: qsTr("A file with that name already exists.") + App.loc.emptyString
            color: appWindow.theme.errorMessage
        }

        BaseLabel
        {
            visible: tools.error
            text: tools.error
            color: appWindow.theme.errorMessage
        }
    }
}
