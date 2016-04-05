//
//  VideoEdit.m
//  SimpleAVPlayer
//
//  Created by DING FENG on 6/2/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import "VideoEdit.h"
#import "ZAActivityBar.h"
#import "SDAVAssetExportSession.h"
#import "UIImage+plus.h"

@import CoreText.CTFramesetter;
@interface VideoEdit()

{
    AVAssetExportSession *_exporter;
    NSArray *_subtileArray;
}
@end
@implementation VideoEdit
@synthesize firstAsset,secondAsset,audioAsset;
@synthesize exporter=_exporter;
@synthesize subtileArray=_subtileArray;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (VideoEdit *)sharedInstance
{
    static VideoEdit *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[VideoEdit alloc] init];
    });
    return _sharedInstance;
}
- (void)MergeAndSaveInFileVideoPath:(NSString *)path1  AudioPath:(NSString *)path2   SaveAt:(NSString  *)savePath
{
    
    firstAsset= [AVAsset assetWithURL:[NSURL fileURLWithPath:path1]];
    NSLog(@"%@",firstAsset);
    secondAsset= [AVAsset assetWithURL:[NSURL fileURLWithPath:path1]];
    NSLog(@"%@",secondAsset);
    audioAsset= [AVAsset assetWithURL:[NSURL fileURLWithPath:path2]];
    NSLog(@"%@",audioAsset);
    if(firstAsset !=nil && secondAsset!=nil){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        //AUDIO TRACK
        if(audioAsset!=nil){
            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMaximum(firstAsset.duration, audioAsset.duration));

        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0    &&
           firstTransform.b == 1.0  &&
           firstTransform.c == -1.0 &&
           firstTransform.d == 0)
        {
            FirstAssetOrientation_= UIImageOrientationRight;
            isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0    &&
           firstTransform.b == -1.0 &&
           firstTransform.c == 1.0  &&
           firstTransform.d == 0)
        {
            FirstAssetOrientation_ =  UIImageOrientationLeft;
            isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 &&
           firstTransform.b == 0   &&
           firstTransform.c == 0   &&
           firstTransform.d == 1.0)
        {
            FirstAssetOrientation_ =  UIImageOrientationUp;
        }
        if(firstTransform.a == -1.0 &&
           firstTransform.b == 0    &&
           firstTransform.c == 0    &&
           firstTransform.d == -1.0)
        {
            FirstAssetOrientation_ = UIImageOrientationDown;
        }
        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
        NSLog(@"FirstAssetTrack.naturalSize.width %f ",FirstAssetTrack.naturalSize.width);  //640   400   dingfeng
        float  sizeRate =FirstAssetTrack.naturalSize.width/640.;
        
        
        
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(1./sizeRate,1./sizeRate);
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 24);
        MainCompositionInst.renderSize = CGSizeMake(FirstAssetTrack.naturalSize.width/sizeRate, FirstAssetTrack.naturalSize.height/sizeRate);
        NSString *myPathDocs =savePath;
        
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        float audioDurationSeconds =CMTimeGetSeconds(firstAsset.duration);
        [self applyVideoEffectsToComposition:MainCompositionInst size:MainCompositionInst.renderSize  timefrom:audioDurationSeconds-2  to:audioDurationSeconds];
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
        
        //AVAssetExportPresetMediumQuality
        
       // AVAssetExportPresetPassthrough
        _exporter =exporter;
        NSLog(@"urlurlurlurlurlurlurl  urlurl  %@  MainCompositionInst%@",url,MainCompositionInst);
       // exporter.outputFileType = AVFileTypeMPEG4;
        exporter.videoComposition = MainCompositionInst;
        exporter.outputURL=url;

        //exporter.outputFileType = AVFileTypeQuickTimeMovie;//  h264  编码  必须用  AVFileTypeQuickTimeMovie
        exporter.outputFileType = @"public.mpeg-4";
       // com.apple.quicktime-movie
        exporter.shouldOptimizeForNetworkUse = YES;
        NSLog(@"00000000000");
       // - (void)determineCompatibleFileTypesWithCompletionHandler:(void (^)(NSArray *compatibleFileTypes))handler NS_AVAILABLE(10_9, 6_0);
        [exporter  determineCompatibleFileTypesWithCompletionHandler:^(NSArray *compatibleFileTypes) {
            NSLog(@"%@",compatibleFileTypes);
        }];
        
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             NSLog(@"1111111111111111");
             dispatch_async(dispatch_get_main_queue(), ^{
                 switch (exporter.status)
                 {
                     NSLog(@"2222222222222222222222");
                     case AVAssetExportSessionStatusFailed:
                     {
                         NSLog(@"AVAssetExportSessionStatusFailed");
                         NSLog (@"FAIL %@",exporter.error);
                         if (self.completeBlock)
                         {
                             self.completeBlock(NO);
                         }
                         break;
                     }
                     case AVAssetExportSessionStatusCompleted:
                     {
                         NSLog(@"AVAssetExportSessionStatusCompleted");
                         if (self.completeBlock)
                         {
                             self.completeBlock(YES);
                         }
                         _exporter =exporter;
                         break;
                     }
                     case AVAssetExportSessionStatusCancelled:
                     {
                         NSLog(@"AVAssetExportSessionStatusCancelled");
                         break;
                     }
                 }
             });
         }];
        
    }
}
- (void)exportDidFinish
{
    AVAssetExportSession  *session=_exporter;
    NSLog(@"exportDidFinish!");
    NSLog(@"exportDidFinish!  %d ",session.status);
    if(session.status == AVAssetExportSessionStatusCompleted)
    {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                                                    [alert show];
                                                }else{
                                                    
                                                    [ZAActivityBar  dismiss];
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"视频已经成功保存到相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                    [alert show];
                                                }
                                            });
    }];
        }
    }
    audioAsset = nil;
    firstAsset = nil;
    secondAsset = nil;
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size   timefrom:(float)timefrom  to:(float)timeto
{
    // 1 - Set up the text layer
    NSString *localCourse= [CachesDirectory stringByAppendingPathComponent:@"avatar.png"];
    UIImage *avatar = [UIImage  imageWithContentsOfFile:localCourse];
    if (avatar)
    {
        avatar = [UIImage  imageWithImage:avatar scaledToSize:CGSizeMake(64, 64)];
    }
    CALayer *backLayer =[[CALayer alloc] init];
    [backLayer  setFrame:CGRectMake(0,0,size.width, size.height)];
    backLayer.backgroundColor = [UIColor  colorWithPatternImage:[UIImage  imageNamed:@"backMask.png"]].CGColor;
    CALayer *logoLayer =[[CALayer alloc] init];
    [logoLayer  setFrame:CGRectMake((size.width-370)/2.,size.height/2.-55,370, 110)];
    if (!avatar)
    {
        logoLayer.backgroundColor = [UIColor  colorWithPatternImage:[UIImage  imageNamed:@"logoMask.png"]].CGColor;
    }else
    {
        logoLayer.backgroundColor = [UIColor  colorWithPatternImage:[UIImage  imageNamed:@"avatarBack.png"]].CGColor;
        CALayer *avatarLayer =[[CALayer alloc] init];
        [avatarLayer  setFrame:CGRectMake(40,23,64, 64)];
        avatarLayer.backgroundColor = [UIColor  colorWithPatternImage:avatar].CGColor;
        avatarLayer.cornerRadius = 5;  // 将图层的边框设置为圆脚
        avatarLayer.masksToBounds = YES; // 隐藏边界
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        avatarLayer.affineTransform = transform;
        [logoLayer  addSublayer:avatarLayer];
    }
    
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setBackgroundColor:[UIColor  colorWithPatternImage:[UIImage  imageNamed:@"logoMask.png"]].CGColor];
    //[subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFont:(__bridge CFTypeRef)([UIFont  systemFontOfSize:13])];
    [subtitle1Text setFontSize:26];
    [subtitle1Text setFrame:CGRectMake((size.width-370)/2+120+10+5, size.height/2-26-55., 300, 80)];
    [subtitle1Text setString:[NSString  stringWithFormat:@"by . %@",[FZLoginUser nickname]]];
    [subtitle1Text setAlignmentMode:kCAAlignmentLeft];
