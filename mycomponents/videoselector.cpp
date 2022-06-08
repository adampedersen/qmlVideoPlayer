#include "videoselector.h"

VideoSelector::VideoSelector(QObject *parent)
    : QObject{parent}
{

}

QString VideoSelector::currentFile(){
    return m_currentFile;
}

void VideoSelector::setCurrentFile(QString in){
    m_currentFile = in;
}

void VideoSelector::m_findVideo(){
    QFileDialog dialog;
    dialog.setFileMode(QFileDialog::ExistingFiles);
    dialog.setDirectory( QStandardPaths::standardLocations(QStandardPaths::PicturesLocation).last());
    if (dialog.exec()){
        m_currentFile = dialog.selectedFiles().first();
        emit onAccepted();
    }
//    qDebug() << "Selected Pictures " <<dialog.selectedFiles().first();
}
