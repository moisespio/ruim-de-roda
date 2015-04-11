//
//  CameraView.h
//  Ruim de Roda
//
//  Created by Matheus Frozzi Alberton on 11/04/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface CameraView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
