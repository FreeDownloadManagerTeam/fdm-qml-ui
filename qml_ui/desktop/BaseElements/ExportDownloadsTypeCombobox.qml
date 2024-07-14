import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import "../../common"

BaseComboBox {
    id: root

    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property string extension: "fdd"
    property string filter: qsTr("%1 downloads files (%2)").arg(App.shortDisplayName).arg("*.fdd") + App.loc.emptyString

    onActivated: {
        extension = model[currentIndex].extension;
        filter = model[currentIndex].filter;
    }

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        root.model = [
                    { text: qsTr("Default format"), extension: 'fdd', filter: qsTr("%1 downloads files (%2)").arg(App.shortDisplayName).arg("*.fdd") },
                    { text: qsTr("List of URLs"), extension: 'txt', filter: qsTr("Text files (%1)").arg("*.txt") },
                    { text: qsTr("CSV file"), extension: 'csv', filter: qsTr("CSV files (%1)").arg("*.csv") }
                ];
    }
}
