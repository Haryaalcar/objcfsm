//
//  main.m
//  objcfsmSample
//
//  Created by Uladzislau Susha on 11.01.2013.
//  Copyright (c) 2013 Haryaalcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TinyStateMachine.h"

#define kState1 @"state1"
#define kState2 @"state2"
#define kState3 @"state3"
#define kState4 @"state4"

#define kEvent1 @"event1"
#define kEvent2 @"event2"
#define kEvent3 @"event3"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        TinyStateMachine *fsm = [TinyStateMachine stateMachineWithName:@"SampleFSM"
                                                         startingState:kState1
                                                             andScheme:
                                 START_FSM(
                                           ROW(kState1, kEvent1, kState2, ^{NSLog(@"action1!!!");}),
                                           ROW(kState1, kEvent2, kState3, ^{NSLog(@"action2!!!");}),
                                           ROW(kState2, kEvent3, kState3, ^{NSLog(@"action3!!!");}),
                                           ROW(kState3, kEvent3, kState4, ^{NSLog(@"action4!!!");})
                                           )
                                 ];
        [fsm processEvent:kEvent1];
        [fsm processEvent:kEvent2];
        [fsm processEvent:kEvent3];
    }

    return 0;
}

