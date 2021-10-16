import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4
import "../../qt5compat"
import org.freedownloadmanager.fdm 1.0

Item {
    id: root
    anchors.fill: parent

    property string labelText
    property string yesBtnText
    property string noBtnText
    property string laterBtnText

    property bool opened: false

    signal yesBtnPressed
    signal noBtnPressed
    signal laterBtnPressed
    signal closeBtnPressed

    Item {
        id: actionElement
        width: btnWrapper.width + (laterBtnText.length > 0 ? 40 : 30 + 30 + 20)
        height: content.height + 20//90
        x: -width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25

        MouseArea {
            enabled: true
            anchors.fill: parent
            propagateComposedEvents: false
        }

        RectangularGlow {
            id: glow
            visible: root.opened
            anchors.fill: parent
            color: appWindow.theme.voteDialogGlow
            glowRadius: 2
            spread: 0
            cornerRadius: 10
        }

        Rectangle {
            anchors.fill: parent
            color: appWindow.theme.voteDialogBackground
            radius: 10

            Rectangle {
                color: "transparent"
                anchors.fill: parent
                anchors.leftMargin: 30
                anchors.topMargin: 16

                Column {
                    id: content
                    spacing: 7

                    Row {
                        spacing: 5

                        Image {
                            id: logo
                            sourceSize.width: 20
                            sourceSize.height: 20
                            source: Qt.resolvedUrl("../../images/mobile/fdmlogo.svg")
                        }

                        Label {
                            text: labelText
                            font.pixelSize: 18
                            color: appWindow.theme.voteDialogText
                            wrapMode: Text.WordWrap
                            width: actionElement.width - 30 - 30 - 25 - 5
                        }
                    }

                    Row {
                        id: btnWrapper
                        spacing: 10

                        onWidthChanged: {
                            actionElement.width = btnWrapper.width + (laterBtnText.length > 0 ? 40 : 30 + 30 + 20);
                            if (!root.opened) {
                                actionElement.x = - actionElement.width;
                            }
                        }

                        VoteDialogButton {
                            visible: laterBtnText.length > 0
                            text: laterBtnText
                            onPressed: {
                                root.close();
                                laterBtnPressed()
                            }
                        }

                        VoteDialogButton {
                            text: noBtnText
                            onPressed: {
                                root.close();
                                noBtnPressed()
                            }
                        }

                        VoteDialogButton {
                            text: yesBtnText
                            yesBtn: true
                            onPressed: {
                                root.close();
                                yesBtnPressed()
                            }
                        }
                    }
                }
            }

            RoundButton {
                z: 2
                width: 20
                height: 20
                radius: Math.round(width / 2)
                padding: 0
                spacing: 0
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 10
                anchors.topMargin: 10

                Material.elevation: 0
                Material.background: "transparent"
                display: AbstractButton.IconOnly

                icon.source: Qt.resolvedUrl("../../images/mobile/cross.svg")
                icon.width: 14
                icon.height: 14
                icon.color: "#B3B3B3"
                onPressed: {
                    closeBtnPressed()
                    root.close()
                }
            }
        }

        NumberAnimation on x {
            id: moveIn
            running: false
            from: - actionElement.width
            to: -20
            duration: 500
            onStarted: { root.opened = true; }
        }

        OpacityAnimator on opacity{
            id: moveOut
            running: false
            from: 1
            to: 0
            duration: 200
            onFinished: {
                root.opened = false;
                actionElement.x = - actionElement.width;
                actionElement.opacity = 1;
            }
        }

        function open() {
            moveIn.start()
        }

        function close() {
            moveOut.start()
        }
    }

    function open() {
        if (!root.opened) {
            actionElement.open();
        }
    }

    function close() {
        actionElement.close();
    }

//    Connections {
//        target: App.loc
//        onCurrentTranslationChanged: {
//            actionElement.width = btnWrapper.width + 30 + 30 + 20;
//            actionElement.x = - actionElement.width;
//        }
//    }
}
