import QtQuick 2.0
import org.freedownloadmanager.fdm 1.0
import "../../../common/Tools"
import "../../BaseElements"

BaseLabel {
    property string saveToPath

    visible: downloadTools.fileSize >= 0 || downloadTools.freeDiskSpace >= 0

    color: downloadTools.notEnoughSpaceWarning ? appWindow.theme.errorMessage : "#737373"

    text: ((downloadTools.freeDiskSpace >= 0 && downloadTools.fileSize >= 0) ?
              qsTr("Size: %1 (Disk space: %2)").arg(App.bytesAsText(downloadTools.fileSize)).arg(App.bytesAsText(downloadTools.freeDiskSpace)) :
              downloadTools.freeDiskSpace >= 0 ? qsTr("Disk space: %1").arg(App.bytesAsText(downloadTools.freeDiskSpace)) :
              downloadTools.fileSize >= 0 ? qsTr("Size: %1").arg(App.bytesAsText(downloadTools.fileSize)) :
              "") + App.loc.emptyString

    onSaveToPathChanged: {
        App.storages.queryBytesAvailable(saveToPath);
        App.storages.queryIfHasWriteAccess(saveToPath);
    }

    Connections {
        target: App.storages
        onBytesAvailableResult: (path, available) => {
            if (path == saveToPath) {
                downloadTools.freeDiskSpace = available;
            }
        }
        onHasWriteAccessResult: (path, result) => {
            if (path == saveToPath) {
                downloadTools.hasWriteAccess = result;
            }
        }
    }
}
