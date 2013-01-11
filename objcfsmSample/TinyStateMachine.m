//
//  TinyStateMachine.m
//  objcfsm
//
//  Created by Uladzislau Susha on 10.01.2013.
//  Copyright (c) 2013 Haryaalcar. All rights reserved.
//

#import "TinyStateMachine.h"

@interface TinyStateMachine () {
    NSDictionary *fsmScheme;
}

@end

@implementation TinyStateMachine

- (id)init {
    return nil;
}

- (id)initWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme {
    if ((self = [super init])) {
        fsmName = name;
        currentState = startingState;
        fsmScheme = scheme;
    }
    return self;
}

+ (id)stateMachineWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme {
    return [[self alloc] initWithName:name startingState:startingState andScheme:scheme];
}

- (void)processEvent:(NSString *)event {
    NSDictionary *rowInfo = fsmScheme[@[currentState, event]];
    if (!rowInfo) {
        NSLog(@"%@: There is no transition %@(%@)", fsmName, currentState, event);
        return;
    }
    NSLog(@"%@: %@(%@) -> %@", fsmName, currentState, event, rowInfo[kTo]);
    currentState = rowInfo[kTo];
    ((void (^)())rowInfo[kAction])();
}


@end
