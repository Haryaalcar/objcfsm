//
//  TinyStateMachine.m
//  objcfsm
//
//  Created by Uladzislau Susha on 10.01.2013.
//  Copyright (c) 2013 Haryaalcar. All rights reserved.
//

#import "TinyStateMachine.h"

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
    NSDictionary *rowInfo = fsmScheme[@[currentState, event]];
    if (!rowInfo) {
        NSLog(@"%@: There is no transition %@(%@)", fsmName, currentState, event);
        return NO;
    }
    
    EmptyBlock leavingStateBlock = additionalFSMEvents[@[currentState, kWillLeaveState]];
    if (leavingStateBlock) {
        NSLog(@"%@: will leave %@", fsmName, currentState);
        leavingStateBlock();
    }
    
    NSLog(@"%@: %@(%@) -> %@", fsmName, currentState, event, rowInfo[kTo]);
    currentState = rowInfo[kTo];
    ((EmptyBlock)rowInfo[kAction])();
    
    EmptyBlock enteredStateBlock = additionalFSMEvents[@[currentState, kDidEnterState]];
    if (enteredStateBlock) {
        NSLog(@"%@: entered %@", fsmName, currentState);
        enteredStateBlock();
    }
    return YES;
}

- (NSString *)description {
    return [fsmScheme description];
}

@end
