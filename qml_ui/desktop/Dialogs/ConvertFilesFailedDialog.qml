import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

BaseDialog
{
    id: root

    property var files: []

    property int recommendedWidth: 0
    property int recommendedHeight: 0

    contentItem: BaseDialogItem
    {
        titleText: qsTr("Failed to convert") + App.loc.emptyString
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

            CustomButton
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
        var w = 300, h = 110;

        for (var i = 0; i < files.length; ++i)
        {
            w = Math.max(w, fm.advanceWidth(files[i]) + 10);
            h += fm.font.pixelSize + 2;
        }

        root.recommendedWidth = w;
        root.recommendedHeight = h;
    }
}
