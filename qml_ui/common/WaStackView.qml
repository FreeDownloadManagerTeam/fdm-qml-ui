/*
 * Qt bug: StackView's push fails in some cases.
 * Queue the page in this case and push it a bit later.
*/

import QtQuick 2.0
import QtQuick.Controls 2.12

StackView
{
    property var queue: []

    function waPush(item, properties, operation) {
        if (queue.length ||
                !push(item, properties, operation))
        {
            queue.push({i: item, p: properties, o: operation});
            applyTimer();
        }
    }

    function waClear() {
        queue = [];
        clear();
        applyTimer();
    }

    function checkQueue() {
        while (queue.length)
        {
            var item = queue.shift();
            if (!push(item.i, item.p, item.o))
            {
                queue.unshift(item);
                break;
            }
        }
        applyTimer();
    }

    Timer
    {
        id: checkQueueTimer
        interval: 100
        repeat: true
        onTriggered: checkQueue()
    }

    function applyTimer() {
        if (queue.length)
            checkQueueTimer.start();
        else
            checkQueueTimer.stop();
    }
}
