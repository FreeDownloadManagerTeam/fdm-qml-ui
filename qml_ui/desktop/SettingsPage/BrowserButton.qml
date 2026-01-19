import QtQuick
import QtQuick.Controls
import org.freedownloadmanager.fdm
import org.freedownloadmanager.fdm.knownwebbrowsers
import "../BaseElements"
import "../BaseElements/V2"
import "../../common"

Item {
    id: root

    property var browser

    enabled: App.integration.isBrowserInstalled(browser.id)

    readonly property var btn: appWindow.uiver === 1 ? btn_v1 : btn_v2

    implicitHeight: btn.implicitHeight
    implicitWidth: btn.implicitWidth

    readonly property string __text: (parent.enabled ? qsTr("Download %1 extension").arg(browser.title) : qsTr("%1 is not installed").arg(browser.title)) + App.loc.emptyString

    CustomButton {
        id: btn_v1

        visible: appWindow.uiver === 1

        implicitWidth: content_v1.implicitWidth + leftPadding + rightPadding
        implicitHeight: content_v1.implicitHeight + topPadding + bottomPadding

        Row
        {
            id: content_v1

            anchors.fill: parent
            anchors.leftMargin: 8*appWindow.zoom

            WaSvgImage {
                id: img
                anchors.verticalCenter: parent.verticalCenter
                width: 28*zoom
                height: 28*zoom
                source: browser.icon
                zoom: appWindow.zoom
            }

            BaseLabel {
                padding: 8*appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12*appWindow.fontZoom
                text: root.__text
                wrapMode: Label.WordWrap
                color: btn_v1.isPressed ? btn_v1.secondaryTextColor : btn_v1.primaryTextColor
            }
        }

        onClicked: root.onClicked()
    }

    ToolbarFlatButton_V2 {
        id: btn_v2

        visible: appWindow.uiver !== 1

        iconSource: browser.icon
        applyIconColor: false
        ignoreIconHeight: false
        iconPreferredHeight: 24*appWindow.zoom
        iconPreferredWidth: 24*appWindow.zoom
        leftPadding: 12*appWindow.zoom
        rightPadding: leftPadding
        bgColor: appWindow.theme_v2.bg400

        title: root.__text

        onClicked: root.onClicked()
    }

    function onClicked() {
        if (enabled) {
            App.integration.installBrowserExtension(browser.id);
            extensionClicked();
        }
    }
}
