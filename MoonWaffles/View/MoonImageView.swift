//
//  MoonImageView.swift
//  MoonWaffles
//
//  Created by Kevin Yu on 9/27/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

class MoonImageView: UIImageView {
    var delegate: MoonProtocol! {
        didSet {
            self.isUserInteractionEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //   super.touchesBegan(touches, with: event)  // invokes the rest of the responder chain; superview
        self.delegate.didTouchMoon()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  super.touchesMoved(touches, with: event)
        if let touch = touches.first?.location(in: self.superview) {
            self.delegate.didMoveMoon(Double(touch.x), Double(touch.y))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  super.touchesEnded(touches, with: event)
        self.delegate.didReleaseMoon()
        
    }
    

}
