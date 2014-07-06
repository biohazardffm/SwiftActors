//
//  Actor.swift
//  Swactor
//
//  Created by Tomek on 05.07.2014.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Foundation


class Actor {
    
    var dispatchQueue:dispatch_queue_t?
    var queue: Array<AnyObject>
    
    init() {
        queue = Array()
    }
    
    func put(message:AnyObject) {
        queue.insert(message, atIndex: 0)
        act()
    }
    
    func act() {
        while (queue.count > 0) {
            let msg:AnyObject = queue.removeLast()
            dispatch_async(dispatchQueue!) {
                self.receive(msg)
            }
        }
    }
    
    // You shall override this function
    func receive(message:AnyObject) {
        
    }
    
}

class ActorUI : Actor {
    
}


class ActorRef {
    var actor:Actor
    var queue:dispatch_queue_t
    
    init(actor:Actor, queue:dispatch_queue_t) {
        self.actor = actor
        self.actor.dispatchQueue = queue
        self.queue = queue
    }
    
    func accept(message:AnyObject) {
        self.actor.receive(message)
    }
}

class ActorSystem {
   
    var serialQueue:dispatch_queue_t

    init() {
        self.serialQueue =  dispatch_queue_create("net.japko.serial", DISPATCH_QUEUE_SERIAL)
    }
    
    func actorOf(actor:Actor) -> ActorRef {
        return ActorRef(actor: actor, queue:serialQueue)
    }
    
}

operator infix ! {}

@infix func ! (left:ActorRef, right:AnyObject) -> Void {
        left.accept(right)
}

