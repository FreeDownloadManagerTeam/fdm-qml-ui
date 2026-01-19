import QtQuick
import QtQuick.Layouts
import org.freedownloadmanager.fdm

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

    readonly property string unwantedBehaviorUserFriendlyErrorText: {
        if (error && isUnwantedBehaviorError) {
            let result = qsTr("Server has returned a web page.") + App.loc.emptyString;
            if (!shortVersion && resourceUrl)
                result += " <a href='#'>" + qsTr("Click to open it in the web browser.") + "</a>";
            else if (result.endsWith('.'))
                result = result.substring(0, result.length - 1);
            return result;
        }
        else {
            return null;
        }
    }

    readonly property string errorText: unwantedBehaviorUserFriendlyErrorText ? unwantedBehaviorUserFriendlyErrorText :
                                        errorBaseText ? errorBaseText : ""

    function onErrorLinkActivated()
    {
        Qt.openUrlExternally(root.resourceUrl);
    }
}
