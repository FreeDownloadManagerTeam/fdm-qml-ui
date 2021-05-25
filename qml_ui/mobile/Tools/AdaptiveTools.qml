import QtQuick 2.0

Item {
    property var labelSize: Item {
        readonly property int smallSize: 1
        readonly property int mediumSize: 2
        readonly property int highSize: 3
    }

    function adaptiveByWidth(s, m, h)
    {
        switch (screenTools.currentWidthType) {
            case screenTools.smallSize:
                return s;
            case screenTools.mediumSize:
                return m;
            case screenTools.highSize:
                return h;
        }
    }
}
