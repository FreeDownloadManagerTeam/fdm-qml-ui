import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../../common"

BaseComboBox {
    id: root

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
