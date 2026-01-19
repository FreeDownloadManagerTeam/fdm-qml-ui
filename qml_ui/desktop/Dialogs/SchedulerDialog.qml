import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    title: qsTr("Scheduler") + App.loc.emptyString
    onCloseClick: root.close()

    contentItem: BaseDialogItem {
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: schedulerTools.doOK()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: 5*appWindow.zoom
            spacing: 10*appWindow.zoom

            BaseLabel {
                text: qsTr("Start and pause downloads at specified time") + App.loc.emptyString
                Layout.leftMargin: 5*appWindow.zoom
            }

            BaseCheckBox {
                id: enableScheduler
                text: qsTr("Enable Scheduler") + App.loc.emptyString
                checked: schedulerTools.schedulerCheckboxEnabled
                checkBoxStyle: "gray"
                onClicked: schedulerTools.onSchedulerCheckboxChanged(checked)
            }

            Scheduler {
                id: scheduler
                enabled: schedulerTools.schedulerCheckboxEnabled
                Layout.fillWidth: true
                Layout.topMargin: 5*appWindow.zoom
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
            }

            RowLayout {
                Layout.topMargin: 10*appWindow.zoom
                Layout.alignment: Qt.AlignRight

                spacing: 5*appWindow.zoom

                Rectangle {
                    color: "transparent"
                    height: okbtn.height
                    Layout.fillWidth: true

                    BaseLabel {
                        visible: schedulerTools.statusWarning
                        anchors.verticalCenter: parent.verticalCenter
                        text: schedulerTools.lastError
                        clip: true
                        wrapMode: Text.Wrap
                        width: parent.width
                        font.pixelSize: 13*appWindow.fontZoom
                        color: "#585759"
                    }
                }

                BaseButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }

                BaseButton {
                    id: okbtn
                    text: qsTr("Apply") + App.loc.emptyString
                    blueBtn: true
                    alternateBtnPressed: cnclBtn.isPressed
                    onClicked: {
                        scheduler.complete();
                        schedulerTools.doOK()
                    }
                }
            }
        }
    }

    onOpened: {
        forceActiveFocus();
    }

    function setUpSchedulerAction(ids)
    {
        schedulerTools.buildScheduler(ids);
    }

    SchedulerTools {
        id: schedulerTools
        onBuildingFinished: {
            scheduler.initialization();
            root.open();
        }
        onSettingsSaved: root.close()
    }
}
