import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.freedownloadmanager.fdm
import QtQuick.Controls.Material
import "../../common/Tools"
import "../../common"
import "../BaseElements"
import "../SettingsPage"

CenteredDialog {
    id: root

    modal: true

    parent: Overlay.overlay
    width: 310
    height: parent.height < 550 ? parent.height - 60 : 470
    padding: 0

    onClosed: {
        if (schedulerTools.tuneAndDownloadDialog) {
            root.complete();
        }
    }

    contentItem: Flickable {
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar { policy: parent.interactive ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff}
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: content.height
        clip: true
        interactive: root.parent.height < 550

        ColumnLayout {
            id: content
            width: parent.width
            spacing: 10

            Item {
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.preferredHeight: enableScheduler.height

                SwitchSetting {
                    id: enableScheduler
                    textMargins: 0
                    textHeighIncrement: 10
                    textFontSize: 18
                    description: qsTr("Scheduler") + App.loc.emptyString
                    switchChecked: schedulerTools.schedulerCheckboxEnabled
                    enabled: true
                    onClicked: schedulerTools.onSchedulerCheckboxChanged(!switchChecked)
                }
            }

            Label {
                id: enableSchedulerText
                text: qsTr("Start and pause downloads at specified time") + App.loc.emptyString
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                enabled: schedulerTools.schedulerCheckboxEnabled
                width: parent.width
                height: scheduler.height

                ColumnLayout {
                    id: scheduler
                    width: parent.width

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: appWindow.theme.border
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                    }

                    //time
                    RowLayout {
                        id: fromToTextRect
                        width: parent.width
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter

                        TimePicker {
                            id: timeFrom
                            width: 100
                        }

                        Image {
                            id: img
                            sourceSize.width: 20
                            sourceSize.height: 8
                            source: Qt.resolvedUrl("../../images/mobile/arrow.svg")
                            Layout.alignment: Qt.AlignVCenter
                            mirror: LayoutMirroring.enabled
                        }

                        TimePicker {
                            id: timeTo
                            width: 100
                        }
                    }

                    Label {
                        text: qsTr("All the day") + App.loc.emptyString
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                        color: (timeFrom.time.hour == 0 && timeFrom.time.minute == 0 && timeTo.time.hour == 24 && timeTo.time.minute == 00) ? appWindow.theme.schedulerLabelSelectedText : appWindow.theme.schedulerLabelText
                        opacity: enabled ? 1 : 0.5
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                timeFrom.setTime({hour: 0, minute: 0})
                                timeTo.setTime({hour: 24, minute: 00})
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: appWindow.theme.border
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                    }

                    ButtonGroup {
                        id: daysGroup
                        exclusive: false
                    }

                    ListView {
                        id: list
                        orientation: ListView.Horizontal
                        spacing: 0
                        Layout.fillWidth: true
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Layout.preferredHeight: 60

                        model: ListModel {}

                        delegate: Rectangle {
                            height: 70
                            width: 38
                            color: "transparent"
                            BaseCheckBox {
                                text: day
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                checkBoxStyle: "gray"
                                size: 16
                                vertical: true
                                checked: dayEnabled
                                onClicked: setDayChecked(i, checked, index)
                                ButtonGroup.group: daysGroup
                            }
                        }
                    }

                    Label {
                        text: qsTr("Everyday") + App.loc.emptyString
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                        color: daysGroup.checkState === Qt.Checked ? appWindow.theme.schedulerLabelSelectedText : appWindow.theme.schedulerLabelText
                        opacity: enabled ? 1 : 0.5
                        MouseArea {
                            anchors.fill: parent
                            onClicked: setAllDaysChecked(true)
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: appWindow.theme.border
                        Layout.topMargin: 10
                        Layout.bottomMargin: 0
                    }
                }
            }

            Button {
                text: (schedulerTools.tuneAndDownloadDialog ? qsTr("Close") : qsTr("Apply")) + App.loc.emptyString
                onClicked: {
                    if (schedulerTools.tuneAndDownloadDialog) {
                        root.close();
                    } else {
                        root.complete();
                        schedulerTools.doOK();
                    }
                }
                enabled: daysGroup.checkState !== Qt.Unchecked
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 0
                Layout.bottomMargin: 20
                Layout.fillWidth: true
                font.pixelSize: 16
                font.capitalization: Font.Capitalize
                Material.background: appWindow.theme.toolbarBackground
                Material.foreground: appWindow.theme.toolbarTextColor
            }
        }
    }

    function setUpSchedulerAction(ids)
    {
        schedulerTools.buildScheduler(ids);
    }

    function initialization() {
        timeFrom.setTime({hour: Math.floor(schedulerTools.startTime / 60), minute: schedulerTools.startTime % 60})
        timeTo.setTime({hour: Math.floor(schedulerTools.endTime / 60), minute: schedulerTools.endTime % 60})

        list.model.clear();
        var firstDayOfWeek = Qt.locale(App.loc.currentTranslation).firstDayOfWeek;
        if (firstDayOfWeek !== 1) {
            list.model.append({ 'i': 6, 'day': qsTr("Sun"), 'dayEnabled': schedulerTools.daysEnabled & (1<<6)});
        }
        list.model.append({ 'i': 0, 'day': qsTr("Mon"), 'dayEnabled': schedulerTools.daysEnabled & (1<<0)});
        list.model.append({ 'i': 1, 'day': qsTr("Tue"), 'dayEnabled': schedulerTools.daysEnabled & (1<<1)});
        list.model.append({ 'i': 2, 'day': qsTr("Wed"), 'dayEnabled': schedulerTools.daysEnabled & (1<<2)});
        list.model.append({ 'i': 3, 'day': qsTr("Thu"), 'dayEnabled': schedulerTools.daysEnabled & (1<<3)});
        list.model.append({ 'i': 4, 'day': qsTr("Fri"), 'dayEnabled': schedulerTools.daysEnabled & (1<<4)});
        list.model.append({ 'i': 5, 'day': qsTr("Sat"), 'dayEnabled': schedulerTools.daysEnabled & (1<<5)});
        if (firstDayOfWeek === 1) {
            list.model.append({ 'i': 6, 'day': qsTr("Sun"), 'dayEnabled': schedulerTools.daysEnabled & (1<<6)});
        }
    }

    function complete() {
        schedulerTools.startTime = timeFrom.time.hour * 60 + timeFrom.time.minute;
        schedulerTools.endTime = timeTo.time.hour * 60 + timeTo.time.minute;
    }

    function setAllDaysChecked(checked) {
        for (var i = 0; i < list.count; i++) {
            setDayChecked(list.model.get(i).i, checked, i);
        }
    }

    function setDayChecked(i, checked, index) {
        schedulerTools.onDaysEnabledChanged(checked, i);
        list.model.setProperty(index, 'dayEnabled', schedulerTools.daysEnabled & (1<<i));
    }
}
