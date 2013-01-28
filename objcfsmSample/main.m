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
#define kEvent4 @"event4"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        TinyStateMachine *fsm = [TinyStateMachine stateMachineWithName:@"SampleFSM"
                                                         startingState:kState1
                                                             andScheme:
                                 START_FSM(
                                           ROW(kState1,         kEvent1, kState2, ^{NSLog(@"action1");}),
                                           ROW(kState2,         kEvent3, kState3, ^{NSLog(@"action3");}),
                                           ROW(kState3,         kEvent3, kState4, ^{NSLog(@"action4");}),
                                           ROW(kState3,         kEvent4, kState2, ^{NSLog(@"action5");}),
                                           ROW(kFromAnyState,   kEvent2, kState3, ^{NSLog(@"action from Any state");}),
                                           )
                                                      additionalEvents:
                                 START_EXTRA_EVENTS(
                                                    ROW_EXTRA(kState1, kWillLeaveState, ^{NSLog(@"action will leave state1");}),
                                                    ROW_EXTRA(kState2, kDidEnterState,  ^{NSLog(@"action entered state2");}),
                                                    ROW_EXTRA(kState3, kDidEnterState,  ^{NSLog(@"action entered state3");})
                                                    )
                                 ];
        [fsm processEvent:kEvent1];
        [fsm processEvent:kEvent2];
        [fsm processEvent:kEvent3];
        [fsm processEvent:kEvent4];
    }

    return 0;
}

