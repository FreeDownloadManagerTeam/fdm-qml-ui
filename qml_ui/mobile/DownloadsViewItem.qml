import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import org.freedownloadmanager.fdm 1.0
import org.freedownloadmanager.fdm.abstractdownloadsui 1.0

import "../common"
import "../common/Tools"
import "BaseElements"

ItemDelegate
{
    id: root

    signal downloadSelected(double model_id)
    signal downloadUnselected()

    property var view
    property bool modelChecked: !!model.checked //undefined to false
    property bool modelRunning: !!model.running //undefined to false
    property bool modelFinished: model.finished
    property string modelError: model.error

    onModelCheckedChanged: selectedDownloadsTools.modelCheckedChanged(model.id)
    onModelRunningChanged: selectedDownloadsTools.modelRunningChanged(model.id)
    onModelFinishedChanged: selectedDownloadsTools.modelFinishedChanged(model.id)
    onModelErrorChanged: selectedDownloadsTools.modelErrorChanged(model.id)

    DownloadsItemTools {
        id: downloadsItemTools
        itemId: model.id

        property bool locked: downloadsItemTools.lockReason != ""
        property double itemOpacity: downloadsItemTools.locked ? 0.4 : 1
    }

    topPadding: 0
    bottomPadding: 0

    contentItem: Rectangle {
        id: wraperItem
        height: 84
        implicitHeight: 84
        anchors.left: parent.left
        anchors.right: parent.right

        color: model.checked ? appWindow.theme.selectedDownloadBackground : "transparent"
        clip: true

// press and hold animation - BEGIN ------------------------
        Rectangle {
            id: colorRect
            height: 0
            width: 0
            color: appWindow.theme.selectedDownloadBackground//"#e8e8e8"

            transform: Translate {
                x: -colorRect.width / 2
                y: -colorRect.height / 2
            }
        }

        PropertyAnimation {
            id: circleAnimation
            target: colorRect   // Целью задаём круговой фон
            properties: "width,height,radius" // В анимации изменяем высоту, ширину и радиус закругления
            from: 0             // Изменяем параметры от о пикселей ...
            //to: parent.width*3    // ... до тройного размера ширины элемента списка
            to: parent.width*6
            //duration: 300       // в течении 300 милисекунд
            duration: 400

            // По остановке анимации обнуляем высоту и ширину анимированного фона
            onStopped: {
                colorRect.width = 0
                colorRect.height = 0
            }
        }
// press and hold animation - END ------------------------

        Rectangle {
            id: priority
            anchors.left: parent.left
            width: 6
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            color: model.priority == AbstractDownloadsUi.DownloadPriorityHigh ? appWindow.theme.highPriority : appWindow.theme.lowPriority
            visible: model.priority != AbstractDownloadsUi.DownloadPriorityNormal
        }

// Left square - BEGIN -----------------------------------------------
        Rectangle {
            id: iconrectangle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 8
            width: 60
            height: 84
            color: "transparent"

            MouseArea
            {
                anchors.fill: parent
                onClicked: function (mouse) {
                    if (appWindow.showDownloadCheckbox) {
                        model.checked = !model.checked;

                        if (model.checked) {
                            downloadSelected(model.id);
                        } else {
                            downloadUnselected();
                        }
                    } else {
                        downloadsViewItemFileInfo.clickMouseArea(mouse)
                    }
                }

                onPressed: function (mouse) {
                    downloadsViewItemFileInfo.circleAnimationStart(mouse.x, mouse.y);
                }

                onPressAndHold: function (mouse) {
                    downloadsViewItemFileInfo.pressAndHoldMouseArea(mouse);
                }
            }

            DownloadIcon {
                id: fileIcon
                locked: downloadsItemTools.locked
                itemOpacity: downloadsItemTools.itemOpacity
                //visible: !(appWindow.showDownloadCheckbox && model.checked)
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ActionButton {
                visible: !appWindow.selectMode
                locked: downloadsItemTools.locked || downloadsItemTools.stopping
                anchors.left: fileIcon.left
                anchors.top: fileIcon.top
                anchors.leftMargin: 24
                anchors.topMargin: 24
            }

//            Image {
//                id: checkedCheckbox
//                source: "../images/checked_checkbox.svg"
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                width: 45
//                height: 45
//                fillMode: Image.PreserveAspectFit
//                anchors.margins: 0
//                //visible: appWindow.showDownloadCheckbox && model.checked
//                visible: appWindow.showDownloadCheckbox && (model.checked ? model.checked : false)
//            }


        }
// Left square - END -----------------------------------------------

// fileinfo_and_downloadstatus - BEGIN -----------------------------------------------
        DownloadsViewItemFileInfo {
            id: downloadsViewItemFileInfo
            anchors.left: iconrectangle.right
            anchors.right: downloadItemMenuBtn.left
            anchors.leftMargin: 10

            onCircleAnimationStart: (xPosition, yPosition) => {
                colorRect.x = xPosition;
                colorRect.y = yPosition;
                circleAnimation.start();
            }
            onCircleAnimationStop: circleAnimation.stop();
        }
// fileinfo_and_downloadstatus - END -----------------------------------------------



// downloadItemMenuBtn - BEGIN -----------------------------------------------
        ToolbarButton {
            id: downloadItemMenuBtn
            visible: !appWindow.selectMode

            anchors.right: parent.right
            anchors.rightMargin: 11
            anchors.verticalCenter: parent.verticalCenter

            icon.source: Qt.resolvedUrl("../images/mobile/menu.svg")
            icon.color: appWindow.theme.foreground

            onClicked: {
                selectedDownloadsTools.currentDownloadId = model.id;
                var component = Qt.createComponent("DownloadsViewItemContextMenu.qml");
                var menu = component.createObject(downloadItemMenuBtn, {
                                                      "modelIds": [model.id],
                                                      "finished": model.finished,
                                                      "hasPostFinishedTasks": downloadsItemTools.hasPostFinishedTasks,
                                                      "priority": model.priority,
                                                      "downloadModel": downloadsItemTools.item
                                                  });
                    menu.open();
                    menu.aboutToHide.connect(function(){
                    menu.destroy();
                });
            }
        }
// downloadItemMenuBtn - END -----------------------------------------------
    }
}
