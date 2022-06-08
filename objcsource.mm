#include "imagepicker.h"

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <foundation/foundation.h>



//    void MainWindow::bridgeMethodToCallObjectiveC( MainWindow *mainwindow){
//        void *context = [[photoPickerDelegate alloc] init];
//        [(id) context openPhotoLibraryObjC];
//    }

//     (void)openPhotoLibraryObjC{
//         window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//         [window setRootViewController:self];
//         [window makeKeyAndVisible];
//         UIImagePickerController *imageController = [[[UIImagePickerController alloc] init] autorelease];
//        imageController.delegate = self;
//        [imageController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        imageController.allowsEditing = NO;
//        if(fileType ==2)
//            imageController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie , nil];
//        [self presentViewController:imageController animated:YES completion:NULL];
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


