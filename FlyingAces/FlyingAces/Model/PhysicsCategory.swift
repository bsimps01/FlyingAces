//
//  PhysicsCategory.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 10/17/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let Vacant: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Enemy: UInt32 = 0b10
    static let Bullet: UInt32 = 0b100
}
