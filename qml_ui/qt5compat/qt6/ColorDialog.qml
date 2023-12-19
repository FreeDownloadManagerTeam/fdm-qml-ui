import QtQuick 2.0
import Qt.labs.platform 1.1

ColorDialog
{
    property bool showAlphaChannel: true
    options: showAlphaChannel ? ColorDialog.ShowAlphaChannel : 0
}
