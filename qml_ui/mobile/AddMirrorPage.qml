import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import QtQuick.Controls.Material 2.4
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
                    Layout.rightMargin: 10
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

            TextField {
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
