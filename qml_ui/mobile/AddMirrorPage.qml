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
                    text: qsTr("Add mirror") + App.loc.emptyString
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
                    text: downloadModel.title
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
            text: qsTr("Enter mirror URL") + App.loc.emptyString
        }

        Rectangle {
            width: parent.width
            height: newUrl.height
            color: "transparent"

           BaseTextField {
                id: newUrl
                anchors {
                    left: parent.left
                    right: parent.right
                }
                selectByMouse: true
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                onAccepted: doOK()
                focus: true
            }
        }
    }

    function doOK()
    {
        var user_input = newUrl.text.trim();
        var urlTools = App.tools.url(user_input)
        if (urlTools.correctUserInput()) {
            user_input = urlTools.url
        }

        App.downloads.infos.info(downloadModel.id).addMirrorUrl(user_input);

        stackView.pop();
    }
}
