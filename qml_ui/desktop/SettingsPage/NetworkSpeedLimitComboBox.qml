import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import "../../common"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appconstants 1.0
import "../BaseElements"

Item {
    id: root
    property int currentValue: 0 // unlimited
    readonly property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    readonly property string sCustom: qsTr("Custom...") + App.loc.emptyString
    readonly property string kbps: qsTr("KB/s") + App.loc.emptyString

    implicitHeight: custom.visible ? custom.implicitHeight : combo.implicitHeight
    implicitWidth: 123*appWindow.fontZoom

    BaseComboBox {
        id: combo

        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        enabled: root.enabled

        rightPadding: 5*appWindow.zoom
        leftPadding: 5*appWindow.zoom

        fontSize: 12*appWindow.fontZoom
        settingsStyle: true

        onActivated: index => {
            if (model[index].value === -1)
            {
                visible = false;
                value.forceActiveFocus()
                return;
            }
            root.currentValue = model[index].value;
        }
    }

    ColumnLayout {
        id: custom
        property bool inError: false

        anchors.fill: parent
        anchors.topMargin: 6*appWindow.zoom
        spacing: 5*appWindow.zoom
        visible: !combo.visible

        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            spacing: 5*appWindow.zoom

            SettingsTextField {
                id: value
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /\d+/ }
                onAccepted: custom.tryAcceptValue()
                Keys.onEscapePressed: custom.reject()
                onTextChanged: custom.inError = false;

                SettingsInputError {
                    visible: custom.inError
                    errorMessage: qsTr("Please enter numbers only") + App.loc.emptyString
                }
            }
            BaseLabel {
                text: kbps
                font.pixelSize: 12*appWindow.fontZoom
                color: appWindow.theme.settingsItem
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            spacing: 5*appWindow.zoom
            CustomButton {
                id: okBtn
                blueBtn: true
                alternateBtnPressed: cnclBtn.isPressed
                radius: 5*appWindow.zoom
                implicitHeight: value.implicitHeight
                Layout.fillWidth: true
                onClicked: custom.tryAcceptValue()
                WaSvgImage {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../images/desktop/ok_white.svg")
                    zoom: appWindow.zoom
                    layer {
                        effect: ColorOverlay {
                            color: okBtn.alternateBtnPressed ? okBtn.secondaryTextColor : okBtn.primaryTextColor
                        }
                        enabled: true
                    }
                }
            }
            CustomButton {
                id: cnclBtn
                radius: 5*appWindow.zoom
                implicitHeight: value.implicitHeight
                Layout.fillWidth: true
                onClicked: custom.reject()                
                WaSvgImage {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../images/desktop/clean.svg")
                    zoom: appWindow.zoom
                    layer {
                        effect: ColorOverlay {
                            color: cnclBtn.isPressed ? cnclBtn.secondaryTextColor : cnclBtn.primaryTextColor
                        }
                        enabled: true
                    }
                }
            }
        }

        function tryAcceptValue()
        {
            if (!/^\d+$/.test(value.text) ||
                    parseInt(value.text) === 0)
            {
                custom.inError = true;
                return;
            }
            currentValue = parseInt(value.text) * AppConstants.BytesInKB;
            closeCustom();
        }

        function reject()
        {
            custom.inError = false;
            closeCustom();
        }

        function closeCustom()
        {
            reloadCombo();
            combo.visible = true;
            value.text = "";
        }
    }

    Component.onCompleted: root.reloadCombo()

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        let vv =
            [
                32*AppConstants.BytesInKB,
                64*AppConstants.BytesInKB,
                128*AppConstants.BytesInKB,
                256*AppConstants.BytesInKB,
                512*AppConstants.BytesInKB,
                AppConstants.BytesInKB*AppConstants.BytesInKB,
                AppConstants.BytesInKB*1.5*AppConstants.BytesInKB,
                AppConstants.BytesInKB*2*AppConstants.BytesInKB,
                AppConstants.BytesInKB*4*AppConstants.BytesInKB
            ];

        let m = [];
        let currentValueIndex = -1;

        for (let i in vv)
        {
            if (currentValueIndex === -1 && currentValue > 0)
            {
                if (vv[i] === currentValue)
                {
                    currentValueIndex = m.length;
                }
                else if (vv[i] > currentValue)
                {
                    currentValueIndex = m.length;
                    m.push({text: Math.round(currentValue/AppConstants.BytesInKB) + " " + kbps, value: currentValue});
                }
            }

            m.push({text: Math.round(vv[i]/AppConstants.BytesInKB) + " " + kbps, value: vv[i]});
        }

        if (currentValueIndex === -1 && currentValue > 0)
        {
            currentValueIndex = m.length;
            m.push({text: Math.round(currentValue/AppConstants.BytesInKB) + " " + kbps, value: currentValue});
        }

        if (currentValueIndex === -1 && !currentValue)
            currentValueIndex = m.length;

        m.push({text: sUnlimited, value: 0});

        m.push({text: sCustom, value: -1});

        combo.model = m;
        combo.currentIndex = currentValueIndex;
    }
}
