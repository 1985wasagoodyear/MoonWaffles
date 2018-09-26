//
//  WaffleImageView.swift
//  MoonWaffles
//
//  Created by Kevin Yu on 9/13/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

final class WaffleImageView: UIImageView {
    
    private convenience init() {
        self.init("superWaffle")
    }
    
    internal required convenience init?(coder aDecoder: NSCoder) {
        self.init("superWaffle")
    }
    
    private init(_ name: String) {
        if let image = UIImage(named: name) {
            super.init(image: image)
        }
        else {
            super.init(image: UIImage(named: "superWaffle"))
        }
        self.contentMode = .scaleAspectFit
        self.layer.masksToBounds = false
    }
    
    static func newWaffle() -> WaffleImageView {
        let waffle = WaffleImageView()
        waffle.frame = CGRect(x: 0,
                              y: 0,
                              width: 80,
                              height: 80)
        return waffle
    }
    
    static func newWaffle(_ nameString: String?) -> WaffleImageView {
        if let name = nameString {
            let waffle = WaffleImageView.init(name)
            waffle.frame = CGRect(x: 0,
                                  y: 0,
                                  width: (waffle.image?.size.width)! / 2.0,
                                  height: (waffle.image?.size.height)! / 2.0)
            return waffle
        }
        else {
            return newWaffle()
        }
    }

}
