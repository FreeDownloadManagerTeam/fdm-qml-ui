import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common"

BaseComboBox {
    id: root

    popupVisibleRowsCount: 10
    settingsStyle: true

    model: App.loc.installedTranslations
    textRole: ""

    function itemText(loc) {
        return App.loc.translationLanguageString(loc) + " (" + App.loc.translationCountryString(loc) + ")"
    }

    implicitWidth: {
        let h = 0;
        for (let i = 0; i < model.length; ++i)
            h = Math.max(h, fontMetrics.advanceWidth(itemText(model[i])));
        let result = Math.max(comboMinimumWidth, h + (18+5)*appWindow.zoom/*flag*/ + 44*appWindow.zoom + fontMetrics.font.pixelSize*0);
        result += root.leftPadding + root.rightPadding
        return comboMaximumWidth ? Math.min(comboMaximumWidth, result) : result;
    }

    delegate: Item {
        property bool hover: false

        anchors.left: parent ? parent.left : undefined
        height: recommendedDelegateHeight
        width: recommendedDelegateWidth

        Rectangle {
            anchors.fill: parent
            anchors.margins: appWindow.uiver === 1 ? 0 : 2*appWindow.zoom
            color: parent.hover ?
                       (appWindow.uiver === 1 ? appWindow.theme.menuHighlight : appWindow.theme_v2.hightlightBgColor) :
                       "transparent"
            radius: parent.hover ?
                        (appWindow.uiver === 1 ? 0 : 4*appWindow.zoom) :
                        0
        }

        Row
        {
            anchors.left: parent.left
            anchors.leftMargin: root.leftPadding
            anchors.rightMargin: root.rightPadding
            anchors.verticalCenter: parent.verticalCenter
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
                text: itemText(modelData)
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
            text: itemText(App.loc.currentTranslation)
            font.capitalization: Font.Capitalize
        }
    }
}
