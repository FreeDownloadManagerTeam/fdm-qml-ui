import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"
import "../../common"

Row {
    property var browser

    spacing: (appWindow.uiver === 1 ? 0 : 8)*appWindow.zoom

    Item {
        visible: appWindow.uiver === 1
        width: 30*appWindow.zoom
        height: lbl.height

        Item {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 2
            width: 8*appWindow.zoom
            height: 8*appWindow.zoom
            WaSvgImage {
                source: appWindow.theme.elementsIconsRoot + "/filled_circle.svg"
                zoom: appWindow.zoom
                anchors.centerIn: parent
                layer {
                    effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: appWindow.theme.inactiveControl
                    }
                    enabled: !appWindow.active
                }
            }
        }
    }

    BaseLabel {
        id: lbl
        text: browser.title
        color: browser.installed ? linkColor :
                                   (appWindow.uiver === 1 ? appWindow.theme.settingsItem : appWindow.theme_v2.bg600)
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

    SvgImage_V2 {
        visible: browser.installed && appWindow.uiver !== 1
        source: Qt.resolvedUrl("V2/link.svg")
    }

    BaseLabel {
        visible: !browser.installed
        text: qsTr("(browser is not installed)") + App.loc.emptyString
        color: appWindow.uiver === 1 ? "#999" : appWindow.theme_v2.bg600
        leftPadding: qtbug.leftPadding(3*appWindow.zoom,0)
        rightPadding: qtbug.rightPadding(3*appWindow.zoom,0)
    }
}
