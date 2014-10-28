//
//  Sound.h
//  Detector
//
//  Created by Ben Smith on 01/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <pthread.h>

@interface Sound : NSObject <AVAudioPlayerDelegate>{
	AVAudioPlayer *player;
	pthread_mutex_t lock;
	Boolean soundFinished;
	NSMutableArray *funnyClips;
	NSMutableArray *funnyClipsPlayer;
    BOOL soundOn;
}
@property (nonatomic) BOOL soundOn;
@property (nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic) Boolean soundFinished;
@property (nonatomic,strong) NSMutableArray *funnyClips;
@property (nonatomic,strong)NSMutableArray *funnyClipsPlayer;

+ (Sound*) retrieveSingleton;
-(void) initialiseSound:(NSString *)soundFile;
-(void) playSound:(AVAudioPlayer*)sound numberofTimes:(int)loops;
//-(void) playSound:(int)loops;
-(void) fadeSound;
-(void)initWithSounds:(NSArray*)arraySound;
-(void)addSoundToQueue:(NSString*)snd;
-(void) prepareSound:(AVAudioPlayer*)sound;
-(void) fadeSound:(AVAudioPlayer*)sound;

@end
