import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.freedownloadmanager.fdm 1.0

RowLayout
{
    property var error

    property bool shortVersion: true

    property bool showIcon: true

    property string resourceUrl

    readonly property bool isUnwantedBehaviorError: error && error.isUnwantedBehaviorError

    readonly property string errorBaseText: error ?
                                                (shortVersion ? error.displayTextShort : error.displayTextLong) + App.loc.emptyString :
                                                null

    readonly property string unwantedBehaviorUserFriendlyErrorText: error && isUnwantedBehaviorError ?
                                                (qsTr("Server has returned a web page.") + App.loc.emptyString + (!shortVersion && resourceUrl ? " <a href='#'>" + qsTr("Click to open it in the web browser.") + "</a>" : "")) :
                                                null

    readonly property string errorText: unwantedBehaviorUserFriendlyErrorText ? unwantedBehaviorUserFriendlyErrorText :
                                        errorBaseText ? errorBaseText : ""

    function onErrorLinkActivated()
    {
        Qt.openUrlExternally(root.resourceUrl);
    }
}
