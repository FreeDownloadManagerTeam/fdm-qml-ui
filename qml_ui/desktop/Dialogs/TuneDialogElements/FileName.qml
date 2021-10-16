import QtQuick 2.12
import QtQuick.Layouts 1.3
import "../../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"

ColumnLayout {
    property var saveToControl: null

    visible: downloadTools.filesCount === 1 || downloadTools.batchDownload

    //file name / create subfolder
    BaseLabel {
        Layout.topMargin: 6
        text: (downloadTools.batchDownload ? qsTr("Create subfolder") : qsTr("File name")) + App.loc.emptyString
    }

    RowLayout {
        height: folderBtn.height + 1
        width: parent.width

        BaseTextField {
            id: fileName
            Layout.fillWidth: true
            text: downloadTools.fileName
            onTextChanged: downloadTools.onFileNameTextChanged(text)
            onAccepted: tuneDialog.doOK()
        }

        CustomButton {
            visible: uiSettingsTools.settings.showSaveAsButton && saveToControl !== null
            id: folderBtn
            implicitWidth: 38
            implicitHeight: 30
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: height
            Image {
                source: Qt.resolvedUrl("../../../images/desktop/pick_file.svg")
                sourceSize.width: 37
                sourceSize.height: 30
                layer {
                    effect: ColorOverlay {
                        color: folderBtn.isPressed ? folderBtn.secondaryTextColor : folderBtn.primaryTextColor
                    }
                    enabled: true
                }
            }

            onClicked: browseDlg.open()
            FileDialog {
                readonly property string currentFileSuffix: fileName.text.lastIndexOf('.') !== -1 ? fileName.text.substring(fileName.text.lastIndexOf('.')+1) : ""
                id: browseDlg
                fileMode: modeSaveFile
                defaultSuffix: currentFileSuffix
                nameFilters: currentFileSuffix ? [qsTr("%1 files (*.%2)").arg(currentFileSuffix.toUpperCase()).arg(currentFileSuffix) + App.loc.emptyString] :
                                                 [qsTr("All files") + " (*)" + App.loc.emptyString]
                onAccepted: {
                    saveToControl.setPath(App.tools.url(folder).toLocalFile());
                    var str = fileUrl.toString();
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
