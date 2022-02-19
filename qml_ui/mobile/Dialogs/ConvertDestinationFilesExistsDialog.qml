import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0
import "../BaseElements"

Dialog
{
    id: root

    closePolicy: Popup.NoAutoClose

    property int taskId
    property var files: []

    property int recommendedWidth: 0
    property int recommendedHeight: 0

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    width: Math.min(Math.round(appWindow.width * 0.8), recommendedWidth)
    height: Math.min(Math.round(appWindow.height * 0.8), recommendedHeight)

    modal: true

    title: qsTr("Destination files already exists") + App.loc.emptyString

    contentItem: ColumnLayout
    {
        width: root.width

        Flickable
        {
            clip: true

            Layout.fillWidth: true
            Layout.fillHeight: true

            contentWidth: filesLabel.contentWidth
            contentHeight: filesLabel.contentHeight

            BaseLabel
            {
                id: filesLabel
                text: files.join("\n")
            }

            ScrollBar.vertical: ScrollBar {}
            ScrollBar.horizontal: ScrollBar {}
        }

        GridLayout
        {
            id: buttons

            Layout.alignment: Qt.AlignRight

            readonly property bool hasSpace: b1.implicitWidth + b2.implicitWidth + b3.implicitWidth + b4.implicitWidth + 30 <= root.width

            columns: hasSpace ?  -1 : 2
            rows: hasSpace ? 1 : -1

            DialogButton
            {
                id: b1
                text: qsTr("Overwrite All")
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileOverwrite))
            }

            DialogButton
            {
                id: b2
                text: qsTr("Rename All")
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileRename))
            }

            DialogButton
            {
                id: b3
                text: qsTr("Skip All")
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileSkip))
            }

            DialogButton
            {
                id: b4
                text: qsTr("Abort")
                onClicked: {
                    App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, [], true);
                    root.close();
                }
            }
        }
    }

    BaseLabel {id: label; visible: false}

    FontMetrics
    {
        id: fm
        font: label.font
    }

    onFilesChanged:
    {
        var w = Math.max(200, b1.width + b2.width + b3.width + b4.width + 5*3 + 35);
        var h = Math.max(180, 90 + buttons.height + 35);

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + 90);
            h += fm.font.pixelSize + 2;
        }

        root.recommendedWidth = w;
        root.recommendedHeight = h;
    }

    function doRespond(of)
    {
        App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, of, false);
        root.close();
    }
}
