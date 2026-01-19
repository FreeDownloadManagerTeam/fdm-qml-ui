import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.freedownloadmanager.fdm

Item {
    implicitWidth: core.implicitWidth
    implicitHeight: core.implicitHeight

    property alias selectedColor: colorDialog.selectedColor

    signal closeTagColorDialog()
    signal colorSelected(color selectedColor)

    ColumnLayout {
        id: core

        spacing: 8*appWindow.zoom

        component TagRectangle : Rectangle {
            implicitWidth: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.tagSquareSize)*appWindow.zoom
            implicitHeight: (appWindow.uiver === 1 ? 12 : appWindow.theme_v2.tagSquareSize)*appWindow.zoom
            radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom
        }

        TagRectangle {
            visible: appWindow.uiver === 1
            color: selectedColor
        }

        GridLayout {
            columns: 6
            rowSpacing: 6*appWindow.zoom
            columnSpacing: 6*appWindow.zoom
            Repeater {
                model: tagsTools.defaultColors
                TagRectangle {
                    color: modelData
                    MouseArea {
                        anchors.fill: parent
                        onClicked: changeSelectedColor(modelData)
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitWidth: lbl.implicitWidth
            implicitHeight: lbl.implicitHeight
            color: removeBtnMouseArea.containsMouse ? appWindow.theme.menuHighlight : "transparent"

            BaseLabel {
                id: lbl
                text: qsTr("Customize color") + App.loc.emptyString
                anchors.centerIn: parent
                font.pixelSize: 13*appWindow.fontZoom
            }

            MouseArea {
                id: removeBtnMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: colorDialog.open()
            }
        }
    }

    ColorDialog {
        id: colorDialog
        onAccepted: changeSelectedColor(colorDialog.selectedColor)
    }

    function changeSelectedColor(color) {
        selectedColor = color;
        colorSelected(selectedColor);
        closeTagColorDialog()
    }
}
