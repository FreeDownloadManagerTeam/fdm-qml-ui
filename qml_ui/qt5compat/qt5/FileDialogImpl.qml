import QtQuick 2.12
import Qt.labs.platform 1.1 as QtLabs

QtLabs.FileDialog
{
    id: root

    property alias selectedFile: root.file
    property alias currentFolder: root.folder
}
