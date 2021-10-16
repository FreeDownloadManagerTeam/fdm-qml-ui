import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Row {
    property var browser

    Rectangle {
        color: "transparent"
        width: 30
        height: lbl.height

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 2
            color: "transparent"
            width: 8
            height: 8
            clip: true
            Image {
                source: appWindow.theme.elementsIcons
                sourceSize.width: 93
                sourceSize.height: 456
                x: -60
                y: -120
                layer {
                    effect: ColorOverlay {
                        color: appWindow.theme.inactiveControl
                    }
                    enabled: !appWindow.active
                }
            }
        }
    }

    BaseLabel {
        id: lbl
        text: browser.title
        color: browser.installed ? linkColor : appWindow.theme.settingsItem
        leftPadding: 8
        MouseArea {
            enabled: browser.installed
            anchors.fill: parent
            cursorShape: enabled ? Qt.PointingHandCursor: Qt.ArrowCursor
            onClicked: {
                App.integration.installBrowserExtension(browser.id);
                extensionClicked();
            }
        }
    }

    BaseLabel {
        visible: !browser.installed
        text: qsTr("(browser is not installed)") + App.loc.emptyString
        color: "#999"
        leftPadding: 3
    }
}
