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

import QtQuick

Item
{
    function leftMargin(leftMarginValue_, rightMarginValue_)
    {
        // it seems bug was fixed in Qt6
        return leftMarginValue_;
    }

    function rightMargin(leftMarginValue_, rightMarginValue_)
    {
        // it seems bug was fixed in Qt6
        return rightMarginValue_;
    }

    function leftPadding(leftPaddingValue_, rightPaddingValue_)
    {
        return LayoutMirroring.enabled ? rightPaddingValue_ : leftPaddingValue_;
    }

    function rightPadding(leftPaddingValue_, rightPaddingValue_)
    {
        return LayoutMirroring.enabled ? leftPaddingValue_ : rightPaddingValue_;
    }

    function getLeftPadding(control)
    {
        return LayoutMirroring.enabled ? control.rightPadding : control.leftPadding;
    }

    function getRightPadding(control)
    {
        return LayoutMirroring.enabled ? control.leftPadding : control.rightPadding;
    }
}
