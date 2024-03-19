import QtQuick 2.12
import QtQuick.Controls 2.12

TextField {
    property bool enable_QTBUG_110471_workaround: true
    property bool enable_QTBUG_110471_workaround_2: false
    property bool selectAllAtInit: false
    property bool overrideImplicitHeight: true // https://bugreports.qt.io/browse/QTBUG-120505

    horizontalAlignment: Text.AlignLeft

    Component.onCompleted: {
        // https://bugreports.qt.io/browse/QTBUG-110471
        if (enable_QTBUG_110471_workaround &&
                appWindow.LayoutMirroring.enabled &&
                !LayoutMirroring.enabled)
        {
            LayoutMirroring.enabled = Qt.binding(() => appWindow.LayoutMirroring.enabled);
            if (enable_QTBUG_110471_workaround_2)
            {
                let t = text;
                text = t + ' ';
                text = t;
            }
        }

        if (overrideImplicitHeight)
        {
            implicitHeight = Qt.binding(() => contentHeight + 24);
        }

        if (selectAllAtInit)
            selectAll();
    }
}
