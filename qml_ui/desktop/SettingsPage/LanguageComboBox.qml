import QtQuick 2.10
import QtQuick.Controls 2.3
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

ComboBox {
    id: root
    height: 25
    width: 200
    anchors.left: parent.left
    anchors.leftMargin: 16
    rightPadding: 5
    leftPadding: 5

    property int visibleRowsCount: 10

    model: App.loc.installedTranslations

    property var flags: {"en_US": -250, "ar_EG": -260, "zh_CN": -130, "zh_TW": -270, "ug": -130, "uk_UA": -220,
                         "da_DK": -100, "nl_NL": -80, "fr_FR": -30, "de_DE": -20, "el_GR": -120, "id_ID": -180,
                         "it_IT": -50, "ja_JP": -150, "pl_PL": -70, "pt_BR": -200, "ro_RO": -60, "ru_RU": -110,
                         "sl_SI": -140, "es_ES": -10, "sv_SE": -90, "tr_TR": -160, "vi_VN": -190, "fa": -210,
                         "hu": -230, "fa_IR": -240, "bg_BG": -280, "ko_KR": -290}

    delegate: Rectangle {
        property bool hover: false
        color: hover ? appWindow.theme.menuHighlight : "transparent"
        height: 18
        width: root.width

        Rectangle {
            id: icon
            clip: true
            color: "transparent"
            width: 18
            height: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 6

            Image {
                x: 0
                y: flags[modelData]
                source: Qt.resolvedUrl("../../images/flags.svg")
                sourceSize.width: 18
                sourceSize.height: 300
            }
        }

        BaseLabel {
            leftPadding: 6 + 18 + 6
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: appWindow.theme.settingsItem
            text: App.loc.translationLanguageString(modelData) + " (" + App.loc.translationCountryString(modelData) + ")"
            font.capitalization: Font.Capitalize
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: {
                root.currentIndex = index;
                App.loc.load(modelData)
                root.popup.close();
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
        Rectangle {
            clip: true
            color: "transparent"
            width: 18
            height: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 2

            Image {
                x: 0
                y: flags[App.loc.currentTranslation]
                source: Qt.resolvedUrl("../../images/flags.svg")
                sourceSize.width: 18
                sourceSize.height: 300
            }
        }
        BaseLabel {
            leftPadding: 6 + 18 + 2
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: appWindow.theme.settingsItem
            text: App.loc.translationLanguageString(App.loc.currentTranslation) + " (" + App.loc.translationCountryString(App.loc.currentTranslation) + ")"
            font.capitalization: Font.Capitalize
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
        height: 182//*root.model.length + 2
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
                ScrollBar.vertical: ScrollBar{ policy: ScrollBar.AlwaysOn; }
                boundsBehavior: Flickable.StopAtBounds
            }
        }
    }
}
