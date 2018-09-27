//
//  MoonProtocol.swift
//  MoonWaffles
//
//  Created by Kevin Yu on 9/27/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import Foundation

protocol MoonProtocol: class {
    func didTouchMoon()
    func didMoveMoon(_ locX: Double, _ locY: Double)
    func didReleaseMoon()
}
