import QtQuick
import Quickshell
import "../"
import "../../"


BarBlock {
  id: text
  content: BarText {
    color: Theme.get.irisHex
    symbolText: ` ${Datetime.time}`
  }
}

