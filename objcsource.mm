#include "imagepicker.h"

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <foundation/foundation.h>



//    void MainWindow::bridgeMethodToCallObjectiveC( MainWindow *mainwindow){
//        void *context = [[photoPickerDelegate alloc] init];
//        [(id) context openPhotoLibraryObjC];
//    }




    void ImagePicker::selectVideo(){
        UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
        videoPicker.delegate = self;
        videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];‌​
        videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
        videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        [self presentViewController:videoPicker animated:YES completion:nil];
    }


