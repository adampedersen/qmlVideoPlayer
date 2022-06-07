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
//            color: 'teal'
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            //TODO: make my own button
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



          Rectangle{
              id: sliderAnchorRect
//              color: 'red'
//              opacity: 0.5
              width: 350
              height: 100
              anchors.left: playPauseButtonAnchorRect.right
              anchors.bottom: parent.bottom
            //TODO: make my own slider
              Rectangle{
                  id: sliderMouseAreaAnchorRect
                  anchors.centerIn: parent
                  width: 300
                  height: 25
//                  color: 'teal'

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
                     property bool wasPlaying: true;
                     onClicked:{
                         mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
                         sliderProgressRect.width = (mouseX / parent.width) * parent.width;
                     }

                     onPressed:{
                         sliderMouseArea.wasPlaying = (mediaPlayer.playbackState == MediaPlayer.PlayingState);
                         mediaPlayer.pause();
                         mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
                         sliderProgressRect.width = (mouseX / parent.width) * parent.width;
//                         while(sliderMouseArea.containsPress){
//                             mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
//                             sliderProgressRect.width = (mouseX / parent.width) * parent.width;
//                         }

                     }
//                     onPressAndHold: {
//                         while(sliderMouseArea.containsPress){
//                             mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
//                             sliderProgressRect.width = (mouseX / parent.width) * parent.width;
//                         }
//                     }

                     onReleased: {
                         mediaPlayer.position = (mouseX / parent.width) * mediaPlayer.duration;
                         sliderProgressRect.width = (mouseX / parent.width) * parent.width;
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

            //play new video when the current one ends
             onPositionChanged: {
//                 console.log("onPositionChanged called");
                 sliderRect.x = sliderMouseAreaAnchorRect.width * (mediaPlayer.position/mediaPlayer.duration);
                 sliderProgressRect.width = sliderMouseAreaAnchorRect.width * (mediaPlayer.position/mediaPlayer.duration);
                 if (mediaPlayer.position > 1000 && mediaPlayer.duration - mediaPlayer.position < 100) {
//                         console.log("end found");
                     mediaPlayer.pause();
                          //change playPauseButton to be pause symbol (assumes autoplay)
                          //accounts for case when slider is slid to end with video paused
                     playPauseText.text = "\u2016";
                     filePicker.open();
                 }
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
         }
    }




}
