//
//  Sound.m
//  Detector
//
//  Created by Ben Smith on 01/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"


@implementation Sound
@synthesize player,soundFinished,funnyClips,funnyClipsPlayer,soundOn;


static Sound *sharedSingleton = nil;
+ (Sound*) retrieveSingleton {
    @synchronized(self) {
        if (sharedSingleton == nil) {
            sharedSingleton = [[Sound alloc] init];
        }
    }
    return sharedSingleton;
}

+ (id) allocWithZone:(NSZone *) zone {
    @synchronized(self) {
        if (sharedSingleton == nil) {
            sharedSingleton = [super allocWithZone:zone];

            return sharedSingleton;
        }
    }
    return nil;
}


//intialise instance of sound class and return
//-(id)init
//{
//	soundFinished = TRUE;
//	if (self = [super init])
//	{
//		funnyClipsPlayer = [[NSMutableArray alloc] init];
//		funnyClips = [[NSMutableArray alloc] init];
//	}
//	return self;
//}

//intialise one sound file
-(void) initialiseSound:(NSString*)soundFile
{
    soundOn = TRUE;
    soundFinished = FALSE;
    NSString *path = [[NSBundle mainBundle] pathForResource:soundFile ofType:@"mp3"];
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    self.player = [ [AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil];
    //sets the player to a ready state
    [self.player prepareToPlay];
}

//intialise and array of sound files
-(void)initWithSounds:(NSArray*)arraySound
{
    soundOn = TRUE;

    funnyClipsPlayer = [[NSMutableArray alloc] init];
    funnyClips = [[NSMutableArray alloc] init];
    for (NSString* snd in arraySound) 
    {
        NSLog(@"   INITIALISING SOUND    %s",[snd UTF8String]);
        [self addSoundToQueue:snd];
        //[funnyClips addObject:snd];
    }
}

-(void)addSoundToQueue:(NSString*)snd
{
    NSError *error;
	[funnyClips addObject:snd];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],snd]];
	//NSString *path = [[NSBundle mainBundle] pathForResource:snd ofType:@"mp3"];
	//NSURL *filePath = [NSURL fileURLWithPath:url isDirectory:NO];
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	//sets the player to a ready state
    if(error){
        NSLog(@"%@",error);
    }
    else
    {
        [self.player prepareToPlay];
        [funnyClipsPlayer addObject:self.player];
    }
}

-(void) prepareSound:(AVAudioPlayer*)sound{
	[sound prepareToPlay];
}

-(void) playSound:(AVAudioPlayer*)sound numberofTimes:(int)loops
{
    //if(soundOn)
    {
        sound.numberOfLoops = loops;
        sound.delegate=self;
        [sound play];
    }
}

-(void) fadeSound
{
	pthread_mutex_lock( &(self->lock) );
	
	if(self.player.volume <= 0.00) {
		[self.player stop];
		pthread_mutex_unlock(&(self->lock));
	}
	else {
		self.player.volume -= .20;
		pthread_mutex_unlock(&(self->lock));
		[self performSelector:@selector(fadeSound) withObject:nil 
				   afterDelay:.1];
	}
}

-(void) fadeSound:(AVAudioPlayer*)sound
{
	pthread_mutex_lock( &(self->lock) );
	
	if(sound.volume <= 0.00) {
		[sound stop];
		pthread_mutex_unlock(&(self->lock));
	}
	else {
		sound.volume -= .20;
		pthread_mutex_unlock(&(self->lock));
		[self performSelector:@selector(fadeSound:) withObject:nil
				   afterDelay:.1];
	}
}


#pragma mark AV Foundation delegate methods____________
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
	//printf("             Sound Finished Playing          ");
	NSString *urlString = [appSoundPlayer.url absoluteString];
	NSArray *myArray = [urlString componentsSeparatedByString: @"/"];
	NSString *fileName = (NSString*)[myArray lastObject];
	
	//printf("        Finished playing URL      %s   ",[fileName UTF8String]);
	for (NSString* soundCompare in self.funnyClips) 
	{
		/*
		urlString2 = [soundCompare.url absoluteString];
		myArray = [urlString componentsSeparatedByString: @"/"];
		fileName2 = (NSString*)[myArray lastObject];
		NSLog(@"   Compare Sound    %s",[fileName2 UTF8String]);
		 */
		//NSLog(@"   Compare Sound %s",[soundCompare UTF8String]);
		if([fileName isEqualToString: [soundCompare stringByAppendingString:@".mp3"]] )
		{
			//printf("             Sound Finished == TRUE          ");
			soundFinished = TRUE;
		}

	}
	/*
	printf("        Finished playing URL      %s   ",[fileName UTF8String]);
	if([fileName isEqualToString: @"scan.mp3"] == YES) 
		soundFinished = TRUE;
	if([fileName isEqualToString: @"PlasmaRifle.wav"] == YES) 
		soundFinished = TRUE;
	if([fileName isEqualToString: @"Elec.wav"] == YES) 
		soundFinished = TRUE;
	 */
	//[appSoundButton setEnabled: YES];
}

- (void) audioPlayerBeginInterruption: player {
	
	NSLog (@"Interrupted. The system has paused audio playback.");
	
	if (soundFinished) {
		
		soundFinished = NO;
		//interruptedOnPlayback = YES;
	}
}


//- (void) audioPlayerEndInterruption: player {
//	
//	NSLog (@"Interruption ended. Resuming audio playback.");
//	
//	// Reactivates the audio session, whether or not audio was playing
//	//		when the interruption arrived.
//	
//	[[AVAudioSession sharedInstance] setActive: YES error: nil];
//	
//	if (interruptedOnPlayback) {
//		
//		[appSoundPlayer prepareToPlay];
//		[appSoundPlayer play];
//		playing = YES;
//		interruptedOnPlayback = NO;
//	}
//	 
//}
@end
