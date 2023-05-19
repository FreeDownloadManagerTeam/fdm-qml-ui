import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Dialog
{
    id: root

    property var files: []

    property int recommendedWidth: 0
    property int recommendedHeight: 0

    parent: Overlay.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    width: Math.min(Math.round(appWindow.width * 0.8), recommendedWidth)
    height: Math.min(Math.round(appWindow.height * 0.8), recommendedHeight)

    modal: true

    title: qsTr("Convert failed") + App.loc.emptyString

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

        DialogButton
        {
            text: qsTr("OK") + App.loc.emptyString
            Layout.alignment: Qt.AlignRight
            onClicked: root.close()
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
        var w = 200, h = 180;

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + 10);
            h += fm.font.pixelSize + 2;
        }

        root.recommendedWidth = w;
        root.recommendedHeight = h;
    }
}
