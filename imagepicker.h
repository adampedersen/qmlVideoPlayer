#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include <QObject>

class ImagePicker : public QObject
{
    Q_OBJECT
public:
    explicit ImagePicker(QObject *parent = nullptr);

    void selectVideo();

    std::string currentFile;

signals:
    bool selected;

};

#endif // IMAGEPICKER_H
