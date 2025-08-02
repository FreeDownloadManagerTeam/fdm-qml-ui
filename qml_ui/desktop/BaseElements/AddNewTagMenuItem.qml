import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "V2"

Item {
    anchors.left: parent.left
    anchors.leftMargin: parent.leftPadding
    anchors.right: parent.right
    anchors.rightMargin: 5*appWindow.zoom

    implicitWidth: visible ? (addNewTagBlock.implicitWidth + anchors.leftMargin + anchors.rightMargin) : 0
    implicitHeight: visible ? addNewTagBlock.implicitHeight : 0

    RowLayout {
        id: addNewTagBlock

        anchors.fill: parent

        spacing: 8*appWindow.zoom

        BaseTextField {
            id: newTagText
            Layout.fillWidth: true
            placeholderText: qsTr("Add tag") + App.loc.emptyString
            placeholderTextColor: appWindow.theme_v2.placeholderTextColor
            onAccepted: doAddNewTag()
        }

        SvgImage_V2 {
            source: Qt.resolvedUrl("../V2/plus_icon.svg")
            imageColor: appWindow.theme_v2.primary
            MouseAreaWithHand_V2 {
                anchors.fill: parent
                onClicked: doAddNewTag()
            }
        }
    }

    function doAddNewTag() {
        let t = newTagText.text;
        newTagText.text = "";
        tagsTools.addTag(t);
    }
}
