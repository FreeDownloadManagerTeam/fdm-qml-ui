import QtQuick 2.12

FontMetrics
{
    id: fm

    function myElidedText(str, width)
    {
        if (!width || !str.length)
            return "";
        var l = 0;
        var r = str.length;
        var n = r;
        var prevS = str;
        for (;;)
        {
            var s = myElidedTextN(str, n);
            if (!s)
                return prevS;
            prevS = s;

            var isOk = Math.round(fm.advanceWidth(s)) <= width;

            if (isOk)
                l = n;
            else
                r = n;

            if (l !== r)
            {
                if (r - l > 1)
                {
                    n = Math.ceil(l + (r-l)/2);
                }
                else
                {
                    if (isOk)
                        r = l; // return current result
                    else
                        return myElidedTextN(str, l);
                    }
                }

            if (r === l)
                return s;
        }
    }

    function myElidedTextN(str, n)
    {
        if (str.length <= n)
            return str;
        if (n < 3)
            return "";
        n -= 3;
        var l = Math.floor(n / 2);
        var r = n - l;
        return str.substr(0, l) + "..." + str.substr(str.length-r, r);
    }
}
