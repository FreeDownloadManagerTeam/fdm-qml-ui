import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common/Tools"
import "../BaseElements"

Dialog {
    id: root

    property string path

    width: Math.round(parent.width * 0.8)
    parent: Overlay.overlay
    anchors.centerIn: parent
    modal: true

    title: qsTr("Create folder") + App.loc.emptyString

    contentItem: ColumnLayout {
        spacing: 5
        width: parent.width

        BaseTextField {
            id: folderName
            selectByMouse: true
            Layout.preferredWidth: parent.width
            focus: true
            onAccepted: accept()
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
            enable_QTBUG_110471_workaround_2: true
        }

        RowLayout {
        spacing: 5
        Layout.alignment: Qt.AlignHCenter

            DialogButton
            {
                text: qsTr("OK") + App.loc.emptyString
                enabled: folderName.displayText.length > 0
                onClicked: accept()
            }

            DialogButton
            {
                text: qsTr("Cancel") + App.loc.emptyString
                onClicked: root.close()
            }
        }
    }

    function accept() {
        App.tools.createLocalFolder(path + '/' + folderName.displayText);
        root.close();
    }

    function openDialog(currentPath) {
        path = currentPath;
        folderName.text = "";
        root.open();
        folderName.forceActiveFocus()
    }
}
