import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"
import "../../../qt5compat"
import "../../../common"

import Qt.labs.platform 1.0 as QtLabs

FocusScope
{
    property alias path: combo.editText

    implicitWidth: contentRoot.implicitWidth
    implicitHeight: contentRoot.implicitHeight

    ColumnLayout {
        id: contentRoot

        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true

            BaseLabel {
                text: qsTr("Save to") + App.loc.emptyString
                Layout.fillWidth: true
            }

            TagLabel {
                visible: downloadTools.relatedTag ? true : false
                tag: downloadTools.relatedTag
                Layout.preferredWidth: width
            }
        }

        RowLayout {
            Layout.fillWidth: true

            FolderCombobox {
                id: combo
                focus: true
                Layout.fillWidth: true
                onAccepted: tuneDialog.doOK()
                onEditTextChanged: {
                    downloadTools.wrongFilePathWarning = false;
                }
                onFolderRemoved: path => App.recentFolders.removeFolder(path)
            }

            PickFileButton {
                visible: !App.rc.client.active
                id: folderBtn
                Layout.alignment: Qt.AlignRight
                Layout.fillHeight: true
                onClicked: browseDlg.open()
                QtLabs.FolderDialog {
                    id: browseDlg
                    folder: App.tools.urlFromLocalFile(downloadTools.filePath).url
                    acceptLabel: qsTr("Open") + App.loc.emptyString
                    rejectLabel: qsTr("Cancel") + App.loc.emptyString
                    onAccepted: setPath(App.tools.url(folder).toLocalFile())
                }
            }
        }
    }

    function initialization() {
        var folderList = App.recentFolders.list;
        combo.model.clear();

        if (!folderList.length) {
            folderList = [];
            folderList.push(downloadTools.filePath);
        }

        for (var i = 0; i < folderList.length; i++) {
            combo.model.insert(i, {'folder': folderList[i]});
        }

        combo.editText = App.toNativeSeparators(downloadTools.filePath);
    }

    function setPath(folder) {
        combo.editText = App.toNativeSeparators(folder);
    }
}
