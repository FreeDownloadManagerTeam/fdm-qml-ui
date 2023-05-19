import QtQuick 2.0
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"

Row {
    property var browser

    Rectangle {
        color: "transparent"
        width: 30*appWindow.zoom
        height: lbl.height

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 2
            color: "transparent"
            width: 8*appWindow.zoom
            height: 8*appWindow.zoom
            clip: true
            WaSvgImage {
                source: appWindow.theme.elementsIcons
                zoom: appWindow.zoom
                x: -60*zoom
                y: -120*zoom
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
        leftPadding: qtbug.leftPadding(8*appWindow.zoom,0)
        rightPadding: qtbug.rightPadding(8*appWindow.zoom,0)
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
        leftPadding: qtbug.leftPadding(3*appWindow.zoom,0)
        rightPadding: qtbug.rightPadding(3*appWindow.zoom,0)
    }
}
