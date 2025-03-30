import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    property string filePath
    property string errorMessage

    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3*appWindow.zoom

            BaseLabel {
                Layout.fillWidth: true
                text: qsTr("Error: %1").arg(errorMessage) + App.loc.emptyString
                Layout.bottomMargin: 7*appWindow.zoom
                wrapMode: Label.WordWrap
            }

            BaseLabel {
                id: lbl
                Layout.fillWidth: true
                color: "#737373"
                text: filePath
                wrapMode: Label.Wrap
            }

            BaseButton {
                Layout.topMargin: 10*appWindow.zoom
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
                title = qsTr("Failure to paste URLs from the file") + App.loc.emptyString;
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
                title = qsTr("Failure to paste URLs from the file") + App.loc.emptyString;
                filePath = qsTr("Unable to import the list of URLs from the file: %1").arg(file) + App.loc.emptyString
                errorMessage = errDesc;
                root.open();
            }
        }
    }

    Connections {
        target: App.exportImport
        onExportFinished: (file, error) => {
            if (!root.opened && error.hasError) {
                title = qsTr("Failure to export") + App.loc.emptyString;
                filePath = qsTr("Unable to export to the file: %1").arg(file) + App.loc.emptyString
                errorMessage = error.displayTextLong;
                root.open();
            }
        }
        onImportFinished: (file, error) => {
            if (!root.opened && error.hasError) {
                title = qsTr("Failure to import") + App.loc.emptyString;
                filePath = qsTr("Unable to import from the file: %1").arg(file) + App.loc.emptyString
                errorMessage = error.displayTextLong;
                root.open();
            }
        }
    }
}
