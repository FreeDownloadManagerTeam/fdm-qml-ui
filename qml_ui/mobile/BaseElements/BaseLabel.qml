import QtQuick 2.0
import QtQuick.Controls 2.1

Label {
    property bool enabled: true
//    color: enabled ? "#737373" : "#BEBEBE"
    linkColor: appWindow.theme.link
    font.pixelSize: getPointSize()
    horizontalAlignment: Text.AlignLeft

    property bool adaptive: false
    property int labelSize: adaptiveTools.labelSize.smallSize

    function getPointSize()
    {
        if (adaptive) {
            var small, medium, high;
            switch (labelSize) {
                case adaptiveTools.labelSize.smallSize:
                    small = 12; medium = 13; high = 14;
                    break;
                case adaptiveTools.labelSize.mediumSize:
                    small = 14; medium = 15; high = 16;
                    break;
                case adaptiveTools.labelSize.highSize:
                    small = 16; medium = 17; high = 18;
                    break;
            }
            return adaptiveTools.adaptiveByWidth(small, medium, high)
        } else {
            return 12;
        }
    }

//    height: adaptive ? () :
}
