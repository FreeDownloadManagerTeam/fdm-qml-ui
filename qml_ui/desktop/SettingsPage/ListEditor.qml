import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"

Item {
    id: root
    property var myStr
    property var myModel: myStr.length > 0 ? myStr.split(' ') : null
    width: parent.width
    height: 170
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
            height: 110
            color: "transparent"
            clip: true
            border.width: 1
            border.color: appWindow.theme.settingsControlBorder

            ListView {
                id: listView
                model: myModel
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height
                width: parent.width
                clip: true

                currentIndex: -1
                highlight: highlight
                highlightFollowsCurrentItem: false
                focus: true

                ScrollBar.vertical: ScrollBar{}
                ScrollBar.horizontal: ScrollBar{}

                flickableDirection: Flickable.AutoFlickIfNeeded
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    property int rowHeigth: 22
                    width: parent.width
                    height: rowHeigth
                    Layout.preferredHeight: rowHeigth
                    Layout.margins: 1
                    property bool enabledHover: false

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        color: appWindow.theme.menuHighlight
                        visible: enabledHover
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: { enabledHover = true }
                        onExited: { enabledHover = false }
                    }

                    RowLayout {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5
                        anchors.left: parent.left

                        Rectangle {
                            width: 12
                            height: width
                            Layout.alignment: Qt.AlignVCenter
                            color: "transparent"

                            Image {
                                width: 12
                                height: width
                                source: clear_btn_img
                                sourceSize: Qt.size(width, height)

                                layer {
                                    effect: ColorOverlay {
                                        color: appWindow.theme.foreground
                                    }
                                    enabled: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.removeItem(index, modelData)
                                }
                            }
                        }
                        BaseLabel {
                            Layout.alignment: Qt.AlignVCenter
                            text: modelData
                            font.pixelSize: 13
                        }
                    }
                }
            }

            Component {
                id: highlight
                Rectangle {
                    width: listView.width; height: 22
                    border.color: appWindow.theme.selectedBorder
                    border.width: 1
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
            CustomButton {
                id: addBtn
                text: qsTr("Add") + App.loc.emptyString
                blueBtn: true
                alternateBtnPressed: cnclBtn.isPressed
                onClicked: {addBtn.visible = false}
            }

            CustomButton {
                id: cnclBtn
                text: qsTr("Hide") + App.loc.emptyString
                visible: addBtn.visible
                onClicked: {closeClicked()}
            }
        }

        ColumnLayout {
            id: custom
            property bool inError: false

            spacing: 5
            visible: !addBtn.visible

            RowLayout {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                spacing: 5

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
                spacing: 5
                CustomButton {
                    blueBtn: true
                    alternateBtnPressed: cnclBtn1.isPressed
                    radius: 5
                    implicitHeight: value.height
                    Layout.fillWidth: true
                    onClicked: custom.tryAcceptValue()
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Qt.resolvedUrl("../../images/desktop/ok_white.svg")
                        sourceSize.width: 15
                        sourceSize.height: 10
                    }
                }
                CustomButton {
                    id: cnclBtn1
                    radius: 5
                    implicitHeight: value.height
                    Layout.fillWidth: true
                    onClicked: custom.reject()
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Qt.resolvedUrl("../../images/desktop/clean.svg")
                        sourceSize.width: 10
                        sourceSize.height: 10
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
