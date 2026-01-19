/*
  Detects series of clicks on a control.

  Workaround included: QTBUG: the control stops getting |clicked| events under Android since few clicks.
    Uses |pressAndHold| event instead.
*/

import QtQuick

MouseArea
{
    id: root

    signal triggered()

    property int n: 10
    property int nPressAndHoldInterval: n*1000

    pressAndHoldInterval: nPressAndHoldInterval

    onPressAndHold: doTrigger()

    onClicked: timer.targetClicked()

    function doTrigger()
    {
        timer.stop();
        timer.resetClickCounter();
        root.triggered();
    }

    Timer
    {
        id: timer

        property int clickCounter: 0

        onTriggered: resetClickCounter()

        function resetClickCounter()
        {
            clickCounter = 0;
        }

        function targetClicked()
        {
            ++timer.clickCounter;

            if (timer.running && timer.clickCounter === root.n)
            {
                root.doTrigger();
            }
            else
            {
                timer.restart();
            }
        }
    }
}
