import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Controls.Universal
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
            id: playPauseButtonRect
            height: 100
            width: 50
//            color: 'red'
            anchors.bottom: parent.bottom
            anchors.left: parent.left
              RoundButton {
                  id: playPauseButton
                  radius: 100.0
                  anchors.centerIn: parent
                  text: "\u2016";
                  onClicked:{
                      highlighted: true;
                      if(mediaPlayer.playbackState == MediaPlayer.PlayingState){
                          mediaPlayer.pause();
    //                      playPauseButton.text = "\u2016";
                           playPauseButton.text = "\u25B6";
                       }else{
                          mediaPlayer.play();
    //                      playPauseButton.text = "\u25B6";
                           playPauseButton.text = "\u2016";
                       }

                  }

                  onReleased:{
                      highlighted: false
                  }
              }
         }



          Rectangle{
              id: sliderRect
//              color: 'teal'
              width: 350

              height: 100
              anchors.left: playPauseButtonRect.right
              anchors.bottom: parent.bottom

              Slider {
                   id: videoSlider
                   anchors.centerIn: parent
                   width: parent.width

                   enabled: mediaPlayer.seekable
                   to: 1.0
                   value: mediaPlayer.position / mediaPlayer.duration
                   onMoved: mediaPlayer.setPosition(value * mediaPlayer.duration)
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
                 if (mediaPlayer.position > 1000 && mediaPlayer.duration - mediaPlayer.position < 100) {
                         console.log("end found");
                         mediaPlayer.pause();
                          //change playPauseButton to be pause symbol (assumes autoplay)
                          //accounts for case when slider is slid to end with video paused
                          playPauseButton.text = "\u2016";
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

    // Video picker
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
