import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import org.freedownloadmanager.fdm.tum 1.0
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../qt5compat"
import "../BaseElements"

Item {
    id: root

    enabled: appWindow.btSupported

    property var currentValue: "0" // unlimited
    property string sUnlimited: qsTr("Unlimited") + App.loc.emptyString
    property string sCustom: qsTr("Custom...") + App.loc.emptyString
    property int mode: TrafficUsageMode.Low
    property int setting: DmCoreSettings.MaxURatio

    QtObject {
        id: d
        property bool initialized: false
    }

    onCurrentValueChanged: {
        if (d.initialized)
            App.settings.tum.setValue(mode, setting, currentValue)
    }

    implicitHeight: custom.visible ? custom.implicitHeight : combo.height
    implicitWidth: 123

    ComboBox {
        id: combo
        height: 25
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        enabled: root.enabled

        rightPadding: 5
        leftPadding: 5

        model: ListModel{}

        onActivated: {
            console.error('onActivated', currentValue)
            if (currentText === sCustom)
            {
                visible = false;
                value.forceActiveFocus()
                return;
            }
            currentValue = currentText == sUnlimited ?
                        0 : +parseFloat(currentText).toFixed(2);
        }

        delegate: Rectangle {
            property bool hover: false
            color: hover ? appWindow.theme.menuHighlight : "transparent"
            height: 18
            width: root.width
            BaseLabel {
                leftPadding: 6
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
                color: appWindow.theme.settingsItem
                text: parseFloat(modelData) ? +parseFloat(modelData).toFixed(2) : modelData
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hover = true
                onExited: parent.hover = false
                onClicked: {
                    if (modelData === sCustom) {
                        combo.visible = false;
                        value.forceActiveFocus()
                        return;
                    }
                    root.currentValue = modelData == sUnlimited ?
                                0 : +parseFloat(modelData).toFixed(2);
                    combo.currentIndex = index;
                    combo.popup.close();
                }
            }
        }

        background: Rectangle {
            color: "transparent"
            radius: 5
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1
        }

        contentItem: Rectangle {
            color: "transparent"
            BaseLabel {
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
                color: appWindow.theme.settingsItem
                text: parseFloat(combo.currentText) ? +parseFloat(combo.currentText).toFixed(2) : combo.currentText
            }
        }

        indicator: Rectangle {
            x: combo.width - width
            y: combo.topPadding + (combo.availableHeight - height) / 2
            width: height - 1
            height: combo.height
            color: "transparent"
            Rectangle {
                width: 9
                height: 8
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                Image {
                    source: appWindow.theme.elementsIcons
                    sourceSize.width: 93
                    sourceSize.height: 456
                    x: 0
                    y: -448
                }
            }
        }

        popup: Popup {
            y: combo.height
            width: combo.width
            height: 18*combo.model.length + 2
            padding: 1

            background: Rectangle {
                color: appWindow.theme.background
                border.color: appWindow.theme.settingsControlBorder
                border.width: 1
            }

            contentItem: Item {
                ListView {
                    clip: true
                    anchors.fill: parent
                    model: combo.model
                    currentIndex: combo.highlightedIndex
                    delegate: combo.delegate
                }
            }
        }
    }

    ColumnLayout {
        id: custom
        property bool inError: false

        anchors.fill: parent
        anchors.topMargin: 6
        spacing: 5
        visible: !combo.visible

        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            spacing: 5

            SettingsTextField {
                id: value
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                validator: QtRegExpValidator { regExp: /^[\d\.,]+$/ }
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
            spacing: 5
            CustomButton {
                id: okBtn
                blueBtn: true
                alternateBtnPressed: cnclBtn.isPressed
                radius: 5
                implicitHeight: value.height
                Layout.fillWidth: true
                onClicked: custom.tryAcceptValue()
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../images/desktop/ok_white.svg")
                    sourceSize.width: 15
                    sourceSize.height: 10
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
                radius: 5
                implicitHeight: value.height
                Layout.fillWidth: true
                onClicked: custom.reject()
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("../../images/desktop/clean.svg")
                    sourceSize.width: 10
                    sourceSize.height: 10
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
            applyCurrentValueToCombo();
            combo.visible = true;
            value.text = "";
        }
    }

    function applyCurrentValueToCombo()
    {
        var cvstr = currentValue && currentValue !== '0' ?
                    parseFloat(currentValue).toString() :
                    sUnlimited;

        var m = combo.model;

        for (var i = 0; i < m.length; i++) {
            if (m[i] === cvstr) {
                combo.currentIndex = i;
                return;
            }
        }

        m.splice(0,0,cvstr);
        combo.model = m;
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
        combo.model = ["1", "2", "3", "4", sUnlimited, sCustom];
        applyCurrentValueToCombo();
    }
}
