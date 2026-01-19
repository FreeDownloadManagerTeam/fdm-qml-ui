import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../BaseElements"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 

BaseDialog
{
    id: root

    property int taskId
    property var files: []

    property int recommendedWidth: 0
    property int recommendedHeight: 0

    title: qsTr("Destination files already exists") + App.loc.emptyString
    onCloseClick: root.doAbort()

    contentItem: BaseDialogItem
    {
        focus: true
        Keys.onEscapePressed: root.doAbort()

        ListView
        {
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical: ScrollBar {}
            model: root.files
            delegate: BaseLabel
            {
                width: parent.width
                elide: Text.ElideMiddle
                text: modelData
            }
        }

        RowLayout
        {
            id: buttons

            Layout.alignment: Qt.AlignRight

            BaseButton
            {
                text: qsTr("Overwrite All") + App.loc.emptyString
                blueBtn: true
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileOverwrite))
            }

            BaseButton
            {
                text: qsTr("Rename All") + App.loc.emptyString
                blueBtn: true
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileRename))
            }

            BaseButton
            {
                text: qsTr("Skip All") + App.loc.emptyString
                blueBtn: true
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileSkip))
            }

            BaseButton
            {
                text: qsTr("Abort") + App.loc.emptyString
                onClicked: root.doAbort()
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
        var w = Math.max(300*appWindow.zoom, buttons.width + 35*appWindow.zoom),
        h = contentItem.implicitHeight + header.implicitHeight + root.topPadding + root.bottomPadding;

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + root.leftPadding + root.rightPadding);
            h += fm.height;
        }

        root.recommendedWidth = w;
        root.recommendedHeight = h;
    }

    function doRespond(of)
    {
        App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, of, false);
        root.close();
    }

    function doAbort()
    {
        App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, [], true);
        root.close();
    }
}
