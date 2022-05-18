import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "../BaseElements"
import org.freedownloadmanager.fdm 1.0

Dialog
{   
    id: root

    title: "App Self Test"

    modal: true

    closePolicy: Popup.NoAutoClose

    ColumnLayout
    {
        anchors.fill: parent

        ListView
        {
            model: App.selfTest.log
            delegate: Text {
                text: model.text
                color: colorForCategory(model.category)
                function colorForCategory(category)
                {
                    if (category === 0) // Error
                        return "red";
                    if (category === 1) // Warning
                        return "darkorange";
                    return "black";
                }
            }
            Layout.fillHeight: true
            Layout.fillWidth: true
            ScrollIndicator.vertical: ScrollIndicator {}
        }

        Text
        {
            property string resultText: App.selfTest.test.hasErrors ? "FAILED" : "SUCCEEDED"
            property color resultColor: App.selfTest.test.hasErrors ? "red" : "green"
            text: App.selfTest.test.running ? "IN PROGRESS" : resultText
            color: App.selfTest.test.running ? "black" : resultColor
            font.bold: true
        }
    }

    footer: DialogButtonBox
    {
        Button
        {
            text: "Copy log to clipboard"
            onClicked: App.selfTest.copyLogToClipboard()
        }

        Button
        {
            text: App.selfTest.test.running ? "Abort and Exit" : "Exit"
            onClicked: App.quit()
        }
    }
}
