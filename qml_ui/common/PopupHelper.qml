import QtQuick 2.12

Item
{
    property var popup

    property double popupCloseTime: 0

    function isPopupClosedRecently() {
        return new Date().getTime() - popupCloseTime <= 300;
    }

    Connections {
        enabled: popup
        target: popup
        function onClosed() {
            popupCloseTime = new Date().getTime()
        }
    }
}
