import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"

ComboBox {
    id: root
    height: 25
    width: 100
    rightPadding: 5
    leftPadding: 5

    property int visibleRowsCount: 5

    model: ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "100"]
    displayText: currentText + "%"

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
            text: modelData + "%"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                root.popup.close();
                saveBatteryMinimumPowerLevelToRunDownloads(root.currentText)
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
            leftPadding: 2
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: appWindow.theme.settingsItem
            text: root.displayText
        }
    }

    indicator: Rectangle {
        x: root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1
        height: root.height
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
        y: root.height
        width: root.width
        height: 18 * root.model.length + 2
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
                model: root.model
                currentIndex: root.highlightedIndex
                delegate: root.delegate
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
            }
        }
    }

    Component.onCompleted: root.applyCurrentValueToCombo()

    function applyCurrentValueToCombo()
    {
        var cvstr = App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) > 0 ? App.settings.dmcore.value(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads) : 15;
        var m = root.model

        for (var i = 0; i < m.length; i++)
        {
            if (m[i] === cvstr)
            {
                root.currentIndex = i;
                return;
            }
        }

        m.splice(0,0,cvstr);
        root.model = m;
    }

    function saveBatteryMinimumPowerLevelToRunDownloads(value) {
        App.settings.dmcore.setValue(DmCoreSettings.BatteryMinimumPowerLevelToRunDownloads, parseInt(value));
    }
}
