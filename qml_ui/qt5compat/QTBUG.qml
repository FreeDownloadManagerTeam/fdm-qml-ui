import QtQuick 2.0
import "./qt5"
import "./qt6"

QTBUGImpl
{
    /////////////////////////////////////////////////////////////////////////////////////////////
    // QTBUG-62989 workaround.
    // https://bugreports.qt.io/browse/QTBUG-62989
    //
    // Should be used only in case LayoutMirroring is used.
    //
    // Should be used for Layout.leftMargin, Layout.rightMargin
    // and for leftPadding, rightPadding.
    // (note that anchors.leftMargin and anchors.rightMargin are not affected by the bug)
    //
    // Usage example:
    //  E.g. we would like to set left margin to 20 and right margin to 0. The code below does it:
    //  Layout.leftMargin: qtbug.leftMargin(20, 0)
    //  Layout.rightMargin: qtbug.rightMargin(20, 0)
    /////////////////////////////////////////////////////////////////////////////////////////////
}
