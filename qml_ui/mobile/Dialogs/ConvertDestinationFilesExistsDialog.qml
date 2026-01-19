import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.abstractdownloadsui 
import "../BaseElements"

Dialog
{
    id: root

    closePolicy: Popup.NoAutoClose

    readonly property int availWidth: appWindow.width*0.95

    property int taskId
    property var files: []

    parent: Overlay.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

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

            implicitHeight: filesLabel.implicitHeight
            implicitWidth: filesLabel.implicitWidth

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

            Layout.alignment: Qt.AlignLeft

            rowSpacing: 0
            columnSpacing: 0

            readonly property bool hasSpace4: b1.implicitWidth + b2.implicitWidth + b3.implicitWidth + b4.implicitWidth + 30 <= root.availWidth
            readonly property bool hasSpace2: b1.implicitWidth + b2.implicitWidth + 30 <= root.availWidth &&
                                              b3.implicitWidth + b4.implicitWidth + 30 <= root.availWidth

            columns: hasSpace4 ?  -1 : hasSpace2 ? 2 : 1
            rows: hasSpace4 ? 1 : -1

            DialogButton
            {
                id: b1
                text: qsTr("Overwrite All") + App.loc.emptyString
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileOverwrite))
            }

            DialogButton
            {
                id: b2
                text: qsTr("Rename All") + App.loc.emptyString
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileRename))
            }

            DialogButton
            {
                id: b3
                text: qsTr("Skip All") + App.loc.emptyString
                onClicked: doRespond(Array(files.length).fill(AbstractDownloadsUi.ExistingFileSkip))
            }

            DialogButton
            {
                id: b4
                text: qsTr("Abort") + App.loc.emptyString
                onClicked: {
                    App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, [], true);
                    root.close();
                }
            }
        }
    }

    function doRespond(of)
    {
        App.downloads.mgr.sumbitConvertFilesExistsReaction(taskId, of, false);
        root.close();
    }
}
