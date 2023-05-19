import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.dmcoresettings 1.0
import "../BaseElements"
import "../../common"

ComboBox {
    id: root
    height: 25*appWindow.zoom
    width: 100*appWindow.zoom
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    property int visibleRowsCount: 5

    model: ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "100"]
    displayText: currentText + "%"

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.zoom
        width: root.width

        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12*appWindow.fontZoom
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
        radius: 5*appWindow.zoom
        border.color: appWindow.theme.settingsControlBorder
        border.width: 1*appWindow.zoom
    }

    contentItem: Rectangle {
        color: "transparent"
        BaseLabel {
            anchors.left: parent.left
            leftPadding: qtbug.leftPadding(6*appWindow.zoom, 0)
            rightPadding: qtbug.rightPadding(6*appWindow.zoom, 0)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12*appWindow.fontZoom
            color: appWindow.theme.settingsItem
            text: root.displayText
        }
    }

    indicator: Rectangle {
        x: LayoutMirroring.enabled ? 0 : root.width - width
        y: root.topPadding + (root.availableHeight - height) / 2
        width: height - 1*appWindow.zoom
        height: root.height
        color: "transparent"
        Rectangle {
            width: 9*appWindow.zoom
            height: 8*appWindow.zoom
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: 0
                y: -448*zoom
            }
        }
    }

    popup: Popup {
        y: root.height
        width: root.width
        height: 18*appWindow.zoom * root.model.length + 2*appWindow.zoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1*appWindow.zoom
        }

        contentItem: ListView {
            clip: true
            anchors.fill: parent
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
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
