import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../BaseElements"
import org.freedownloadmanager.fdm

BaseDialog
{
    id: root

    property var files: []

    property int recommendedWidth: 0
    property int recommendedHeight: 0

    title: qsTr("Failed to convert") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem
    {
        focus: true
        Keys.onEscapePressed: root.close()

        ColumnLayout
        {
            Layout.fillWidth: true
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

            BaseButton
            {
                text: qsTr("OK")
                blueBtn: true
                onClicked: root.close()
                Layout.alignment: Qt.AlignRight
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
        var w = 300*appWindow.zoom,
        h = contentItem.implicitHeight + header.implicitHeight + root.topPadding + root.bottomPadding;

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + root.leftPadding + root.rightPadding);
            h += fm.height;
        }

        root.recommendedWidth = w;
        root.recommendedHeight = h;
    }
}
