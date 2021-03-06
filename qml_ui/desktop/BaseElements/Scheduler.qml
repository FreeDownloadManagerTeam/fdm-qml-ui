import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../../common/Tools"
import "../BaseElements"
import "../../common"
import org.freedownloadmanager.fdm 1.0

Item {
    id: root

    height: 64

    property string fromTimeComboValue
    property string toTimeComboValue

    ColumnLayout {
        anchors.fill: parent
        spacing: 19

        RowLayout {
            spacing: 5
            height: 12

            ButtonGroup {
                id: daysGroup
                exclusive: false
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                orientation: ListView.Horizontal
                spacing: 5

                model: ListModel {}

                header: BaseCheckBox {
                    Layout.alignment: Qt.AlignVCenter
                    text: qsTr("Everyday") + App.loc.emptyString
                    checkBoxStyle: "gray"
                    checked: daysGroup.checkState === Qt.Checked
                    onClicked: setAllDaysChecked(checked)
                }

                delegate: BaseCheckBox {
                    text: day
                    checkBoxStyle: "gray"
                    checked: dayEnabled
                    onClicked: setDayChecked(i, checked, index)
                    ButtonGroup.group: daysGroup
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 5

            spacing: 10

            BaseLabel {
                text: qsTr("From:") + App.loc.emptyString
            }

            SchedulerTimeCombobox {
                id: fromTimeCombo
                editText: fromTimeComboValue
                onTextChanged: {
                    fromTimeComboValue = JsTools.timeUtils.minutesToTime(JsTools.timeUtils.timeToMinutes(str))
                }
            }

            BaseLabel {
                text: qsTr("To:") + App.loc.emptyString
                Layout.leftMargin: 10
            }

            SchedulerTimeCombobox {
                id: toTimeCombo
                editText: toTimeComboValue
                onTextChanged: {
                    toTimeComboValue = JsTools.timeUtils.minutesToTime(JsTools.timeUtils.timeToMinutes(str))
                }
            }
        }
    }

    function initialization() {
        fromTimeComboValue = JsTools.timeUtils.minutesToTime(schedulerTools.startTime);
        toTimeComboValue = JsTools.timeUtils.minutesToTime(schedulerTools.endTime);

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
        schedulerTools.startTime = JsTools.timeUtils.timeToMinutes(fromTimeCombo.editText);
        schedulerTools.endTime = JsTools.timeUtils.timeToMinutes(toTimeCombo.editText);
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
