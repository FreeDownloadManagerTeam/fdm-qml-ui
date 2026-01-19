import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

import "../common"
import "./BaseElements"

ExtraToolBar {
    id: root
    Rectangle {
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.right: groupOperationsBtn.left
        color: "transparent"

        Row {
            id: filtersBar
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            spacing: 10
            MainFilterButton {
                id: btn1
                text: qsTr("All") + App.loc.emptyString
                value: 0
            }
            MainFilterButton {
                id: btn2
                text: qsTr("Active") + App.loc.emptyString
                value: AbstractDownloadsUi.FilterRunning
            }
            MainFilterButton {
                id: btn3
                text: qsTr("Completed") + App.loc.emptyString
                value: AbstractDownloadsUi.FilterFinished
            }

            Component.onCompleted: setBtnsSpacing();
        }
    }
    //Sort menu button
    ToolbarButton {
        id: groupOperationsBtn
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        icon.source: Qt.resolvedUrl("../images/mobile/sort_menu.svg")
        onClicked: selectSortFieldDialog.open()
    }

    TextMetrics {
        id: textMetrics
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
    }

    onWidthChanged: root.setBtnsSpacing()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.setBtnsSpacing()
    }

    function setBtnsSpacing() {
        textMetrics.text = btn1.text;
        var btnsWidth = textMetrics.width;
        textMetrics.text = btn2.text;
        btnsWidth += textMetrics.width;
        textMetrics.text = btn3.text;
        btnsWidth += textMetrics.width;

        var maxWidth = root.width - groupOperationsBtn.width - 10;
        var maxSpacing = 30;
        filtersBar.spacing = Math.min(Math.max(5, Math.floor((maxWidth - btnsWidth) / 2)), maxSpacing);
    }
}
