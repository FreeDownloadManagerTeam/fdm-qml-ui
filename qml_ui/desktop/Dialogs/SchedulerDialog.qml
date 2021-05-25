import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.11
import org.freedownloadmanager.fdm 1.0
import "../BaseElements"
import "../../common/Tools"

BaseDialog {
    id: root

    width: 542

    contentItem: BaseDialogItem {
        titleText: qsTr("Scheduler") + App.loc.emptyString
        focus: true
        Keys.onEscapePressed: root.close()
        Keys.onReturnPressed: schedulerTools.doOK()
        onCloseClick: root.close()

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 5
            spacing: 10

            BaseLabel {
                text: qsTr("Start and pause downloads at specified time") + App.loc.emptyString
                Layout.leftMargin: 5
            }

            BaseCheckBox {
                id: enableScheduler
                text: qsTr("Enable Scheduler") + App.loc.emptyString
                checked: schedulerTools.schedulerCheckboxEnabled
                checkBoxStyle: "gray"
//                textColor: "#303942"
                onClicked: schedulerTools.onSchedulerCheckboxChanged(checked)
            }

            Scheduler {
                id: scheduler
                enabled: schedulerTools.schedulerCheckboxEnabled
                Layout.fillWidth: true
                Layout.topMargin: 5
            }

            RowLayout {
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignRight

                spacing: 5

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
                        font.pixelSize: 13
                        color: "#585759"
                    }
                }

                CustomButton {
                    id: cnclBtn
                    text: qsTr("Cancel") + App.loc.emptyString
                    onClicked: root.close()
                }

                CustomButton {
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
