import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Dialogs"
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.appconstants
import "../BaseElements"

Item
{
    id: root

    property double currentValue: 0

    readonly property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    readonly property string sCustom: qsTr("Custom...") + App.loc.emptyString
    readonly property string kbps: qsTr("KB/s") + App.loc.emptyString

    implicitHeight: combo.implicitHeight
    implicitWidth: combo.implicitWidth


    BaseComboBox
    {
        id: combo
        anchors.fill: parent
        model: [
            {text: "32 " + kbps, value: 32*AppConstants.BytesInKB},
            {text: "64 " + kbps, value: 64*AppConstants.BytesInKB},
            {text: "128 " + kbps, value: 128*AppConstants.BytesInKB},
            {text: "256 " + kbps, value: 256*AppConstants.BytesInKB},
            {text: "512 " + kbps, value: 512*AppConstants.BytesInKB},
            {text: String(AppConstants.BytesInKB) + " " + kbps, value: AppConstants.BytesInMB},
            {text: String(1.5*AppConstants.BytesInKB) + " " + kbps, value: 1.5*AppConstants.BytesInMB},
            {text: String(2*AppConstants.BytesInKB) + " " + kbps, value: 2*AppConstants.BytesInMB},
            {text: String(4*AppConstants.BytesInKB) + " " + kbps, value: 4*AppConstants.BytesInMB},
            {text: sUnlimited, value: 0},
            {text: sCustom, value: -1}
        ]
        fontSize: 14
        onActivated: index => {
                         if (model[index].value === -1)
                         {
                             custom.open();
                             value.forceActiveFocus()
                             return;
                         }
                         root.currentValue = model[index].value;
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
            //anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            BaseTextField
            {
                id: value
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                onAccepted: custom.tryAcceptValue()
                //Keys.onEscapePressed: custom.reject()
                font.pixelSize: 13
                implicitWidth: 30
                maximumLength: 6
                horizontalAlignment: Text.AlignLeft
            }
            Label
            {
                text: kbps
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
            if (!/^\d+$/.test(value.text) ||
                    parseInt(value.text) === 0)
            {
                invalidValueDlg.open();
                return;
            }
            currentValue = parseInt(value.text) * AppConstants.BytesInKB;
            closeCustom();
        }

        function closeCustom()
        {
            applyCurrentValueToCombo();
            //combo.visible = true;
            custom.close();
            value.text = "";
        }

        function reject()
        {
            closeCustom();
        }
    }

    AppMessageDialog
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
        m.unshift({text: String(Math.round(currentValue/AppConstants.BytesInKB)) + " " + kbps, value: currentValue});
        combo.model = m;
        combo.currentIndex = 0;
    }

    Component.onCompleted:
    {
        applyCurrentValueToCombo();
    }
}
