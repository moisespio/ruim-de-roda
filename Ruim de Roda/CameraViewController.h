//
//  CameraViewController.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraViewControllerDelegate;

@interface CameraViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    id <CameraViewControllerDelegate> __unsafe_unretained delegate;
}

@property (unsafe_unretained) id<CameraViewControllerDelegate> delegate;
@property UIImage *photoTaked;
@property (weak, nonatomic) IBOutlet UIView *previewLayer;

@end

@protocol CameraViewControllerDelegate <NSObject>

@optional

- (void)donePhotoViewController;

@end