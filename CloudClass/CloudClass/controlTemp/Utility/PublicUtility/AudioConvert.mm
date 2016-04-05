//
//  AudioConvert.m
//  EnglishTalk
//
//  Created by DING FENG on 6/13/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "AudioConvert.h"

extern void ThreadStateInitalize();
extern void ThreadStateBeginInterruption();
extern void ThreadStateEndInterruption();

typedef void(^ProgressBlock)(float   rate);
extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate,ProgressBlock progressBlock);


#define kTransitionDuration	0.75
#pragma mark-

static Boolean IsAACEncoderAvailable(void)
{
    Boolean isAvailable = false;
    
    // get an array of AudioClassDescriptions for all installed encoders for the given format
    // the specifier is the format that we are interested in - this is 'aac ' in our case
    UInt32 encoderSpecifier = kAudioFormatMPEG4AAC;
    UInt32 size;
    
    OSStatus result = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size);
    if (result) { printf("AudioFormatGetPropertyInfo kAudioFormatProperty_Encoders result %lu %4.4s\n", result, (char*)&result); return false; }
    
    UInt32 numEncoders = size / sizeof(AudioClassDescription);
    AudioClassDescription encoderDescriptions[numEncoders];
    
    result = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, encoderDescriptions);
    if (result) { printf("AudioFormatGetProperty kAudioFormatProperty_Encoders result %lu %4.4s\n", result, (char*)&result); return false; }
    
    printf("Number of AAC encoders available: %lu\n", numEncoders);
    
    // with iOS 7.0 AAC software encode is always available
    // older devices like the iPhone 4s also have a slower/less flexible hardware encoded for supporting AAC encode on older systems
    // newer devices may not have a hardware AAC encoder at all but a faster more flexible software AAC encoder
    // as long as one of these encoders is present we can convert to AAC
    // if both are available you may choose to which one to prefer via the AudioConverterNewSpecific() API
    for (UInt32 i=0; i < numEncoders; ++i) {
        if (encoderDescriptions[i].mSubType == kAudioFormatMPEG4AAC && encoderDescriptions[i].mManufacturer == kAppleHardwareAudioCodecManufacturer) {
            printf("Hardware encoder available\n");
            isAvailable = true;
        }
        if (encoderDescriptions[i].mSubType == kAudioFormatMPEG4AAC && encoderDescriptions[i].mManufacturer == kAppleSoftwareAudioCodecManufacturer) {
            printf("Software encoder available\n");
            isAvailable = true;
        }
    }
    
    return isAvailable;
}

static void UpdateFormatInfo(UILabel *inLabel, CFURLRef inFileURL)
{
    printf("--------------------------------------------");
    AudioFileID fileID;
    OSStatus result = AudioFileOpenURL(inFileURL, kAudioFileReadPermission, 0, &fileID);
    if (noErr == result) {
        CAStreamBasicDescription asbd;
        UInt32 size = sizeof(asbd);
        result = AudioFileGetProperty(fileID, kAudioFilePropertyDataFormat, &size, &asbd);
        if (noErr == result) {
            char formatID[5];
            CFStringRef lastPathComponent = CFURLCopyLastPathComponent(inFileURL);
            *(UInt32 *)formatID = CFSwapInt32HostToBig(asbd.mFormatID);
            
            NSString *labelText = [NSString stringWithFormat: @"%@ %4.4s%6.0fHz (%zuch.)", lastPathComponent, formatID, asbd.mSampleRate, asbd.NumberChannels(), nil];
            if (asbd.mBitsPerChannel > 0 )
                inLabel.text = [labelText stringByAppendingFormat: @" %zu-bit", asbd.mBitsPerChannel, nil];
            else
                inLabel.text = labelText;
           // NSLog(@"%@",labelText);
            
            
            
            CFRelease(lastPathComponent);
        } else {
            printf("AudioFileGetProperty kAudioFilePropertyDataFormat result %lu %4.4s\n", result, (char*)&result);
        }
        
        AudioFileClose(fileID);
    } else {
        printf("AudioFileOpenURL failed! result %lu %4.4s\n", result, (char*)&result);
    }
}

@implementation AudioConvert

-(void)handleInterruption:(NSNotification *)notification
{
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    
    printf("Session interrupted! --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan) {
        ThreadStateBeginInterruption();
    }
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeEnded) {
        // make sure we are again the active session
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        ThreadStateEndInterruption();
    }
}

#pragma mark -Audio Session Route Change Notification

- (void)handleRouteChange:(NSNotification *)notification
{
    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    
    printf("Route change:\n");
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"     NewDeviceAvailable");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"     OldDeviceUnavailable");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"     CategoryChange");
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            NSLog(@"     Override");
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            NSLog(@"     WakeFromSleep");
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            NSLog(@"     NoSuitableRouteForCategory");
            break;
        default:
            NSLog(@"     ReasonUnknown");
    }
    
    printf("\nPrevious route:\n");
    NSLog(@"%@", routeDescription);
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (AudioConvert *)sharedInstance
{
    static AudioConvert *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AudioConvert alloc] init];
    });
    return _sharedInstance;
}

- (void)convertAudioSourcePath:(NSString *)source  outPath:(NSString *)destinationFilePath
{
    self.prograss =0;
    
    
    self.willBeginBlock();
    ThreadStateInitalize();
    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
    outputFormat = kAudioFormatMPEG4AAC;
    sampleRate = 44100.0;
    if (IsAACEncoderAvailable())
    {
    } else {
    }
    UpdateFormatInfo(nil, sourceURL);
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
    
    if (error) {

        return;
    }
    // run audio file code in a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        try {
            NSError *error = nil;
            // Configure the audio session
            AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
            
            // our default category -- we change this for conversion and playback appropriately
            [sessionInstance setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
            
            XThrowIfError(error.code, "couldn't set audio category");
            // add interruption handler
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleInterruption:)
                                                         name:AVAudioSessionInterruptionNotification
                                                       object:sessionInstance];
            // we don't do anything special in the route change notification
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleRouteChange:)
                                                         name:AVAudioSessionRouteChangeNotification
                                                       object:sessionInstance];
            // the session must be active for offline conversion
            [sessionInstance setActive:YES error:&error];
            XThrowIfError(error.code, "couldn't set audio session active\n");
        } catch (CAXException e) {
            char buf[256];
            fprintf(stderr, "Error: %s (%s)\n", e.mOperation, e.FormatError(buf));
            printf("You probably want to fix this before continuing!");
        }
        
        
        outputFormat = kAudioFormatMPEG4AAC;
        sampleRate = 44100.0;
        __weak  AudioConvert *weakself = self;
        ProgressBlock block=^(float  rate){
            weakself.prograss =rate;
        };
        OSStatus error = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate,block);

        if (error)
        {
            self.completeBlock(NO);
            
        } else {
            self.completeBlock(YES);
        }
    });
}

@end
