import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../"
import "root:/" 

BarBlock {
    id: root
    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker { 
        objects: [Pipewire.defaultAudioSink]
        onObjectsChanged: {
            sink = Pipewire.defaultAudioSink
            if (sink?.audio) {
                sink.audio.volumeChanged.connect(updateVolume)
            }
        }
    }

    function updateVolume() {
        if (sink?.audio) {
            const icon = sink.audio.muted ? "󰖁" : "󰕾"
            content.symbolText = `${icon} ${Math.round(sink.audio.volume * 100)}%`
        }
    }

    content: BarText {
        color : Theme.get.pineHex
        symbolText: `${sink?.audio?.muted ? "󰖁" : "󰕾"} ${Math.round(sink?.audio?.volume * 100)}%` }

    MouseArea {
        anchors.fill: parent
        onClicked: toggleMenu()
        onWheel: function(event) {
            if (sink?.audio) {
                sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + (event.angleDelta.y / 120) * 0.05))
            }
        }
    }

    Process {
        id: pavucontrol
        command: ["pavucontrol"]
        running: false
    }

    PopupWindow {
        id: menuWindow
        implicitWidth: 200
        implicitHeight: 150
        visible: false

        anchor {
            window: root.QsWindow?.window
            edges: Edges.Bottom
            gravity: Edges.Bottom
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: {
                if (!containsMouse) {
                    closeTimer.start()
                }
            }
            onEntered: closeTimer.stop()

            Timer {
                id: closeTimer
                interval: 500
                onTriggered: menuWindow.visible = false
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.get.baseHex
                // border.color: "#3c3c3c"
                // border.width: 0
                // radius: 0

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // Volume Slider
                    Rectangle {
                        width: parent.width
                        height: 35
                        color: "transparent"

                        Slider {
                            id: volumeSlider
                            anchors.fill: parent
                            from: 0
                            to: 1
                            value: sink?.audio?.volume || 0
                            onValueChanged: {
                                if (sink?.audio) {
                                    sink.audio.volume = value
                                }
                            }

                            background: Rectangle {
                                x: volumeSlider.leftPadding
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: volumeSlider.availableWidth
                                height: 4
                                // radius: 0
                                color:Theme.get.highlightMedHex// "#3c3c3c"

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: Theme.get.pineHex
                                    // radius: 2
                                }
                            }

                            handle: Rectangle {
                                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                width: 16
                                height: 16
                                radius: 6
                                color: volumeSlider.pressed ? Theme.get.pineHex : Theme.get.mutedHex
                                border.color: volumeSlider.pressed ? Theme.get.foamHex : Theme.get.mutedHex
                            }
                        }
                    }

                    Repeater {
                        model: [
                            { text: sink?.audio?.muted ? "Unmute" : "Mute", action: () => sink?.audio && (sink.audio.muted = !sink.audio.muted) },
                            { text: "Pavucontrol", action: () => { pavucontrol.running = true; menuWindow.visible = false } }
                        ]

                        Rectangle {
                            width: parent.width
                            height: 35
                            color: mouseArea.containsMouse ? Theme.get.highlightLowHex : "transparent"
                            // radius: 4

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                text: modelData.text
                                color: Theme.get.textHex
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    modelData.action()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function toggleMenu() {
        if (root.QsWindow?.window?.contentItem) {
            menuWindow.anchor.rect = root.QsWindow.window.contentItem.mapFromItem(root, 0, -menuWindow.height - 5, root.width, root.height)
            menuWindow.visible = !menuWindow.visible
        }
    }
}
