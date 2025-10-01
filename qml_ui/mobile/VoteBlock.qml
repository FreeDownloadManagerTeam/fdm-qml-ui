import QtQuick 2.10
import org.freedownloadmanager.fdm 1.0
import "./BaseElements"

Item {
    anchors.fill: parent

    VoteDialog {
        id: voteDialog
        labelText: qsTr("Enjoy %1?").arg(App.shortDisplayName) + App.loc.emptyString
        noBtnText: qsTr("Not, really") + App.loc.emptyString
        yesBtnText: qsTr("Yes!") + App.loc.emptyString
        onNoBtnPressed: voteDialogHate.open()
        onYesBtnPressed: voteDialogLike.open()
        onCloseBtnPressed: App.appReview.reviewResult(true,true)//remind later
    }

    VoteDialog {
        id: voteDialogLike
        z: 2
        labelText: qsTr("Thanks a lot! Please rate on Google Play.") + App.loc.emptyString
        noBtnText: qsTr("No, thanks") + App.loc.emptyString
        yesBtnText: qsTr("OK, sure!") + App.loc.emptyString
        laterBtnText: qsTr("Later") + App.loc.emptyString
        onNoBtnPressed: App.appReview.reviewResult(true,false)//don't show again
        onYesBtnPressed: App.appReview.reviewResult(false,false)//GP
        onLaterBtnPressed: App.appReview.reviewResult(true,true)//remind later
        onCloseBtnPressed: App.appReview.reviewResult(true,true)//remind later
    }

    VoteDialog {
        id: voteDialogHate
        z: 2
        labelText: qsTr("Let's make it better together! Give us your feedback.") + App.loc.emptyString
        noBtnText: qsTr("No, thanks") + App.loc.emptyString
        yesBtnText: qsTr("OK, sure!") + App.loc.emptyString
        onNoBtnPressed: App.appReview.reviewResult(true,false)
        onYesBtnPressed: function(){
            Qt.openUrlExternally('https://www.freedownloadmanager.org/support.htm?origin=form_wyl&'
                                  + App.serverCommonGetParameters);
            App.appReview.reviewResult(true,false);
        }
        onCloseBtnPressed: App.appReview.reviewResult(true,false)
    }

    function start() {
        voteDialog.open();
    }

    Connections {
        target: App.appReview
        onRequestReview: start()
    }
}
