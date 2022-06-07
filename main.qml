import QtQuick
import QtQuick.Window
//import QtQuick.Controls
import QtQuick.Layouts
//import QtQuick.Controls.Material
//import QtQuick.Controls.Universal
import QtMultimedia
import QtQuick.Dialogs

//Made by Adam Pedersen


Window {
    visible: true
    width: 640
    height: 480


    Text {
                id: t
                text: qsTr("Video Player")
                horizontalAlignment:  Text.AlignHCenter
                width: parent.width
    }




        Rectangle{
            id: playPauseButtonAnchorRect
            height: 100
            width: 50
            anchors.bottom: parent.bottom
            anchors.left: parent.left
              Rectangle {
                  id: playPauseButtonRect
                  height: 35
                  width: 35
                  color: 'light gray'
                  anchors.centerIn: parent
                  Text {
                       id: playPauseText
                       text: qsTr("\u2016")
                       anchors.centerIn: parent
                  }
                  MouseArea {
                     id: playPauseMouseArea
                     anchors.fill: parent
                     onClicked:{
                          if(mediaPlayer.playbackState == MediaPlayer.PlayingState){
                               mediaPlayer.pause();
                               playPauseText.text = "\u25B6";
                          }else{
                               mediaPlayer.play();
                               playPauseText.text = "\u2016";
                          }

                     }
                     onPressed:{
                         playPauseButtonRect.color = 'dark gray'
                     }

                     onReleased:{
                         playPauseButtonRect.color = 'light gray'
                     }
                  }
              }
         }


        //Timer for loop
        Timer {
            id: updateSliderTimer
            interval: 100
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: updateSlider()
            function updateSlider() {
                if (sliderMouseArea.isPressed) {
                    mediaPlayer.position = (sliderMouseArea.mouseX / sliderMouseAreaAnchorRect.width) * mediaPlayer.duration;
                }
            }
        }

        Timer {
            id: checkEndTimer
            interval: 100
            repeat: true
            running: true
            triggeredOnStart: false
            onTriggered: checkEnd()
            function checkEnd() {
                if (mediaPlayer.position > 1000 && mediaPlayer.duration - mediaPlayer.position < 100) {
                     updateSliderTimer.stop();
                    /*change playPauseButton to be pause symbol (assumes autoplay)
                    accounts for case when slider is slid to end with video paused*/
                    playPauseText.text = "\u2016";
                    filePicker.open();
                }
            }
        }



          Rectangle{
              id: sliderAnchorRect
              width: 350
              height: 100
              anchors.left: playPauseButtonAnchorRect.right
              anchors.bottom: parent.bottom
              Rectangle{
                  id: sliderMouseAreaAnchorRect
                  anchors.centerIn: parent
                  width: 300
                  height: 25
                  Rectangle{
                      id: sliderProgressBackgroundRect
                      anchors.centerIn: parent
                      width: 300
                      height: 3
                      color: 'light gray'
                  }
                  Rectangle{
                      id: sliderProgressRect
                      anchors.left: parent.left
                      anchors.top:  parent.top
                      anchors.bottom: parent.bottom
                      anchors.right: sliderRect.left
                      color: 'blue'
                      opacity: 0.8
                  }
                  Rectangle{
                      id: sliderRect
                      anchors.verticalCenter: parent.verticalCenter
                      width: 3
                      height: 25
                      color: 'black'
                      opacity: 1
                 }
                 MouseArea {
                     id: sliderMouseArea
                     anchors.fill: parent
                     drag.target: sliderRect
                     drag.axis: Drag.XAxis
                     drag.minimumX: 0;
                     drag.maximumX: parent.width;
                     property bool isPressed: false;
                     property bool wasPlaying: true;

                     onPressed:{
                         isPressed = true;
                         sliderMouseArea.wasPlaying = (mediaPlayer.playbackState == MediaPlayer.PlayingState);
                         mediaPlayer.pause();
                         mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
                         updateSliderTimer.start()
                     }

                     onReleased: {
                         isPressed = false;
                         updateSliderTimer.stop()
                         mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
                         if(sliderMouseArea.wasPlaying){
                             mediaPlayer.play();
                         }
                     }
                 }
              }

          }



    MediaPlayer {
            id: mediaPlayer
            videoOutput: videoOutput
             audioOutput: AudioOutput {
                id: audio
                muted: false
                volume: 1.0
             }

             onPositionChanged: {
                 sliderRect.x = sliderMouseAreaAnchorRect.width * (mediaPlayer.position/mediaPlayer.duration);
                 sliderProgressRect.width = sliderMouseAreaAnchorRect.width * (mediaPlayer.position/mediaPlayer.duration);
             }

    }

    VideoOutput {
        id: videoOutput
        property bool fullScreen: false
        height: 700
        anchors.top: t.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // TODO use native IOS api instead of FileDialog
    FileDialog {
         id:          filePicker
         title:       "Select video"
         currentFolder: shortcuts.movies
         visible:     true
         nameFilters: ["Video files (*.asf *.avi *.flv *.m4v *.mkv *.mov *.mp4 *.mpg *.mpeg)", "All files (*)"]
         onAccepted: {
             console.log(filePicker.currentFile)
             mediaPlayer.stop()
             mediaPlayer.source = filePicker.currentFile
             mediaPlayer.play()
             checkEndTimer.start()
         }
    }




}
