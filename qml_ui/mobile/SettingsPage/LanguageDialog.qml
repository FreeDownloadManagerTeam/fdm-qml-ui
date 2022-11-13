import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.freedownloadmanager.fdm 1.0
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import "../../common"
import "../BaseElements"

Dialog
{
    id: root
    width: 320
    height: Math.min(parent.height, langList.count * 30) - 40

    parent: appWindow.overlay

    x: Math.round((appWindow.width - width) / 2)
    y: Math.round((appWindow.height - height) / 2)

    modal: true

    property var flags: {"en_US": -250, "ar_EG": -260, "zh_CN": -130, "zh_TW": -270, "ug": -130, "uk_UA": -220,
                         "da_DK": -100, "nl_NL": -80, "fr_FR": -30, "de_DE": -20, "el_GR": -120, "id_ID": -180,
                         "it_IT": -50, "ja_JP": -150, "pl_PL": -70, "pt_BR": -200, "ro_RO": -60, "ru_RU": -110,
                         "sl_SI": -140, "es_ES": -10, "sv_SE": -90, "tr_TR": -160, "vi_VN": -190, "fa": -210,
                         "hu_HU": -230, "fa_IR": -240, "bg_BG": -280, "ko_KR": -290, "hi_IN": -300 }

    contentItem: Item {
        anchors.fill: parent

        Rectangle {
            width: parent.width
            height: 36
            color: "transparent"
            anchors.top: parent.top

            BaseLabel {
                adaptive: true
                labelSize: adaptiveTools.labelSize.highSize
                text: qsTr("Language") + App.loc.emptyString
                anchors.centerIn: parent
                font.pixelSize: 19
                font.weight: Font.Medium
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color: appWindow.theme.generalSettingsBorder
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - 36
            anchors.top: parent.top
            anchors.topMargin: 36
            color: "transparent"
            clip: true

            ListView {
                id: langList
                anchors.fill: parent

                property double bckgRatio: width / 18
                property double bckgRatio1: 30 / 10
                property string currentLang: App.loc.currentTranslation
                property int currentLangIndex: 0

                onVisibleChanged: {
                    if (visible) {
                        langList.positionViewAtIndex(currentLangIndex, ListView.Contain);
                    }
                }

                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds

                model: App.loc.installedTranslations

                delegate: Rectangle {
                    id: listItem
                    height: 30
                    width: root.width
                    color: "transparent"
                    clip: true
                    property bool isCurrentLang: langList.currentLang == modelData

                    onIsCurrentLangChanged: {
                        if (isCurrentLang) {
                            langList.currentLangIndex = index;
                            langList.positionViewAtIndex(langList.currentLangIndex, ListView.Contain);
                        }
                    }

                    Rectangle {
                        clip: true
                        color: "transparent"
                        width: parent.width
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        visible: listItem.isCurrentLang

                        WaSvgImage {
                            zoom: langList.bckgRatio
                            x: 0
                            y: flags[modelData] * zoom
                            source: Qt.resolvedUrl("../../images/flags.svg")
                            opacity: 0.1
                            layer{
                                effect: FastBlur {
                                    radius: 64
                                }
                                enabled: true
                            }
                        }
                    }

                    Rectangle {
                        clip: true
                        color: "transparent"
                        width: 18 * langList.bckgRatio1
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 35
                        visible: listItem.isCurrentLang

                        WaSvgImage {
                            zoom: langList.bckgRatio1
                            x: 0
                            y: flags[modelData] * zoom
                            source: Qt.resolvedUrl("../../images/flags.svg")
                            opacity: 0.3
                            layer{
                                effect: FastBlur {
                                    radius: 16
                                    transparentBorder: true
                                }
                                enabled: true
                            }
                        }
                    }

                    Rectangle {
                        id: icon
                        clip: true
                        color: "transparent"
                        width: 18
                        height: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 70

                        WaSvgImage {
                            x: 0
                            y: flags[modelData]
                            source: Qt.resolvedUrl("../../images/flags.svg")
                        }
                    }

                    BaseLabel {
                        leftPadding: 15 + 18 + 70
                        anchors.verticalCenter: parent.verticalCenter
                        text: App.loc.translationLanguageString(modelData) + " (" + App.loc.translationCountryString(modelData) + ")"
                        font.capitalization: Font.Capitalize
                        font.pixelSize: 14
                    }

                    SettingsSeparator{
                        anchors.bottom: parent.bottom
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            App.loc.load(modelData)
                            root.close();
                        }
                    }
                }
            }
        }
    }
}
