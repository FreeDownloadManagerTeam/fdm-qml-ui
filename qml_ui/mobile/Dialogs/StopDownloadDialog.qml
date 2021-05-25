import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    property var downloadIds: []
    property int singleMode: downloadIds.length == 1

    signal downloadsRemoved()

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    width: Math.round(appWindow.width * 0.8)

    contentItem: ColumnLayout {
        width: parent.width

        Rectangle {
            Layout.fillWidth: true
            Layout.bottomMargin: 20
            height: title.height
            color: "transparent"

            BaseLabel {
                id: title
                adaptive: true
                labelSize: adaptiveTools.labelSize.highSize
                text: (singleMode ? qsTr("This download can't be resumed after pausing") : qsTr("The download(s) below can't be resumed after pausing")) + App.loc.emptyString
                wrapMode: Label.Wrap
                font.weight: Font.Bold
                width: parent.width
            }
        }

        ListView {
            id: listView
            clip: true
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 150)
            ScrollBar.vertical: ScrollBar {
                active: parent.contentHeight > 150
            }
            model: root.downloadIds
            delegate: Rectangle {
                width: parent.width
                height: lbl.height
                color: 'transparent'

                BaseLabel {
                    id: lbl
                    visible: downloadsItemTools.tplPathAndTitle.length > 0
                    width: parent.width
                    elide: Text.ElideMiddle
                    color: "#737373"
                    DownloadsItemTools {
                        id: downloadsItemTools
                        itemId: root.downloadIds[index]
                    }
                    text: downloadsItemTools.hasChildDownloads ? downloadsItemTools.destinationPath : downloadsItemTools.tplPathAndTitle
                }
            }
        }

        RowLayout {
            DialogButton
            {
                text: qsTr("Pause") + App.loc.emptyString
                onClicked: {
                    selectedDownloadsTools.stopByIds(downloadIds);
                    root.close();
                    downloadsRemoved();
                }
            }

            DialogButton
            {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: root.close()
            }
        }
    }

    function show(ids)
    {
        console.log("show(ids)", ids);
        root.downloadIds = ids;
        root.open();
    }
}
