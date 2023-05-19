import QtQuick 2.0

Item
{
    function leftMargin(leftMarginValue_, rightMarginValue_)
    {
        return LayoutMirroring.enabled ? rightMarginValue_ : leftMarginValue_;
    }

    function rightMargin(leftMarginValue_, rightMarginValue_)
    {
        return LayoutMirroring.enabled ? leftMarginValue_ : rightMarginValue_;
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
