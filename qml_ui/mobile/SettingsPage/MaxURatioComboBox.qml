import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.1
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Item
{
    property double currentValue: 0 // unlimited
    property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    property string sCustom: qsTr("Custom...") + App.loc.emptyString

    implicitHeight: combo.implicitHeight
    implicitWidth: combo.implicitWidth


    ComboBox
    {
        id: combo
        anchors.fill: parent
        model: ["1", "2", "3", "4", sUnlimited, sCustom]
        displayText: parseFloat(currentText) ? +parseFloat(currentText).toFixed(2) : currentText
        font.pixelSize: 14
        implicitWidth: 160
        indicator: Image {
            id: img2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            source: Qt.resolvedUrl("../../images/arrow_drop_down.svg")
            sourceSize.width: 24
            sourceSize.height: 24
            layer {
                effect: ColorOverlay {
                    color: appWindow.theme.foreground
                }
                enabled: true
            }
        }
        contentItem: Text {
            text: combo.displayText
            color: appWindow.theme.foreground
            leftPadding: 10
            font: combo.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        delegate: Rectangle {
            height: 35
            width: parent.width
            color: appWindow.theme.background
            Label {
                id: label
                leftPadding: 10
                anchors.verticalCenter: parent.verticalCenter
                text: parseFloat(modelData) ? +parseFloat(modelData).toFixed(2) : modelData
                font.pixelSize: 16
                width: parent.width
                elide: Text.ElideRight
                color: appWindow.theme.foreground
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    combo.currentIndex = index;
                    combo.popup.close();
                    if (combo.currentText === sCustom)
                    {
                        custom.open();
                        value.forceActiveFocus()
                        return;
                    }
                    currentValue = combo.currentText == sUnlimited ?
                        0 : +parseFloat(combo.currentText).toFixed(2);
                }
            }
        }
    }

    Dialog {
        id: custom
        parent: appWindow.overlay


        x: Math.round((appWindow.width - width) / 2)
        y: Math.round((appWindow.height - height) / 2)

        modal: true

        title: qsTr("Custom value") + App.loc.emptyString

        contentItem: RowLayout {
            //anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            TextField
            {
                id: value
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                onAccepted: custom.tryAcceptValue()
                //Keys.onEscapePressed: custom.reject()
                font.pixelSize: 13
                implicitWidth: 30
                maximumLength: 6
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
            //combo.visible = true;
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
        standardButtons: StandardButton.Ok
    }

    function applyCurrentValueToCombo()
    {
        var cvstr = currentValue ?
                    parseFloat(currentValue).toString() :
                    sUnlimited;

        var m = combo.model

        for (var i = 0; i < m.length; i++)
        {
            if (m[i] === cvstr)
            {
                combo.currentIndex = i;
                return;
            }
        }

        m.splice(0,0,cvstr);
        combo.model = m;
    }

    Component.onCompleted:
    {
        applyCurrentValueToCombo();
    }
}
