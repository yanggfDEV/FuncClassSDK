//
//  DingSound.m
//  EnglishTalk
//
//  Created by DING FENG on 9/1/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "DingSound.h"
#import "MHAudioBufferPlayer.h"
#import "Synth.h"
@implementation DingSound
{


	MHAudioBufferPlayer *_player;
	Synth *_synth;
	NSLock *_synthLock;

}




- (id)init
{
    self = [super init];
    if (self) {
        
        [self setUpAudioBufferPlayer];

    }
    return self;
}

+ (DingSound *)sharedInstance
{
    static DingSound *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DingSound alloc] init];
    });
    return _sharedInstance;
}


- (void)setUpAudioBufferPlayer
{
	// We need a lock because we update the Synth's state from the main thread
	// whenever the user presses a button, but we also read its state from an
	// audio thread in the MHAudioBufferPlayer callback. Doing both at the same
	// time is a bad idea and the lock prevents that.
	_synthLock = [[NSLock alloc] init];
    
	// The Synth and the MHAudioBufferPlayer must use the same sample rate.
	// Note that the iPhone is a lot slower than a desktop computer, so choose
	// a sample rate that is not too high and a buffer size that is not too low.
	// For example, a buffer size of 800 packets and a sample rate of 16000 Hz
	// means you need to fill up the buffer in less than 0.05 seconds. If it
	// takes longer, the sound will crack up.
	float sampleRate = 16000.0f;
    
	_synth = [[Synth alloc] initWithSampleRate:sampleRate];
    
	_player = [[MHAudioBufferPlayer alloc] initWithSampleRate:sampleRate
													 channels:1
											   bitsPerChannel:16
											 packetsPerBuffer:1024];
	_player.gain = 0.9f;
    
	__block __weak DingSound *weakSelf = self;
	_player.block = ^(AudioQueueBufferRef buffer, AudioStreamBasicDescription audioFormat)
	{
		DingSound *blockSelf = weakSelf;
		if (blockSelf != nil)
		{
			// Lock access to the synth. This callback runs on an internal
			// Audio Queue thread and we don't want to allow any other thread
			// to change the Synth's state while we're still filling up the
			// audio buffer.
			[blockSelf->_synthLock lock];
            
			// Calculate how many packets fit into this buffer. Remember that a
			// packet equals one frame because we are dealing with uncompressed
			// audio; a frame is a set of left+right samples for stereo sound,
			// or a single sample for mono sound. Each sample consists of one
			// or more bytes. So for 16-bit mono sound, each packet is 2 bytes.
			// For stereo it would be 4 bytes.
			int packetsPerBuffer = buffer->mAudioDataBytesCapacity / audioFormat.mBytesPerPacket;
            
			// Let the Synth write into the buffer. The Synth just knows how to
			// fill up buffers in a particular format and does not care where
			// they come from.
			int packetsWritten = [blockSelf->_synth fillBuffer:buffer->mAudioData frames:packetsPerBuffer];
            
			// We have to tell the buffer how many bytes we wrote into it.
			buffer->mAudioDataByteSize = packetsWritten * audioFormat.mBytesPerPacket;
            
			[blockSelf->_synthLock unlock];
		}
	};
    
	[_player start];
}

- (void)keyDown:(int ) MIDInotenumber
{

	[_synthLock lock];
	// The tag of each button corresponds to its MIDI note number.
	int midiNote = MIDInotenumber;
	[_synth playNote:midiNote];
	[_synthLock unlock];
}

- (void)keyUp:(int ) MIDInotenumber
{

	[_synthLock lock];
	[_synth releaseNote:MIDInotenumber];
	[_synthLock unlock];
}
- (void)keyDownUp:(int ) MIDInotenumber
{

	[_synthLock lock];
	// The tag of each button corresponds to its MIDI note number.
	int midiNote = MIDInotenumber;
	[_synth playNote:midiNote];
	[_synthLock unlock];
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_synthLock lock];
        [_synth releaseNote:MIDInotenumber];
        [_synthLock unlock];
    });
}





@end
