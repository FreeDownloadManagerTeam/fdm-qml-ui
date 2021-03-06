import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import "../../../common/Tools"
import "../../BaseElements"

BaseLabel {
    property string saveToPath

    visible: downloadTools.fileSize >= 0
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    color: downloadTools.notEnoughSpaceWarning ? appWindow.theme.errorMessage : "#737373"
    text: (downloadTools.freeDiskSpace != -1 ?
              qsTr("Size: %1 (Disk space: %2)").arg(JsTools.sizeUtils.bytesAsText(downloadTools.fileSize)).arg(JsTools.sizeUtils.bytesAsText(downloadTools.freeDiskSpace < 0 ? 0 : downloadTools.freeDiskSpace)) :
              qsTr("Size: %1").arg(JsTools.sizeUtils.bytesAsText(downloadTools.fileSize))) + App.loc.emptyString

    onSaveToPathChanged: {
        App.storages.queryBytesAvailable(saveToPath);
        App.storages.queryIfHasWriteAccess(saveToPath);
    }

    Connections {
        target: App.storages
        onBytesAvailableResult: {
            if (path == saveToPath) {
                downloadTools.freeDiskSpace = available;
            }
        }
        onHasWriteAccessResult: {
            if (path == saveToPath) {
                downloadTools.hasWriteAccess = result;
            }
        }
    }
}
