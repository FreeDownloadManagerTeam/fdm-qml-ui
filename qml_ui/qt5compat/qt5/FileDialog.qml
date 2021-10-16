import QtQuick 2.0
import QtQuick.Dialogs 1.3

FileDialog
{
    readonly property int modeOpenFile: 1
    readonly property int modeOpenFiles: 2
    readonly property int modeSaveFile: 3

    property int fileMode: modeOpenFile

    selectExisting: fileMode === modeOpenFile
    selectMultiple: fileMode === modeOpenFiles
}
