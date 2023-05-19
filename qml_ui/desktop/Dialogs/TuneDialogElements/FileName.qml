import QtQuick 2.12
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1
import "../../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"
import "../../../common"

ColumnLayout {
    id: root

    property var saveToControl: null
    readonly property bool isSubFolder: downloadTools.batchDownload

    visible: downloadTools.filesCount === 1 || downloadTools.batchDownload

    //file name / create subfolder
    BaseLabel {
        Layout.topMargin: 6*appWindow.zoom
        text: (root.isSubFolder ? qsTr("Create subfolder") : qsTr("File name")) + App.loc.emptyString
    }

    RowLayout {
        Layout.fillWidth: true

        BaseTextField {
            id: fileName
            Layout.fillWidth: true
            text: downloadTools.fileName
            onTextChanged: downloadTools.onFileNameTextChanged(text)
            onAccepted: tuneDialog.doOK()
        }

        PickFileButton {
            visible: !root.isSubFolder && uiSettingsTools.settings.showSaveAsButton && saveToControl !== null
            id: folderBtn
            Layout.alignment: Qt.AlignRight
            Layout.fillHeight: true
            onClicked: browseDlg.open()
            FileDialog {
                readonly property string currentFileSuffix: fileName.text.lastIndexOf('.') !== -1 ? fileName.text.substring(fileName.text.lastIndexOf('.')+1) : ""
                id: browseDlg
                fileMode: FileDialog.SaveFile
                defaultSuffix: currentFileSuffix
                nameFilters: currentFileSuffix ? [qsTr("%1 files (*.%2)").arg(currentFileSuffix.toUpperCase()).arg(currentFileSuffix) + App.loc.emptyString] :
                                                 [qsTr("All files") + " (*)" + App.loc.emptyString]
                onAccepted: {
                    saveToControl.setPath(App.tools.url(folder).toLocalFile());
                    var str = file.toString();
                    fileName.text = str.substring(str.lastIndexOf('/')+1);
                    downloadTools.forceOverwriteFile = true;
                }
            }
        }
    }

    function init()
    {
        fileName.text = downloadTools.fileName;
        browseDlg.folder = Qt.binding(function() {return App.tools.urlFromLocalFile(saveToControl.path).url;});
    }
}
