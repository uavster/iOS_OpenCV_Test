//
//  ViewController.m
//  SingleViewTest
//
//  Created by uavster on 6/10/13.
//  Copyright (c) 2013 uavster. All rights reserved.
//

#import "ViewController.h"
#import <stdio.h>

using namespace cv;

@interface ViewController()

@property (nonatomic, assign) BOOL isCapturing;
@property (nonatomic, strong) CvVideoCamera *videoCamera;
//@property (nonatomic, assign) CascadeClassifier faceCascade;
//@property (nonatomic, assign) CascadeClassifier eyeCascade;

@property (nonatomic, assign) BOOL loaded;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loaded = NO;
    
    // Get path to XML with cascade filter
    NSString *pathToFaceCascade = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    if (pathToFaceCascade == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot find path for resource haarcascade_frontalface_alt.xml" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    if (!faceCascade.load([pathToFaceCascade UTF8String])) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot load haarcascade_frontalface_alt.xml" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }

    /*    if (!self.eyeCascade.load("haarcascade_eye_tree_eyeglasses.xml")) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot load haarcascade_eye_tree_eyeglasses.xml" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
  */  
    // Do any additional setup after loading the view, typically from a nib.
    self.isCapturing = NO;
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.videoView];
    
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
    self.videoCamera.delegate = self;
    
    self.loaded = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startCapturePressed:(id)sender {
    if (!self.loaded) return;
    
    NSString *newTitle;
    BOOL success = YES;
    
    // TODO: check if start and stop throw exceptions
    
    if (!self.isCapturing) {
        // Start capture
        [self.videoCamera start];
    } else {
        // Stop capture
        [self.videoCamera stop];
    }
    
    if (success) self.isCapturing = !self.isCapturing;
    
    if (self.isCapturing) newTitle = @"Stop capture";
    else newTitle = @"Start capture";
    
    [self.startCaptureButton setTitle:newTitle forState:UIControlStateNormal];
}

#pragma mark - CvVideoCameraDelegate protocol

#ifdef __cplusplus
-(void)processImage:(Mat &)image {
    Mat bwImage;
    cvtColor(image, bwImage, CV_BGRA2GRAY);
    
    equalizeHist(bwImage, bwImage);
    
    std::vector<cv::Rect> faces;
    faceCascade.detectMultiScale(bwImage, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    
    char buffer[64];
    static int number = 0;
    sprintf(buffer, "(%d, %d) - Detected: %ld %d", bwImage.cols, bwImage.rows, faces.size(), number++);
    String str(buffer);
    putText(image, str, cvPoint(20, 20), 0, 0.5, cvScalar(255, 255, 255, 255));
    
    for (int i = 0; i < faces.size(); i++) {
        cv::rectangle(image, cvPoint(faces[i].x, faces[i].y), cvPoint(faces[i].x + faces[i].width, faces[i].y + faces[i].height), cvScalar(0, 255, 255, 255), 2.0);
    }
    
//		    cvtColor(bwImage, image, CV_GRAY2BGRA);
}
#endif

@end
