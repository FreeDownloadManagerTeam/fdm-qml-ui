import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Item
{
    id: root

    property double currentValue: 0

    readonly property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    readonly property string sCustom: qsTr("Custom...") + App.loc.emptyString

    implicitHeight: combo.implicitHeight
    implicitWidth: combo.implicitWidth

    BaseComboBox
    {
        id: combo
        anchors.fill: parent
        model: [
            {text: "1", value: 1},
            {text: "2", value: 2},
            {text: "3", value: 3},
            {text: "4", value: 4},
            {text: sUnlimited, value: 0},
            {text: sCustom, value: -1}
        ]

        fontSize: 14

        onActivated: index => {
                         if (model[index].value === -1)
                         {
                             custom.open();
                             value.forceActiveFocus()
                         }
                         else
                         {
                            root.currentValue =  model[index].value;
                         }
                     }
    }

    Dialog {
        id: custom
        parent: Overlay.overlay


        x: Math.round((appWindow.width - width) / 2)
        y: Math.round((appWindow.height - height) / 2)

        modal: true

        title: qsTr("Custom value") + App.loc.emptyString

        contentItem: RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            BaseTextField
            {
                id: value
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                onAccepted: custom.tryAcceptValue()
                font.pixelSize: 13
                implicitWidth: 30
                maximumLength: 6
                horizontalAlignment: Text.AlignLeft
            }
        }

        footer: DialogButtonBox {
            Button
            {
                id: okbtn
                text: qsTr("OK") + App.loc.emptyString
                flat: true
                onClicked: custom.tryAcceptValue()
            }

            Button
            {
                text: qsTr("CANCEL") + App.loc.emptyString
                flat: true
                onClicked: custom.reject()
            }
        }

        onAboutToHide: custom.reject()

        function tryAcceptValue()
        {
            if (!/^[\d\.,]+$/.test(value.text) ||
                    parseFloat(value.text) === 0)
            {
                invalidValueDlg.open();
                return;
            }
            currentValue = +parseFloat(value.text).toFixed(2);
            closeCustom();
        }

        function closeCustom()
        {
            applyCurrentValueToCombo();
            custom.close();
            value.text = "";
        }

        function reject()
        {
            closeCustom();
        }
    }

    MessageDialog
    {
        id: invalidValueDlg
        title: qsTr("Invalid value") + App.loc.emptyString
        text: qsTr("Must be a number greater than 0.") + App.loc.emptyString
        buttons: buttonOk
    }

    function applyCurrentValueToCombo()
    {
        for (var i = 0; i < combo.model.length; i++)
        {
            if (combo.model[i].value === currentValue)
            {
                combo.currentIndex = i;
                return;
            }
        }

        let m = combo.model;
        m.unshift({text: String(currentValue), value: currentValue});
        combo.model = m;
    }

    Component.onCompleted:
    {
        applyCurrentValueToCombo();
    }
}
