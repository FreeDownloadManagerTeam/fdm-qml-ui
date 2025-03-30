import QtQuick 2.0
import QtQuick.Layouts 1.12
import '../BaseElements'
import "../../common"
import "../../qt5compat"

Rectangle {

    id: root

    property string text
    property bool showTitleIcon: false
    property bool showCloseButton: true
    property url titleIconUrl: Qt.resolvedUrl("../../images/mobile/fdmlogo.svg")

    property int leftPadding: 0
    property int rightPadding: 0
    property int topPadding: 0
    property int bottomPadding: 0

    signal closeClick

    readonly property int prefferedHeight: appWindow.uiver === 1 ? 36*appWindow.zoom : 0
    readonly property int prefferedIconHeight: 30*appWindow.zoom

    implicitWidth: meat.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(meat.implicitHeight + topPadding + bottomPadding, prefferedHeight)

    color: appWindow.uiver === 1 ?
               appWindow.theme.dialogTitleBackground :
               "transparent"

    Rectangle {
        anchors.fill: parent
        visible: appWindow.uiver === 1 && appWindow.macVersion && appWindow.theme === lightTheme
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ececec" }
            GradientStop { position: 1.0; color: "#dddcdc" }
        }
    }

    RowLayout {
        id: meat

        anchors.fill: parent
        anchors.leftMargin: root.leftPadding
        anchors.rightMargin: root.rightPadding
        anchors.topMargin: root.topPadding
        anchors.bottomMargin: root.bottomPadding

        WaSvgImage {
            source: root.titleIconUrl
            zoom: appWindow.zoom
            Layout.preferredHeight: root.prefferedIconHeight ?
                                        Math.min(preferredHeight, root.prefferedIconHeight) :
                                        preferredHeight
            Layout.preferredWidth: Layout.preferredHeight
            Layout.alignment: Qt.AlignVCenter
            visible: root.showTitleIcon
        }

        BaseLabel {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            text: root.text
            color: appWindow.uiver === 1 ?
                       (appWindow.macVersion ? appWindow.theme.dialogTitleMac : appWindow.theme.dialogTitle) :
                       appWindow.theme_v2.textColor
            font.pixelSize: (appWindow.uiver === 1 ? 14 : 16)*appWindow.fontZoom
        }

        Item {
            visible: showCloseButton
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.preferredHeight: 24*appWindow.zoom
            Layout.preferredWidth: 24*appWindow.zoom

            WaSvgImage {
                source: appWindow.uiver === 1 ?
                            appWindow.theme.elementsIconsRoot + "/close2.svg" :
                            Qt.resolvedUrl("V2/close.svg")
                zoom: appWindow.zoom
                anchors.centerIn: parent
                layer.effect: ColorOverlay { color: appWindow.theme_v2.bg600 }
                layer.enabled: appWindow.uiver !== 1
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.closeClick()
                cursorShape: appWindow.uiver === 1 ? Qt.ArrowCursor : Qt.PointingHandCursor
            }
        }
    }
}
