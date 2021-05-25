import QtQuick 2.0

Rectangle {
    color: "transparent"
    width: 60
    height: 111
    clip: true

    property var time: ({hour: 0, minute: 0})

//    property int initTimeHour: 0
//    property int initTimeMinutes: 0
    property int step: 15
    property int stepsInHour: 60 / step
    property int itemsPerDay: 24 * stepsInHour

    ListView {
        id: listView
        x: 0
        width: parent.width
        y: -parent.height * 0.5
        height: parent.height * 2
        model: itemsPerDay + 1 //96000
        spacing: 1
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (height - delegateHeight) / 2
        preferredHighlightEnd: (height + delegateHeight) / 2

        property int delegateHeight: 37

        delegate: Item {
            id: contentItem
            width: listView.width
            height: listView.delegateHeight
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                visible: false
            }
            Text {
                id: innerText
                property int hour: index / stepsInHour//Math.floor(index % itemsPerDay / stepsInHour)
                property int minute: step * (index % stepsInHour)
                text: leadingZero(hour) + ":" + leadingZero(minute)
                anchors.centerIn: parent
                font.pixelSize: listView.delegateHeight * 0.8
                font.family: 'Roboto'
                opacity: listView.enabled ? 1 : 0.5

                color: contentItem.ListView.isCurrentItem ? appWindow.theme.timePickerCurrentItemText : appWindow.theme.timePickerText
                transform: [
                    Rotation {
                        origin.x: innerText.width / 2
                        origin.y: innerText.height / 2
                        axis { x: 1; y: 0; z: 0 }
                        angle: {
                            var middle = contentItem.ListView.view.contentY - contentItem.y + contentItem.ListView.view.height / 2
                            var calculated = (middle - contentItem.height / 2) / contentItem.height * 40
                            if (calculated < -90)
                                return -90
                            else if (calculated > 90)
                                return 90
                            else
                                return calculated
                        }
                    },
                    Scale {
                        origin.x: innerText.width / 2
                        origin.y: innerText.height / 2
                        xScale: {
                            // scaled 1 in middle position -> 0 when reaching edges
                            var scaled = (contentItem.y - contentItem.ListView.view.contentY + contentItem.height * 0.5) / contentItem.ListView.view.height * 2
                            if (scaled > 1) scaled = 2 - scaled
                            return Math.max(0, scaled)
                        }
                        yScale: xScale
                    },
                    Translate {
                        y: {
                            var scaled = (contentItem.y - contentItem.ListView.view.contentY + contentItem.height * 0.5) / contentItem.ListView.view.height * 2
                            scaled = Math.max(0, scaled)
                            scaled = 1 - scaled
                            return scaled * scaled * scaled * contentItem.height * 3
                        }
                    }
                ]
            }
        }
//        Component.onCompleted: {
//            var position = initTimeHour == 0 && initTimeMinutes == 0 ? 0 : Math.floor((24 * 60 - (initTimeHour * 60 + initTimeMinutes)) / step)
//            // Scrolls to middle of list
//            positionViewAtIndex(model * 0.5 - position, ListView.SnapPosition)
//        }
        onMovementEnded: {
            var item = currentIndex % itemsPerDay
            var hour = Math.floor(currentIndex / stepsInHour)
            var minute = (item - (Math.floor(item / 4) * 60 / step)) * step
            time = {hour: hour, minute: minute}
        }
    }

    function setTime(newTime) {
        listView.positionViewAtIndex(newTime && newTime.hour * stepsInHour + newTime.minute / step || 0, ListView.Center)
        time = newTime
    }
    function leadingZero(number) {
        return ('00' + number).slice(-2)
    }
}
