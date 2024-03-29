import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

RowLayout {
    visible: downloadTools.previewUrl

    //preview
    Image {
        id: img
        source: downloadTools.previewUrl
        sourceSize.width: 30*appWindow.zoom
        sourceSize.height: 30*appWindow.zoom
        width: 30*appWindow.zoom
        height: 30*appWindow.zoom
        fillMode: Image.PreserveAspectCrop
    }

    //title
    BaseLabel {
        text: downloadTools.fileName
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
        font.weight: Font.DemiBold
    }
}
