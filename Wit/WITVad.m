//
//  WITVad.m
//  Wit
//
//  Created by Aric Lasry on 8/6/14.
//  Copyright (c) 2014 Willy Blandin. All rights reserved.
//

#import "WITVad.h"
#import "Wit.h"
#import "WITUploader.h"
#import "WITRecorder.h"

@implementation WITVad {
    s_wv_detector_cvad_state *vad_state;

}



-(void) gotAudioSamples:(NSData *)samples {
    UInt32 size = (UInt32)[samples length];
    short *bytes = (short*)[samples bytes];
    
    int detected_speech = wvs_cvad_detect_talking(self->vad_state, bytes, size / 2);
    
    if ( detected_speech == 1){
        //someone just started talking
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate vadStartedTalking];
        });
    } else if ( detected_speech == 0) {
        //someone just stopped talking
        self.stoppedUsingVad = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate vadStoppedTalking];
        });
    }

}

-(id) init {
    NSLog(@"WITVad init");
    self = [super init];
    self->vad_state = wv_detector_cvad_init(16000,0,10000);
    self.stoppedUsingVad = NO;
    
    return self;
}

-(void) dealloc {
    NSLog(@"Clean WITVad");
    wv_detector_cvad_clean(self->vad_state);
}

@end
