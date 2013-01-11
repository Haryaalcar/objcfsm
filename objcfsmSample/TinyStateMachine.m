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
        currentState = startingState;
        fsmScheme = scheme;
        additionalFSMEvents = additionalEvents;
    }
    return self;
}

+ (id)stateMachineWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme additionalEvents:(NSDictionary *)additionalEvents {
    return [[self alloc] initWithName:name startingState:startingState andScheme:scheme additionalEvents:additionalEvents];
}

- (void)processEvent:(NSString *)event {
    NSDictionary *rowInfo = fsmScheme[@[currentState, event]];
    if (!rowInfo) {
        NSLog(@"%@: There is no transition %@(%@)", fsmName, currentState, event);
        return;
    }

    EmptyBlock leavingStateRowBlock = additionalFSMEvents[@[currentState, kWillLeaveState]];
    if (leavingStateRowBlock) {
        NSLog(@"%@: will leave %@", fsmName, currentState);
        leavingStateRowBlock();
    }

    NSLog(@"%@: %@(%@) -> %@", fsmName, currentState, event, rowInfo[kTo]);
    currentState = rowInfo[kTo];
    ((void (^)())rowInfo[kAction])();

    EmptyBlock enteredStateBlock = additionalFSMEvents[@[currentState, kDidEnterState]];
    if (enteredStateBlock) {
        NSLog(@"%@: entered %@", fsmName, currentState);
        enteredStateBlock();
    }
}

- (NSString *)description {
    return [fsmScheme description];
}

@end
