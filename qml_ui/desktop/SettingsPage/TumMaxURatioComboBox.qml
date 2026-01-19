import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.dmcoresettings
import org.freedownloadmanager.fdm.tum
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "../../common"
import "../BaseElements"

Item {
    id: root

    enabled: appWindow.btSupported

    property double currentValue: 0 // unlimited
    readonly property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    readonly property string sCustom: qsTr("Custom...") + App.loc.emptyString
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxURatio

    QtObject {
        id: d
        property bool initialized: false
    }

    onCurrentValueChanged: {
        if (d.initialized)
            App.settings.tum.setValue(mode, setting, currentValue.toString())
    }

    implicitHeight: custom.visible ? custom.implicitHeight : combo.implicitHeight
    implicitWidth: 123*appWindow.fontZoom

    BaseComboBox {
        id: combo

        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        enabled: root.enabled

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
                validator: RegularExpressionValidator { regularExpression: /^[\d\.,]+$/ }
                onAccepted: custom.tryAcceptValue()
                Keys.onEscapePressed: custom.reject()
                onTextChanged: custom.inError = false;

                SettingsInputError {
                    visible: custom.inError
                    errorMessage: qsTr("Please enter numbers only") + App.loc.emptyString
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            spacing: 5*appWindow.zoom
            BaseButton {
                id: okBtn
                blueBtn: true
                alternateBtnPressed: cnclBtn.isPressed
                radius: 5*appWindow.zoom
                Layout.preferredHeight: value.implicitHeight
                Layout.fillWidth: true
                onClicked: custom.tryAcceptValue()
                WaSvgImage {
                    z: 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../images/desktop/ok_white.svg")
                    zoom: appWindow.zoom
                    layer {
                        effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: appWindow.uiver === 1 ?
                                       (okBtn.alternateBtnPressed ? okBtn.secondaryTextColor : okBtn.primaryTextColor) :
                                       appWindow.theme_v2.bg100
                        }
                        enabled: true
                    }
                }
            }
            BaseButton {
                id: cnclBtn
                radius: 5*appWindow.zoom
                Layout.preferredHeight: value.implicitHeight
                Layout.fillWidth: true
                onClicked: custom.reject()
                WaSvgImage {
                    z: 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../images/desktop/clean.svg")
                    zoom: appWindow.zoom
                    layer {
                        effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: appWindow.uiver === 1 ?
                                       (cnclBtn.isPressed ? cnclBtn.secondaryTextColor : cnclBtn.primaryTextColor) :
                                       appWindow.theme_v2.bg1000
                        }
                        enabled: true
                    }
                }
            }
        }

        function tryAcceptValue()
        {
            if (!/^[\d\.,]+$/.test(value.text) ||
                    parseFloat(value.text) === 0)
            {
                custom.inError = true;
                return;
            }
            currentValue = +parseFloat(value.text).toFixed(2);
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

    Component.onCompleted: {
        currentValue = App.settings.tum.value(mode, setting);
        root.reloadCombo();
        d.initialized = true;
    }

    Connections {
        target: App.loc
        onCurrentTranslationChanged: root.reloadCombo()
    }

    function reloadCombo() {
        let vv = [1, 2, 3, 4];

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
                    m.push({text: currentValue, value: currentValue});
                }
            }

            m.push({text: vv[i], value: vv[i]});
        }

        if (currentValueIndex === -1 && currentValue > 0)
        {
            currentValueIndex = m.length;
            m.push({text: currentValue, value: currentValue});
        }

        if (currentValueIndex === -1 && !currentValue)
            currentValueIndex = m.length;

        m.push({text: sUnlimited, value: 0});

        m.push({text: sCustom, value: -1});

        combo.model = m;
        combo.currentIndex = currentValueIndex;
    }
}
