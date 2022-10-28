import QtQuick 2.12

BaseDialog
{
    property bool standalone: false

    Component.onCompleted:
    {
        if (standalone)
        {
            x = 0;
            y = 0;
            padding = 0;
            topMargin = 0;
            leftMargin = 0;
            rightMargin = 0;
            bottomMargin = 0;
        }
    }
}
