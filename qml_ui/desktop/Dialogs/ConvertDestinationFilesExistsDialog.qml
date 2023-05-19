import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

BaseDialog
{
    id: root

    property int taskId
    property var files: []

    property int recommendedWidth: 0
    property int recommendedHeight: 0

    contentItem: BaseDialogItem
    {
        titleText: qsTr("Destination files already exists") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.doAbort()
        onCloseClick: root.doAbort()

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            Layout.bottomMargin: 10*appWindow.zoom
            spacing: 10*appWindow.zoom

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

                CustomButton
                {
                    text: qsTr("Overwrite All") + App.loc.emptyString
                    blueBtn: true
                    onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileOverwrite))
                }

                CustomButton
                {
                    text: qsTr("Rename All") + App.loc.emptyString
                    blueBtn: true
                    onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileRename))
                }

                CustomButton
                {
                    text: qsTr("Skip All") + App.loc.emptyString
                    blueBtn: true
                    onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileSkip))
                }

                CustomButton
                {
                    text: qsTr("Abort") + App.loc.emptyString
                    onClicked: root.doAbort()
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
        var w = Math.max(300*appWindow.zoom, buttons.width + 35*appWindow.zoom), h = 110*appWindow.zoom;

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + 10*appWindow.zoom);
            h += fm.font.pixelSize + 2*appWindow.zoom;
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
