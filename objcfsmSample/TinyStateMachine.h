//
//  TinyStateMachine.h
//  objcfsm
//
//  Created by Uladzislau Susha on 10.01.2013.
//  Copyright (c) 2013 Haryaalcar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNextState @"nextState"
#define kAction @"action"
#define kWillLeaveState @"willleavestate"
#define kDidEnterState @"didenterstate"
#define kFromAnyState @"fromanystate"

#define START_FSM(...) (@{ __VA_ARGS__ })
#define ROW(aState, event, nextState, action )  @[aState , event] : @{kNextState : nextState, kAction : action}
#define START_EXTRA_EVENTS(...) (@{ __VA_ARGS__ })
#define ROW_EXTRA(state, event, action )  @[state , event] : action

@interface TinyStateMachine : NSObject {
    NSString *currentState;
    NSString *fsmName;
}

/**
 * Creates and returns a fsm, defined by scheme
 *
 * @param name used for logging purposes
 * @param startingState staring state
 * @param scheme scheme, which defines the fsm. Defining with macroses START_FSM ROW() in form:
 * START_FSM(
 *  ROW(stateFrom1, event, stateTo0, action1 ),
 *  ROW(stateFrom2, event, stateTo1, action2 ),
 *  ...
 *  ROW(stateFromN, event, stateToN, actionN )
 * )
 * where 'state' and 'event' are NSString constants, and action is a block with no parameters
 * kFromAnyState could be used to cover several rows with identical event and action, but not defined starting states. Will not be processed, if there is explicit starting state.
 *
 * @param additionalEvents scheme, which defines the actions for before leaving and after transitioning events. Defining with macroses START_EXTRA_EVENTS and ROW_EXTRA() in form:
 * START_EXTRA_EVENTS(
 *  ROW_EXTRA(state1, event, action ),
 *  ROW_EXTRA(state2, event, action ),
 *  ...
 *  ROW_EXTRA(stateN, event, action )
 * )
 * where 'event' is in [kWillLeaveState, kDidEnterState]
 *
 * Recursive events and simultaneous calls from multiple threads cause assert.
 *
 */
+ (id)stateMachineWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme additionalEvents:(NSDictionary *)additionalEvents;
- (id)initWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme additionalEvents:(NSDictionary *)additionalEvents;

/**
 * runs the event on the fsm
 * @param event the event, that should br processed
 * @return YES, if transition completed, NO if there is no transition
 */
- (BOOL)processEvent:(NSString *)event;

/**
 * Resets a state of the fsm to the starting one.
 */
- (void)resetToStartingState;

@end
