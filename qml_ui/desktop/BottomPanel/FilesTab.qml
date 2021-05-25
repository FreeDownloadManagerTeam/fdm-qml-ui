import QtQuick 2.0
import "../FilesTree"

Item {

    anchors.fill: parent

    FilesTree {
        downloadItemId: downloadsItemTools.itemId
        downloadInfo: downloadsItemTools.item
    }

}
