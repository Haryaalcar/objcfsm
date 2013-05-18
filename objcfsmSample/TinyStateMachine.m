//
//  TinyStateMachine.m
//  objcfsm
//
//  Created by Uladzislau Susha on 10.01.2013.
//  Copyright (c) 2013 Haryaalcar. All rights reserved.
//

#import "TinyStateMachine.h"
#import <libkern/OSAtomic.h>

typedef void(^EmptyBlock)(void);

@interface TinyStateMachine () {
    NSString *startingFSMState;
    NSDictionary *fsmScheme;
    NSDictionary *additionalFSMEvents;
}

@end


@implementation TinyStateMachine

- (id)init {
    return nil;
}

- (id)initWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme additionalEvents:(NSDictionary *)additionalEvents {
    if ((self = [super init])) {
        fsmName = name;
        currentState = startingFSMState = startingState;
        fsmScheme = scheme;
        additionalFSMEvents = additionalEvents;
    }
    return self;
}

+ (id)stateMachineWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme additionalEvents:(NSDictionary *)additionalEvents {
    return [[self alloc] initWithName:name startingState:startingState andScheme:scheme additionalEvents:additionalEvents];
}

- (void)resetToStartingState {
    currentState = startingFSMState;
}

- (BOOL)processEvent:(NSString *)event {
    //Recursive events not allowed
    //Simultaneous calls from multiple threads not allowed
    static BOOL processing = NO;
    if (OSAtomicTestAndSet(YES, &processing)) {
        NSAssert(NO, @"Previous processEvent not finished");
    }

    //findng a row
    NSDictionary *rowInfo = fsmScheme[@[currentState, event]];
    if (!rowInfo) {
        rowInfo = fsmScheme[@[kFromAnyState, event]];
        if (!rowInfo) {
            NSLog(@"%@: There is no transition %@(%@)", fsmName, currentState, event);
            return NO;
        }
    }
    NSString *nextState = rowInfo[kNextState];
    
    //running pre-action
    EmptyBlock leavingStateBlock = additionalFSMEvents[@[currentState, kWillLeaveState]];
    if (leavingStateBlock) {
        NSLog(@"%@: will leave %@", fsmName, currentState);
        leavingStateBlock();
    }
    
    //transition and action
    NSLog(@"%@: %@(%@) -> %@", fsmName, currentState, event, nextState);
    currentState = nextState;
    ((EmptyBlock)rowInfo[kAction])();
    
    //running post-action
    EmptyBlock enteredStateBlock = additionalFSMEvents[@[currentState, kDidEnterState]];
    if (enteredStateBlock) {
        NSLog(@"%@: entered %@", fsmName, currentState);
        enteredStateBlock();
    }

    processing = NO;
    return YES;
}

- (NSString *)description {
    return [fsmScheme description];
}

@end
