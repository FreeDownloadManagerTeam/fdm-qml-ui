import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

ColumnLayout {
    spacing: 8

    property color selectedColor

    signal closeTagColorDialog()
    signal colorSelected(color selectedColor)

    Column {
        spacing: 6
        Layout.alignment: Qt.AlignHCenter

        Rectangle {
            width: 12
            height: 12
            color: selectedColor
        }

        GridLayout {
            columns: 6
            rowSpacing: 6
            columnSpacing: 6
            Repeater {
                model: tagsTools.defaultColors
                Rectangle {
                    width: 12
                    height: 12
                    color: modelData

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            changeSelectedColor(modelData);
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: lbl.contentHeight + 4
        color: removeBtnMouseArea.containsMouse ? appWindow.theme.menuHighlight : "transparent"

        Label {
            id: lbl
            text: qsTr("Customize color") + App.loc.emptyString
            width: parent.width
            wrapMode: Label.Wrap
            leftPadding: 10
            rightPadding: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: removeBtnMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                colorDialog.open();
            }
        }
    }

    ColorDialog {
        id: colorDialog
        color: selectedColor
        showAlphaChannel: false
        onAccepted: changeSelectedColor(colorDialog.color)
    }

    function changeSelectedColor(color) {
        selectedColor = color;
        colorSelected(selectedColor);
        closeTagColorDialog()
    }
}
