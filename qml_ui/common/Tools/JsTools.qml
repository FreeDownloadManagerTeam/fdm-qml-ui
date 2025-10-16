pragma Singleton
import QtQuick 2.0
import org.freedownloadmanager.fdm.appconstants 1.0

QtObject {

    function progress(done, total)
    {
        return total !== -1 ? parseInt(done/total*100) : 0;
    }

    property var timeUtils: QtObject {

        function roundUp(x) {
            return x <= 1 ? 1 : x;
        }
        function remainingTime(remainingTime){

            var seconds, minutes, hours, days, weeks, years, text;

            var valueUnwrapped = remainingTime;

            if (!valueUnwrapped || valueUnwrapped < 0)
                return "";

            seconds = Math.floor(valueUnwrapped / 1000);

            if (seconds >= 3153600000)
                return "∞";

            var time_type = 'seconds';
            minutes = Math.floor(seconds/60);
            if (minutes > 0 || this.roundUp(seconds) === 60){
                time_type = 'minutes';
                hours = Math.floor(seconds/3600);
                if (hours > 0 || this.roundUp(minutes) === 60){
                    time_type = 'hours';
                    days = Math.floor(seconds/86400);
                    if (days > 0 || hours >= 24){
                        time_type = 'days';
                        weeks = Math.floor(seconds/604800);
                        if (weeks > 0 || days >= 7){
                            time_type = 'weeks';
                            years = Math.floor(seconds/31536000);
                            if (years > 0 || weeks >= 52){
                                time_type = 'years';
                            }
                        }
                    }
                }
            }

            switch (time_type){
                case 'seconds':

                    text = this.roundUp(seconds) + "s";
                    break;
                case 'minutes':

                    var s = seconds % 60;
                    text = this.roundUp(minutes) + "m" + (s > 0 ? ' ' + s + "s" : '');
                    break;
                case 'hours':

                    if (hours > 23)
                        hours = 23;
                    if (hours < 1)
                        hours = 1;

                    var m = minutes % 60;
                    text = hours + "h" + (m > 0 ? ' ' + m + "m" : '');
                    break;
                case 'days':

                    var h = hours % 24;
                    text = days + "d" + (h > 0 ? ' ' + h + "h" : '');

                    break;
                case 'weeks':

                    var d = days % 7;
                    text = weeks + "w" + (d > 0 ? ' ' + d + "d" : '');

                    break;
                case 'years':

                    var w = weeks % 52;
                    text = years + "y" + (w > 0 ? ' ' + w + "w" : '');

                    break;
            }

            return text;
        }
        function minutesToTime(min){
            var h = Math.floor(min/60);
            var m = min%60;

            return (h < 10 ? '0' : '') + h + ':' + (m < 10 ? '0' : '') + m;
        }
        function timeToMinutes(time){
            if (!time) {
                return 0;
            }
            var matches = time.match(/(\d{1,2}):(\d{1,2})/);
            if (!matches) {
                return 0;
            }
            var hours = parseInt(matches[1]);
            var minutes = parseInt(matches[2]);
            hours = hours > 23 ? 23 : hours;
            minutes = minutes > 59 ? 59 : minutes;
            return hours * 60 + minutes;
        }
        function isWithin24Hours(date) {
            const now = new Date();
            const twentyFourHoursInMs = 24 * 3600 * 1000; // 24 hours in milliseconds
            const timeDifference = Math.abs(date.getTime() - now.getTime());
            return timeDifference <= twentyFourHoursInMs;
        }
    }

    property var mathUtils: QtObject {
        function round(value, significant) {
            return value.toPrecision(significant) * 1;
        }

        // calculates how many symbols are in the target number after decimal point
        function decimalPlaces(num, significant) {
            // http://stackoverflow.com/a/10454560
            var match = (num.toPrecision(significant)).match(/(?:[\.,](\d+))?(?:[eE]([+-]?\d+))?$/);
            if (!match) { return 0; }
            return Math.max(
                0,
                // Number of digits right of decimal point.
                (match[1] ? match[1].length : 0)
                    // Adjust for scientific notation.
                    - (match[2] ? +match[2] : 0));
        }

        function calcRoundPow(value, significant) {
            var result = Math.log(value)/Math.log(AppConstants.BytesInKB) | 0;
            var rounded = value/Math.pow(AppConstants.BytesInKB,result);
            if(rounded > Math.pow(10, significant)){
                result++;
            }
            return result;
        }

        function roundPrecision(number, count) {

            number = number.toString();
            var result = "";

            var n=0;
            for (var i = 0; i < number.length; i++){
                var v = number[i];
                if (parseInt(v) > 0)
                    n++;
                if (n > count && parseInt(v) > 0){
                    v = '0';
                }
                result = result + v;
            }
            return parseFloat(result);
        }
    }

    property var fileUtils: QtObject {
        function unitNameByPow(e)
        {
            return (e?'KMGTPEZY'[--e]+'B': 'B'/*bytes*/);
        }
        function fileSizeIEC(a,b,c,d,e)
        {
            // based on http://stackoverflow.com/a/20463021
            var r = (c=Math.log,d=AppConstants.BytesInKB,e=c(a)/c(d)|0,a/Math.pow(d,e));
            var f = r-Math.floor(r);
            return r.toFixed((a>1e3) && (f >= 0.1) && (f < 0.9) ? 2 : 0)
                +' '+ fileUtils.unitNameByPow(e);
        }

        function fileSizeIECUnit(a,b,c,d,e)
        {
            c=Math.log;d=AppConstants.BytesInKB;e=c(a)/c(d)|0;
            return fileUtils.unitNameByPow(e);
        }

        function fileSizeIECUnitless(a,b,c,d,e)
        {
            var r = (c=Math.log,d=AppConstants.BytesInKB,e=c(a)/c(d)|0,a/Math.pow(d,e));
            return parseFloat((c=Math.log, d=AppConstants.BytesInKB, e=c(a)/c(d)|0, a / Math.pow(d,e)).toPrecision(r > 99.5 ? 4 : 3));
        }

        function roundFileSizeIEC(a,b,c,d,e)
        {
            if(a == 0) return "0 " + fileUtils.unitNameByPow(e);
            return parseFloat((c=Math.log,d=AppConstants.BytesInKB,e=c(a)/c(d)|0,a/Math.pow(d,e)).toPrecision(2))
                +' '+ fileUtils.unitNameByPow(e);
        }

        function roundFileSizeIEC2(a,b,c,d,e)
        {
            var r = (c=Math.log,d=AppConstants.BytesInKB,e=c(a)/c(d)|0,a/Math.pow(d,e));
            return parseFloat((c=Math.log,d=AppConstants.BytesInKB,e=c(a)/c(d)|0,a/Math.pow(d,e)).toFixed(r > 99.5 ? 0 : 2))
                +' '+ fileUtils.unitNameByPow(e);
        }

        function roundFileSizeIECUnitless(a,reference,b,c,d,e)
        {
            var r;
            if(reference === undefined)
                r = (c=Math.log,d=AppConstants.BytesInKB,e=c(a)/c(d)|0,a/Math.pow(d,e));
            else
                r = (c=Math.log,d=AppConstants.BytesInKB,e=c(reference)/c(d)|0,a/Math.pow(d,e));  // use the same unit as in reference #1971
            return parseFloat(r).toFixed(r > 99.5 ? 0 : 1);
        }

        function extractExtension(filePath)
        {
            return (/[.]/.exec(filePath)) ? /[^.]+$/.exec(filePath).toString() : undefined;
        }

        function fileListToFileTree(files)
        {
            // the algorithm was created by I.Grygoriev and copied from tools.js with some improvements
            var aTree = [files.length];
            var root = [];

            for (var i = 0; i < files.length; i++) {
                var fileItem = _.clone(files[i]);
                var tmpParent = aTree[fileItem.parentIndex];
                var tmpNode = {
                    parentIndex: fileItem.parentIndex,
                    node: { index: i, children: [], data: fileItem, checked: fileItem.isChecked, name: fileItem.name/*, parent: tmpParent ? tmpParent.node : null*/ }
                };

                if (tmpNode.parentIndex === -1) {
                    root.push(tmpNode.node);
                }
                else { // if (treeNode.parentIndex != -1)
                    var parentChildren = aTree[tmpNode.parentIndex].node.children;
                    parentChildren.push(tmpNode.node);
                    parentChildren.sort(function(a,b){
                        return String.naturalCompare(a.name.toLowerCase(), b.name.toLowerCase());
                    });
                }

                aTree[i] = tmpNode;
            }

            return root;
        }
    }

    property var sizeUtils: QtObject {

        function formatByLocale(sizeText) {
            let decimalPoint = Qt.locale().decimalPoint;
            sizeText = sizeText.toString();
            if (decimalPoint != '.')
                sizeText = sizeText.replace('.', decimalPoint);
            return sizeText;
        }
    }
}
