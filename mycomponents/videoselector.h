#ifndef VIDEOSELECTOR_H
#define VIDEOSELECTOR_H

#include <QObject>
#include <QWidget>
#include <QStandardPaths>
#include <QFileDialog>
#include <QString>
#include <qqml.h>

class VideoSelector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentFile READ currentFile WRITE setCurrentFile NOTIFY onAccepted)
    QML_ELEMENT

public:
    explicit VideoSelector(QObject *parent = nullptr);

    void m_findVideo();
    QString currentFile();
    void setCurrentFile(QString in);


signals:

    void onAccepted();

private:
    QString m_currentFile;

};

#endif // VIDEOSELECTOR_H
