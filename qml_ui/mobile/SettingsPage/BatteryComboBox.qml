import QtQuick 2.10
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.appsettings 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"

Item
{
    implicitHeight: combo.implicitHeight
    implicitWidth: combo.implicitWidth

    ComboBox
    {
        id: combo
        anchors.fill: parent
        model: ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "100"]
        displayText: currentText + "%"
        font.pixelSize: 16
        anchors.leftMargin: 20
        implicitWidth: 100
        indicator: Image {
            id: img2
            opacity: enabled ? 1 : 0.5
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
            leftPadding: qtbug.leftPadding(10, 0)
            rightPadding: qtbug.rightPadding(10, 0)
            font: combo.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            opacity: enabled ? 1 : 0.5
        }
        delegate: Rectangle {
            height: 35
            width: parent.width
            color: appWindow.theme.background
            Label {
                id: label
                leftPadding: qtbug.leftPadding(10, 0)
                rightPadding: qtbug.rightPadding(10, 0)
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: modelData + "%"
                font.pixelSize: 16
                width: parent.width
                elide: Text.ElideRight
                color: appWindow.theme.foreground
                horizontalAlignment: Text.AlignLeft
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    combo.currentIndex = index;
                    combo.popup.close();
                    saveBatteryMinimumPowerLevelToRunDownloads(combo.currentText)
                }
            }
        }
    }

    function applyCurrentValueToCombo()
    {
        var cvstr = App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) > 0 ? App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) : 15;
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

    function saveBatteryMinimumPowerLevelToRunDownloads(value) {
        App.settings.dmcore.setValue(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads, parseInt(value));
    }

    Component.onCompleted:
    {
        applyCurrentValueToCombo();
    }
}
