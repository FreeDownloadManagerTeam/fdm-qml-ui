import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
import "BaseElements"
import "../common/Tools"

Page {
    property var downloadModel

    header: Column {
        height: 108
        width: parent.width

        BaseToolBar {
            RowLayout {
                anchors.fill: parent

                ToolbarBackButton {
                    onClicked: stackView.pop()
                }

                ToolbarLabel {
                    text: qsTr("Change download URL") + App.loc.emptyString
                    Layout.fillWidth: true
                }

                DialogButton {
                    text: qsTr("OK") + App.loc.emptyString
                    Layout.rightMargin: qtbug.rightMargin(0, 10)
                    Layout.leftMargin: qtbug.leftMargin(0, 10)
                    textColor: appWindow.theme.toolbarTextColor
                    enabled: newUrl.displayText.length > 0
                    onClicked: doOK()
                }
            }
        }

        ToolBarShadow {}

        ExtraToolBar {
            Rectangle {
                color: "transparent"
                anchors.fill: parent
                anchors.leftMargin: 20

                BaseLabel {
                    text: downloadModel.title + " " + App.bytesAsText(downloadModel.size) + App.loc.emptyString
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideMiddle
                }
            }
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 2
        anchors.margins: 20

        BaseLabel {
            Layout.topMargin: 20
            text: qsTr("Enter new URL") + App.loc.emptyString
        }

        BaseTextField {
            id: newUrl
            selectByMouse: true
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            onAccepted: doOK()
            focus: true
            wrapMode: TextInput.WrapAnywhere
            Layout.fillWidth: true
            Layout.maximumHeight: appWindow.height/2
        }

        BaseLabel
        {
            visible: downloadModel.destinationPath
            text: qsTr("File location: %1").arg(downloadModel.destinationPath)
            width: parent.width
            elide: Text.ElideMiddle
        }

        BaseCheckBox {
            id: startDownload
            text: qsTr("Start download") + App.loc.emptyString
            enabled: !downloadModel.running && !downloadModel.finished
            checked: true
            opacity: enabled ? 1 : 0.5
        }
    }

    Component.onCompleted: {
        newUrl.text = downloadModel.resourceUrl;
        newUrl.select(newUrl.text.length, 0);
        newUrl.forceActiveFocus();
    }

    function doOK()
    {
        var user_input = newUrl.text.trim();
        var urlTools = App.tools.url(user_input)
        if (urlTools.correctUserInput()) {
            user_input = urlTools.url
        }
        App.downloads.infos.info(downloadModel.id).resourceUrl = user_input;
        if (startDownload.checked && !downloadModel.running && !downloadModel.finished) {
            App.downloads.mgr.startDownload(downloadModel.id, true);
        }
        stackView.pop();
    }
}