//    subtitle1Text.shadowColor = [UIColor blackColor].CGColor;
//    subtitle1Text.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    subtitle1Text.shadowOpacity = 1.0f;
//    subtitle1Text.shadowRadius = 0.5f;
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text.backgroundColor = [UIColor  clearColor].CGColor;
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:backLayer];
    [overlayLayer addSublayer:logoLayer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    overlayLayer.opacity = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:1];
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setBeginTime:timefrom];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [overlayLayer addAnimation:animation forKey:@"animateOpacity"];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    
    
    BOOL  pushSubtile;
    
    pushSubtile =NO;   //把压字幕功能关掉了
    if (self.subtileArray&&pushSubtile)
    {
        for (NSDictionary *d in self.subtileArray)
        {
            NSLog(@"字幕 %@",d);
            NSString *multiLine;
            NSString *line1=[d  objectForKey:@"contentLine1"];
            if ([d.allKeys  containsObject:@"contentLine2"])
            {
                multiLine = [NSString  stringWithFormat:@"%@\n%@",line1,[d  objectForKey:@"contentLine2"]];
            }else{
                multiLine = line1;
            }
            if (!multiLine) {
                multiLine = @"";
            }
            float  timefromSubtitle =[[d   objectForKey:@"beginTime"]  floatValue];
            float  toSubtitle =[[d   objectForKey:@"endTime"]  floatValue];
            NSString  *index = [d  objectForKey:@"index"];
            NSString  *s =multiLine;
            CATextLayer *subtitle1Text2 = [[CATextLayer alloc] init];
            subtitle1Text2.alignmentMode =kCAAlignmentCenter;
            subtitle1Text2.wrapped=YES;
            [subtitle1Text2 setFont:(__bridge CFTypeRef)([UIFont  systemFontOfSize:13.])];       //
            [subtitle1Text2 setFontSize:26];
            UIFont *font = [UIFont  systemFontOfSize:13.];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                        forKey:NSFontAttributeName];
            NSAttributedString *as = [[NSAttributedString alloc] initWithString:@"s" attributes:attrsDictionary];
            __block float  textheight;
            __block float subtitle1Text2Height =70;
            dispatch_sync(dispatch_get_main_queue(), ^
                          {
//                           textheight = [self   textViewHeightForAttributedText:as andWidth:320];
                             textheight = [self  boundingHeightForWidth:320. withAttributedString:as];
                              CGSize maximumLabelSize = CGSizeMake(320, CGFLOAT_MAX);
                              CGRect textRect = [multiLine boundingRectWithSize:maximumLabelSize
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:attrsDictionary
                                                                       context:nil];
                              NSLog(@"%@",NSStringFromCGRect(textRect));
                              subtitle1Text2Height =textRect.size.height;
                          });
            
            NSLog(@"1:%f  2:@%f  3:%@  4:%@  %f",timefromSubtitle,toSubtitle,s,index,subtitle1Text2Height);
            [subtitle1Text2 setFrame:CGRectMake(0, 0, size.width, subtitle1Text2Height*2)];
            [subtitle1Text2 setString:s];
            [subtitle1Text2 setAlignmentMode:kCAAlignmentCenter];
            subtitle1Text2.shadowColor = [UIColor blackColor].CGColor;
            subtitle1Text2.shadowOffset = CGSizeMake(0.0f, 1.0f);
            subtitle1Text2.shadowOpacity = 1.0f;
            subtitle1Text2.shadowRadius = 0.5f;
            [subtitle1Text2 setForegroundColor:[[UIColor whiteColor] CGColor]];
            subtitle1Text2.backgroundColor = [UIColor  clearColor].CGColor;
            // 2 - The usual overlay
            CALayer *overlayLayer2 = [CALayer layer];
            [overlayLayer2 addSublayer:subtitle1Text2];
            overlayLayer2.frame = CGRectMake(0, 0, size.width, size.height);
            [overlayLayer2 setMasksToBounds:YES];
            overlayLayer2.opacity = 0;
            
            CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation2 setDuration:(toSubtitle -timefromSubtitle)];
            [animation2 setFromValue:[NSNumber numberWithFloat:1.0]];
            [animation2 setToValue:[NSNumber numberWithFloat:1.0]];
            [animation2 setBeginTime:timefromSubtitle];
            [animation2 setRemovedOnCompletion:NO];
            [animation2 setFillMode:kCAFillModeForwards];
            
            CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation3 setDuration:0.1];
            [animation3 setFromValue:[NSNumber numberWithFloat:0.0]];
            [animation3 setToValue:[NSNumber numberWithFloat:0.0]];
            [animation3 setBeginTime:toSubtitle];
            [animation3 setRemovedOnCompletion:NO];
            [animation3 setFillMode:kCAFillModeForwards];
            [overlayLayer2 addAnimation:animation2 forKey:@"ewrw"];
            [overlayLayer2 addAnimation:animation3 forKey:@"fdvdfds"];
            [parentLayer addSublayer:overlayLayer2];
        }
    }
    [parentLayer addSublayer:overlayLayer];
    NSLog(@"parentLayer.sublayers %@   %d",parentLayer.sublayers,parentLayer.sublayers.count);
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}
-(void)clearData
{
    self.firstAsset  = nil;
    self.secondAsset  = nil;
    self.audioAsset  = nil;
    self.completeBlock  = nil;
    self.subtileArray=nil;
    _exporter = nil;
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth withAttributedString:(NSAttributedString *)attributedString
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) attributedString);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);
    return suggestedSize.height;
}


@end
