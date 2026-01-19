import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "../../common"
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../BaseElements/V2"

Item {
    id: root
    property var myStr
    property var myModel: myStr.length > 0 ? myStr.split(' ').sort() : []
    width: parent.width
    height: 170*appWindow.zoom
    property string clear_btn_img: appWindow.macVersion ? Qt.resolvedUrl("../../images/desktop/search_clear_mac.svg") : Qt.resolvedUrl("../../images/desktop/clean.svg")
    property string currentValue: ""
    property string errorMsg
    property var validationRegex

    signal closeClicked
    signal listChanged(string str)

    ColumnLayout {
        width: parent.width

        Rectangle {
            Layout.fillWidth: true
            height: 110*appWindow.zoom
            color: "transparent"
            clip: true
            border.width: 1*appWindow.zoom
            border.color: appWindow.uiver === 1 ?
                              appWindow.theme.settingsControlBorder :
                              appWindow.theme_v2.outlineBorderColor
            radius: appWindow.uiver === 1 ? 0 : 8*appWindow.zoom

            ListView {
                id: listView
                model: myModel
                anchors.fill: parent
                anchors.margins: (appWindow.uiver === 1 ? 1 : 8)*appWindow.zoom
                anchors.rightMargin: 0
                clip: true

                currentIndex: -1
                highlight: highlight
                highlightFollowsCurrentItem: false
                focus: true

                ScrollBar.vertical: BaseScrollBar_V2{
                    id: sb
                    policy: listView.contentHeight > listView.height ?
                                ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                }

                flickableDirection: Flickable.AutoFlickIfNeeded
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    readonly property int rowHeigth: 22*appWindow.zoom
                    width: parent.width - sb.myWrapSize
                    height: rowHeigth
                    Layout.preferredHeight: rowHeigth
                    Layout.margins: 1*appWindow.zoom
                    readonly property bool highlighted: ma.containsMouse || elidedLabel.containsMouse

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1*appWindow.zoom
                        color: appWindow.uiver === 1 ?
                                   appWindow.theme.menuHighlight :
                                   appWindow.theme_v2.hightlightBgColor
                        radius: appWindow.uiver === 1 ? 0 : 4*appWindow.zoom
                        visible: highlighted
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    RowLayout {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5*appWindow.zoom
                        anchors.left: parent.left
                        anchors.right: parent.right

                        WaSvgImage {
                            id: clearBtnImg

                            Layout.preferredWidth: preferredWidth
                            Layout.preferredHeight: preferredHeight
                            Layout.alignment: Qt.AlignVCenter

                            zoom: appWindow.zoom
                            source: clear_btn_img

                            layer {
                                effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: appWindow.uiver === 1 ? appWindow.theme.foreground : appWindow.theme_v2.textColor
                                }
                                enabled: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.removeItem(index, modelData)
                            }
                        }

                        ElidedLabelWithTooltip {
                            id: elidedLabel
                            Layout.alignment: Qt.AlignVCenter
                            sourceText: modelData
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Component {
                id: highlight
                Rectangle {
                    width: listView.width; height: 22*appWindow.zoom
                    border.color: appWindow.theme.selectedBorder
                    border.width: 1*appWindow.zoom
                    color: appWindow.theme.menuHighlight
                    y: listView.currentItem ? listView.currentItem.y : 0
                    Behavior on y {
                        enabled: listView.currentItem
                        NumberAnimation { duration: 500 }
                    }
                }
            }
        }

        RowLayout {
            BaseButton {
                id: addBtn
                text: qsTr("Add") + App.loc.emptyString
                blueBtn: true
                alternateBtnPressed: cnclBtn.isPressed
                onClicked: {addBtn.visible = false}
            }

            BaseButton {
                id: cnclBtn
                text: qsTr("Hide") + App.loc.emptyString
                visible: addBtn.visible
                onClicked: {closeClicked()}
            }
        }

        ColumnLayout {
            id: custom
            property bool inError: false

            spacing: 5*appWindow.zoom
            visible: !addBtn.visible

            RowLayout {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                spacing: 5*appWindow.zoom

                SettingsTextField {
                    id: value
                    Layout.fillWidth: true
                    onAccepted: custom.tryAcceptValue()
                    Keys.onEscapePressed: custom.reject()
                    onTextChanged: custom.inError = false;

                    SettingsInputError {
                        visible: custom.inError
                        errorMessage: errorMsg
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                spacing: 5*appWindow.zoom
                BaseButton {
                    id: okBtn1
                    blueBtn: true
                    alternateBtnPressed: cnclBtn1.isPressed
                    radius: 5*appWindow.zoom
                    Layout.preferredHeight: value.implicitHeight
                    Layout.fillWidth: true
                    onClicked: custom.tryAcceptValue()
                    WaSvgImage {
                        z: 1
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Qt.resolvedUrl("../../images/desktop/ok_white.svg")
                        zoom: appWindow.zoom
                        layer {
                            effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: appWindow.uiver === 1 ?
                                           (okBtn1.alternateBtnPressed ? okBtn1.secondaryTextColor : okBtn1.primaryTextColor) :
                                           appWindow.theme_v2.bg100
                            }
                            enabled: true
                        }
                    }
                }
                BaseButton {
                    id: cnclBtn1
                    radius: 5*appWindow.zoom
                    Layout.preferredHeight: value.implicitHeight
                    Layout.fillWidth: true
                    onClicked: custom.reject()
                    WaSvgImage {
                        z: 1
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Qt.resolvedUrl("../../images/desktop/clean.svg")
                        zoom: appWindow.zoom
                        layer {
                            effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: appWindow.uiver === 1 ?
                                           (cnclBtn1.isPressed ? cnclBtn1.secondaryTextColor : cnclBtn1.primaryTextColor) :
                                           appWindow.theme_v2.bg1000
                            }
                            enabled: true
                        }
                    }
                }
            }

            function tryAcceptValue()
            {
                currentValue = value.text;
                if (applyCurrentValueToList()) {
                    closeCustom();
                }
            }

            function reject()
            {
                custom.inError = false;
                closeCustom();
            }

            function closeCustom()
            {
                addBtn.visible = true;
                value.text = "";
            }
        }
    }

    function removeItem(index, modelData) {
        var m = listView.model;
        m.splice(index,1);
        listView.currentIndex = -1;
        listView.model = m;
        listChanged(m.join(" "));
    }

    function applyCurrentValueToList()
    {
        var cvstr = currentValue.split(" ");
        var m = listView.model;
        var found;

        for (var j = 0; j < cvstr.length; j++) {
            cvstr[j] = cvstr[j].trim();
            found = false;

            if (cvstr[j].length > 0) {

                if (!cvstr[j].match(validationRegex)){
                    custom.inError = true;
                    return false;
                }

                for (var i = 0; i < m.length; i++) {
                    if (m[i] === cvstr[j]) {
                        found = true;
                        if (listView.currentIndex === i) {
                            listView.currentIndex = -1;
                        }

                        listView.currentIndex = i;
                        break;
                    }
                }

                if (!found) {
                    m.splice(0,0,cvstr[j]);
                }
            }
        }

        listView.model = m;
        listChanged(m.join(" "));

        return true;
    }
}
