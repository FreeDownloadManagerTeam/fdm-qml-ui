import QtQuick 2.0
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../BaseElements"
import "../../../qt5compat"

import Qt.labs.platform 1.0 as QtLabs

ColumnLayout {
    property alias path: combo.editText

    RowLayout {
        width: parent.width

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
        height: folderBtn.height + 1
        width: parent.width

        FolderCombobox {
            id: combo
            Layout.fillWidth: true
            Layout.preferredHeight: height
            onAccepted: tuneDialog.doOK()
            onEditTextChanged: {
                downloadTools.wrongFilePathWarning = false;
            }
        }

        CustomButton {
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
            QtLabs.FolderDialog {
                id: browseDlg
                folder: App.tools.urlFromLocalFile(downloadTools.filePath).url
                acceptLabel: qsTr("Open") + App.loc.emptyString
                rejectLabel: qsTr("Cancel") + App.loc.emptyString
                onAccepted: setPath(App.tools.url(folder).toLocalFile())
            }
        }
    }

    function initialization() {
        var folderList = App.recentFolders;
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

    Connections {
        target: tuneDialog
        onActiveFocusChanged: { if (tuneDialog.activeFocus) { combo.forceActiveFocus() } }
    }
}
