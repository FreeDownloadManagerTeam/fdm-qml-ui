import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    property string dialogTitle
    property string filePath
    property string errorMessage

    width: 542*appWindow.zoom

    contentItem: BaseDialogItem {
        titleText: dialogTitle
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10*appWindow.zoom
            Layout.rightMargin: 10*appWindow.zoom
            spacing: 3*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("Error: %1").arg(errorMessage) + App.loc.emptyString
                Layout.bottomMargin: 7*appWindow.zoom
            }

            BaseLabel {
                id: lbl
                Layout.fillWidth: true
                elide: Text.ElideMiddle
                color: "#737373"
                text: filePath
            }

            CustomButton {
                Layout.topMargin: 10*appWindow.zoom
                Layout.bottomMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight
                blueBtn: true
                text: qsTr("OK") + App.loc.emptyString
                onClicked: root.close()
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }

    onClosed: {
        errorMessage = "";
        filePath = "";
    }

    Connections {
        target: App
        onImportListOfUrlsFromFileFailed: {
            if (!root.opened) {
                dialogTitle = qsTr("Failure to paste URLs from the file") + App.loc.emptyString;
                filePath = file;
                errorMessage = errDesc;
                root.open();
            }
        }
    }

    Connections {
        target: App
        onImportListOfUrlsFromFileFailed: {
            if (!root.opened) {
                dialogTitle = qsTr("Failure to paste URLs from the file") + App.loc.emptyString;
                filePath = qsTr("Unable to import the list of URLs from the file: %1").arg(file) + App.loc.emptyString
                errorMessage = errDesc;
                root.open();
            }
        }
    }

    Connections {
        target: App.exportImport
        onExportFinished: {
            if (!root.opened && error.length > 0) {
                dialogTitle = qsTr("Failure to export") + App.loc.emptyString;
                filePath = qsTr("Unable to export to the file: %1").arg(file) + App.loc.emptyString
                errorMessage = error;
                root.open();
            }
        }
        onImportFinished: {
            if (!root.opened && error.length > 0) {
                dialogTitle = qsTr("Failure to import") + App.loc.emptyString;
                filePath = qsTr("Unable to import from the file: %1").arg(file) + App.loc.emptyString
                errorMessage = error;
                root.open();
            }
        }
    }
}
