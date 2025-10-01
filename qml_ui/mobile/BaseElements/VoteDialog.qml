import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
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

    visible: opened

    Item {
        id: actionElement
        width: Math.max(btnWrapper.width + (laterBtnText.length > 0 ? 40 : 30 + 30 + 20),
                        Math.min(label.implicitWidth + 110, appWindow.contentItem.width))
        height: content.height + 20
        x: LayoutMirroring.enabled ?
               parent.width + width :
               -width
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
                    anchors.left: parent.left

                    Row {
                        spacing: 5
                        anchors.left: parent.left

                        Image {
                            id: logo
                            sourceSize.width: 20
                            sourceSize.height: 20
                            source: Qt.resolvedUrl("../../images/mobile/fdmlogo.svg")
                        }

                        Label {
                            id: label
                            text: labelText
                            font.pixelSize: 18
                            color: appWindow.theme.voteDialogText
                            wrapMode: Text.WordWrap
                            width: actionElement.width - 30 - 30 - 25 - 5
                            horizontalAlignment: Text.AlignLeft
                        }
                    }

                    Row {
                        id: btnWrapper
                        spacing: 8
                        anchors.left: parent.left

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
            from: actionElement.LayoutMirroring.enabled ?
                      actionElement.parent.width + actionElement.width :
                      - actionElement.width
            to: actionElement.LayoutMirroring.enabled ?
                    actionElement.parent.width - actionElement.width + 20 :
                    -20
            duration: 500
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
            opened = true;
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
}
