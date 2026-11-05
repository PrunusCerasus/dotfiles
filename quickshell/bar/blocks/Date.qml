import QtQuick
import "../"
import "../../"

BarBlock {
  id: text
  content: BarText {
    color: Theme.get.foamHex
    symbolText: ` ${Datetime.date}`
  }
}

