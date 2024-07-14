import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root
    implicitHeight: Math.round(25*appWindow.fontZoom)
    implicitWidth: 30*appWindow.zoom + 170*appWindow.fontZoom
    rightPadding: 5*appWindow.zoom
    leftPadding: 5*appWindow.zoom

    popupVisibleRowsCount: 10
    settingsStyle: true

    model: App.loc.installedTranslations
    textRole: ""

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18*appWindow.fontZoom
        width: root.width

        Row
        {
            anchors.left: parent.left
            anchors.leftMargin: 6*appWindow.zoom
            spacing: 5

            WaSvgImage {
                id: icon
                source: Qt.resolvedUrl("../../images/flags/" + modelData + ".svg")
                zoom: appWindow.zoom
                anchors.verticalCenter: parent.verticalCenter
            }

            BaseLabel {
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: appWindow.fonts.defaultSize
                color: appWindow.theme.settingsItem
                text: App.loc.translationLanguageString(modelData) + " (" + App.loc.translationCountryString(modelData) + ")"
                font.capitalization: Font.Capitalize
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                let name = modelData;
                root.popup.close();
                App.loc.load(name);
            }
        }
    }

    contentItem: Row {
        anchors.left: parent.left
        anchors.leftMargin: 7*appWindow.zoom
        spacing: 5*appWindow.zoom

        Rectangle {
            clip: true
            color: "transparent"
            width: 18*appWindow.zoom
            height: 10*appWindow.zoom
            anchors.verticalCenter: parent.verticalCenter

            WaSvgImage {
                source: Qt.resolvedUrl("../../images/flags/" + App.loc.currentTranslation + ".svg")
                zoom: appWindow.zoom
            }
        }
        BaseLabel {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: appWindow.fonts.defaultSize
            color: appWindow.theme.settingsItem
            text: App.loc.translationLanguageString(App.loc.currentTranslation) + " (" + App.loc.translationCountryString(App.loc.currentTranslation) + ")"
            font.capitalization: Font.Capitalize
        }
    }

    popup: Popup {
        y: root.height
        width: root.width
        height: 182*appWindow.fontZoom
        padding: 1*appWindow.zoom

        background: Rectangle {
            color: appWindow.theme.background
            border.color: appWindow.theme.settingsControlBorder
            border.width: 1*appWindow.zoom
        }

        contentItem: ListView {
            clip: true
            model: root.model
            currentIndex: root.highlightedIndex
            delegate: root.delegate
            flickableDirection: Flickable.VerticalFlick
            ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AlwaysOn; }
            boundsBehavior: Flickable.StopAtBounds
        }
    }
}
