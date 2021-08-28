import QtQuick 2.12

Image
{
    // it works buggy under e.g. Retina displays without this
    width: sameHiddenImg.implicitWidth
    height: sameHiddenImg.implicitHeight

    // it works buggy under e.g. Retina displays without this
    sourceSize: Qt.size(width, height)

    Image
    {
        id: sameHiddenImg
        visible: false
        source: parent.source
    }
}
