import QtQuick
import "../FilesTree"

Item {

    anchors.fill: parent

    FilesTree {
        downloadItemId: downloadsItemTools.itemId
        downloadInfo: downloadsItemTools.item
    }

}
