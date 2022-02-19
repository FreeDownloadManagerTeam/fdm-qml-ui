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
        Keys.onEscapePressed: root.close()
        onCloseClick: root.close()

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.bottomMargin: 10
            spacing: 10

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
                    text: qsTr("Overwrite All")
                    blueBtn: true
                    onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileOverwrite))
                }

                CustomButton
                {
                    text: qsTr("Rename All")
                    blueBtn: true
                    onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileRename))
                }

                CustomButton
                {
                    text: qsTr("Skip All")
                    blueBtn: true
                    onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileSkip))
                }

                CustomButton
                {
                    text: qsTr("Abort")
                    onClicked: {
                        App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, [], true);
                        root.close();
                    }
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
        var w = Math.max(300, buttons.width + 35), h = 110;

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + 10);
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
