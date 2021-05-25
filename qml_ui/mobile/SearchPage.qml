import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import "../common"
import "./BaseElements"

Page {
    id: root

    header: Column {
        id: toolbar
        height: 108
        width: root.width

        Rectangle
        {
            id: searchToolbar
            width: parent.width
            height: 60

            RoundButton {
                id: backbtn
                radius: 60
                width: 60
                height: 60
                flat: true
                //anchors.left: parent.left
                onClicked: {
                    stackView.pop();
                }

                icon.source: Qt.resolvedUrl("../images/arrow_back.svg")
                icon.color: "#585759"
            }

            TextField
            {
                id: searchText
                width: parent.width - backbtn.width - 40
                placeholderText: qsTr("Search") + App.loc.emptyString
                font.family: "Roboto"
                anchors.left: backbtn.right
                anchors.verticalCenter: parent.verticalCenter
                EnterKey.type: Qt.EnterKeySearch
                Layout.fillWidth: true
                selectByMouse: true
                focus: true
                color: "#4c4c4c"
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData

                Material.accent: Material.Blue

                onTextChanged: downloadsViewTools.setDownloadsTitleFilter(text)
            }

            Rectangle {
                id: closebtn
                visible: searchText.text.length > 0
                width: 40
                height: 60
                anchors.left: searchText.right
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    x: 0
                    anchors.verticalCenter: parent.verticalCenter
                    width: 25
                    height: 25

                    source: Qt.resolvedUrl("../images/close.svg")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked:  {
                        searchText.text = ''
                        searchText.forceActiveFocus()
                        foundResult.text = ''
                    }
                }
            }
        }

        MainFiltersBar {
            height: 48
            width: parent.width
        }
    }

    Rectangle {
        id: downloadPageBackground
        anchors.fill: parent
        color: appWindow.showBordersInDownloadsList ? "#ededed" : "#ffffff"
    }

    DownloadsView {
        visible: downloadsViewTools.downloadsTitleFilter.length > 0
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        visible: downloadsViewTools.downloadsRowsCount === 0 && downloadsViewTools.downloadsTitleFilter.length > 0

        Rectangle {
            color: "silver"
            width: parent.width
            height: 1
        }

        BaseLabel {
            id: foundResult
            text: qsTr("No results found for") + App.loc.emptyString + " \"<b>" + downloadsViewTools.downloadsTitleFilter + "</b>\""
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: downloadsViewTools.downloadsTitleFilter.length === 0

        Rectangle {
            color: "silver"
            width: parent.width
            height: 1
        }
    }

    Component.onDestruction: {
        resetFilter();
    }

    function resetFilter()
    {
        downloadsViewTools.resetDownloadsTitleFilter();
    }
}
