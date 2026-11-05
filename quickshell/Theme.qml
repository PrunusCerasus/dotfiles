pragma Singleton

import QtQuick
import Quickshell

Singleton{
    property Item get: rosePine

    Item {
        id: rosePine

        property string baseHex : "#191724"
        property string surfaceHex :"#1f1d2e"
        property string overlayHex :"#26233a"
        property string mutedHex :"#6e6a86"
        property string subtleHex :"#908caa"
        property string textHex :"#e0def4"
        property string loveHex :"#eb6f92"
        property string goldHex :"#f6c177"
        property string roseHex :"#ebbcba"
        property string pineHex :"#31748f"
        property string foamHex :"#9ccfd8"
        property string irisHex :"#c4a7e7"
        property string highlightLowHex :"#21202e"
        property string highlightMedHex :"#403d52"
        property string highlightHighHex :"#524f67"
    
}
}
