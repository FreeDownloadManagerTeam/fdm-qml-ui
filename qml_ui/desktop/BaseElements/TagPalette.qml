import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

ColumnLayout {
    spacing: 8*appWindow.zoom

    property color selectedColor

    signal closeTagColorDialog()
    signal colorSelected(color selectedColor)

    Column {
        spacing: 6*appWindow.zoom
        Layout.alignment: Qt.AlignHCenter

        Rectangle {
            width: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.tagSquareSize)*appWindow.zoom
            height: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.tagSquareSize)*appWindow.zoom
            color: selectedColor
            radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom
        }

        GridLayout {
            columns: 6
            rowSpacing: 6*appWindow.zoom
            columnSpacing: 6*appWindow.zoom
            Repeater {
                model: tagsTools.defaultColors
                Rectangle {
                    width: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.tagSquareSize)*appWindow.zoom
                    height: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.tagSquareSize)*appWindow.zoom
                    color: modelData
                    radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom

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
        Layout.preferredHeight: lbl.contentHeight + 4*appWindow.zoom
        color: removeBtnMouseArea.containsMouse ? appWindow.theme.menuHighlight : "transparent"

        BaseLabel {
            id: lbl
            text: qsTr("Customize color") + App.loc.emptyString
            width: parent.width
            wrapMode: Label.Wrap
            leftPadding: 10*appWindow.zoom
            rightPadding: 10*appWindow.zoom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: (appWindow.uiver === 1 ? 11 : 13)*appWindow.fontZoom
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
