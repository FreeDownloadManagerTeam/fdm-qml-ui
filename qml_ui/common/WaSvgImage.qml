import QtQuick

Image
{
    property double zoom: 1.0

    readonly property int preferredWidth: sameHiddenImg.implicitWidth * zoom
    readonly property int preferredHeight: sameHiddenImg.implicitHeight * zoom

    // it works buggy under e.g. Retina displays without this
    width: preferredWidth
    height: preferredHeight

    // it works buggy under e.g. Retina displays without this
    sourceSize: Qt.size(width, height)

    Image
    {
        id: sameHiddenImg
        visible: false
        source: parent.source
    }
}
