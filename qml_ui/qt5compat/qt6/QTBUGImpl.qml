import QtQuick 2.0

Item
{
    /////////////////////////////////////////////////////////////////////////////////////////////
    // QTBUG-62989 workaround.
    // https://bugreports.qt.io/browse/QTBUG-62989

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

    /////////////////////////////////////////////////////////////////////////////////////////////
}
