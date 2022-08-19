//
//  AAILivenessWrapView.h
//  AAILivenessSDK
//
//  Created by Advance.ai on 2019/3/1.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAIDetectionConstant.h"

@class AAILivenessResult;
@class AAILivenessWrapView;
@protocol AAILivenessWrapDelegate <NSObject>

@optional

/**
 Tell the detector whether it should detect current video frame, this method is called on the other serial queue.

 @return YES if the detector should detect current frame; otherwise, NO.
 */
- (BOOL)shouldDetect;

/**
 This method will be called when the detection is ready.

 @param detectionType The first `AAIDetectionType` value in property `detectionActions`.
 */
- (void)onDetectionReady:(AAIDetectionType)detectionType;

/**
 This method will be called when the detection fails. Note that the detector will be stopped if the detection fails.

 @param detectionResult Detection result.
 @param detectionType Current detection type.
 */
- (void)onDetectionFailed:(AAIDetectionResult)detectionResult forDetectionType:(AAIDetectionType)detectionType;

/**
 This method will be called whenever a new video frame is detected.

 @param result Detection result.
 @param status Action status.
 @param detectionType Current detection type.
 */
- (void)onFrameDetected:(AAIDetectionResult)result status:(AAIActionStatus)status forDetectionType:(AAIDetectionType)detectionType;

/**
 This method will be called when detection type changed.

 @param toDetectionType The new detection type.
 */
- (void)onDetectionTypeChanged:(AAIDetectionType)toDetectionType;

/**
 Send after detection complete.

 @param resultInfo A AAILivenessResult object contain 'livenessId' NSString object and 'img' UIImage object.
 */
- (void)onDetectionComplete:(AAILivenessResult * _Nonnull)resultInfo;

/**
 The remaing detection time of the current detection type, this method is called about once per second.

 @param remainingTime The remaining time, in seconds.
 @param detectionType Current detection type.
 */
- (void)onDetectionRemainingTime:(NSTimeInterval)remainingTime forDetectionType:(AAIDetectionType)detectionType;

/**
 Send before loading a request.

 @param param wrap view
 */
- (void)livenessViewBeginRequest:(AAILivenessWrapView * _Nonnull)param;

/**
 Sent after a wrap view finishes loading a request.

 @param param wrap view
 @param error An error object indicating load a request failed。
 */
- (void)livenessView:(AAILivenessWrapView * _Nonnull)param endRequest:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AAILivenessResult : NSObject

/// The best quality image captured by the SDK.
///
/// Note that the default image size is 600x600. You can call `[AAILivenessSDK configResultPictureSize:]` method to customize the size of the image.
@property(nonatomic, strong, readonly) UIImage *img;

/// LivenessId. This value can be used to call the anti-spoofing api.
@property(nonatomic, strong, readonly) NSString *livenessId;

@property(nonatomic, strong, readonly, nullable) UIImage *highestQualityOriginSquareImage;

@property(nonatomic, readonly) CGFloat uploadImgCostMillSeconds;

@property(nonatomic, strong, nullable) NSString *transactionId;

/// Base64 string list. It will contain one image for each action, and two images of the best quality.
- (NSArray<NSString *> * _Nullable)imageSequenceList;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface AAILivenessWrapView : UIView

@property(nonatomic, readonly) UIView *roundBorderView;

/**
 You can customize the width of the avatar preview area by implementing this method. Note that the avatar area is always square and horizontally centered.
  
 // Usage:
 wrapView.configAvatarPreviewWidth = ^CGFloat(CGRect wrapViewFrame) {
     return 300;
 };
 */
@property(nonatomic, copy, nullable) CGFloat (^configAvatarPreviewWidth)(CGRect wrapViewFrame);

/**
 You can customize the margin-top of the avatar preview area by implementing this method.
 
 // Usage:
 wrapView.configAvatarPreviewMarginTop = ^CGFloat(CGRect wrapViewFrame) {
     return 64;
 };
 */
@property(nonatomic, copy, nullable) CGFloat (^configAvatarPreviewMarginTop)(CGRect wrapViewFrame);

/**
 You can customize the shape of the avatar preview area by implementing this method, the default avatar preview area is circular.
 "reactPath" represents the visible camera preview area, by configuring this value to customize the shape of the avatar preview area.
  
 // Set a square preview area
 wrapView.configAvatarPreviewPath = ^(CGSize avatarPreviewSize, UIBezierPath * _Nonnull originRectPath) {
     UIBezierPath *squarePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, avatarPreviewSize.width, avatarPreviewSize.width) cornerRadius:0];
     [originRectPath appendPath: [squarePath bezierPathByReversingPath]];
 };
 
 // Set a circular preview area
 wrapView.configAvatarPreviewPath = ^(CGSize avatarPreviewSize, UIBezierPath * _Nonnull originRectPath) {
     CGFloat width = avatarPreviewSize.width;
     UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2) radius:width/2 startAngle:0 endAngle:M_PI * 2 clockwise:NO];
     [originRectPath appendPath:circlePath];
 };
 */
@property(nonatomic, copy, nullable) void (^configAvatarPreviewPath)(CGSize avatarPreviewSize, UIBezierPath *originRectPath);

@property(nonatomic, weak) id<AAILivenessWrapDelegate> wrapDelegate;

/**
 The list of detection actions, reference to AAIDetectionType, note that the `AAIDetectionTypeNone` will be ignored in this array.
 By default, the order of the first two actions is random, and the last action is fixed AAIDetectionTypePosYaw.
 */
@property(nonatomic, copy) NSArray<NSNumber *> *detectionActions;

/**
 Check camera's permission, if user grant, this method will start camera immediately.

 @param completionBlk A block to be called once permission is denied, and the value of "authed" is always NO. It's called on main thread.
 */
- (void)checkCameraPermissionWithCompletionBlk:(void (^_Nullable)(BOOL authed))completionBlk;

/**
 Send auth request.

 @param completionBlk A block to be called when auth request complete. It's called on main thread.
 */
- (void)startAuthWithCompletionBlk:(void (^_Nullable)(NSError * _Nullable error))completionBlk;

/// The avatar preview area. Model only detecting faces in this area.
@property(nonatomic, assign) CGRect currAvatarPreviewArea;

/// The camera preview frame.
///
/// If you configured this property, then the property `configAvatarPreviewMarginTop` and `configAvatarPreviewPath` will be ignored.
@property(nonatomic, assign) CGRect currPreviewFrame;

@end

NS_ASSUME_NONNULL_END
