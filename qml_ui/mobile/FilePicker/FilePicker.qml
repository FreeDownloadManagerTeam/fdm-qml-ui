import QtQuick

Item {
    id: root

    property Component filePickerPageComponent: pageComponent

    signal folderSelected(string folderName, int downloadId, string initiator)
    signal fileSelected(string fileName)
    signal resetFolder(string folderName)

    Component {
        id: pageComponent
        FilePickerPage {}
    }
}
