//
//  MissionControlViewController.swift
//  MoonWaffles
//
//  Created by Kevin Yu on 9/13/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

final class MissionControlViewController: UIViewController, OptionsProtocol, MoonProtocol {

    @IBOutlet weak var optionsButton: UIButton!
    
    var animator : UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!

    var waffles = Set<WaffleImageView>()
    var newWaffle: WaffleImageView!
    
    var waffleCount = 0
    
    var waffleOption: String!
    
    var moon: MoonImageView!
    
    var timer: Timer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.gravityBehavior = UIGravityBehavior(items: [])
        gravityBehavior.magnitude = -0.4
        self.animator.addBehavior(gravityBehavior)
        
        moon = MoonImageView(image: UIImage(named: "superMoon"))
        moon.delegate = self
        moon.contentMode = .scaleAspectFit
        
        moon.frame = CGRect(x: self.view.center.x - 40.0,
                            y: 100.0,
                            width: 80.0,
                            height: 80.0)
        self.view.addSubview(moon)
        
        self.collisionBehavior = UICollisionBehavior(items: [moon])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .items
        
        animator.addBehavior(collisionBehavior)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(intervalUpdate),
                                          userInfo: nil,
                                          repeats: true)
       //  moon.center = CGPoint(x: self.view.center.x, y: 100.0)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self.view)
        
        // create a new waffle
        self.newWaffle = WaffleImageView.newWaffle(self.waffleOption)
        newWaffle.center = location!
        self.view.addSubview(newWaffle)
        
        self.waffles.insert(newWaffle)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self.view)
        newWaffle.center = location!
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gravityBehavior.addItem(newWaffle)
        self.collisionBehavior.addItem(newWaffle)
    }
    
    @objc func intervalUpdate() {
        // remove waffles out of screen
        for waffle in self.waffles {
            if (!(waffle.superview?.frame)!.intersects(waffle.frame)) {
                waffle.removeFromSuperview()
                self.waffles.remove(waffle)
                self.waffleCount += 1
                // print("did remove waffle \(waffleCount)");
            }
        }
        
        // put the moon back
        self.resetTheMoon()
    }
    
    func resetTheMoon() {
        if (!moon.superview!.frame.intersects(moon.frame) || self.moon.alpha < 1.0) {
            let center = CGPoint(x: moon.superview!.center.x, y: 100.0)
            self.collisionBehavior.removeItem(moon)
            moon.alpha = 0.5
            UIView.animate(withDuration: 1.5, animations: { [unowned self] in
                self.moon.center = center
                self.moon.layoutIfNeeded()
            }) { [unowned self] (completed) in
                if (completed == true) {
                    self.collisionBehavior.addItem(self.moon)
                    self.moon.alpha = 1.0
                }
            }
        }
    }
    
    @IBAction func optionsButtonAction(_ sender: Any) {
        let optionsVC = self.storyboard?.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        optionsVC.delegate = self
        self.present(optionsVC, animated: true, completion: nil)
        
    }
    
    // MARK: OptionsProtocol Delegate Methods
    
    func didSelectNewOption(_ option: String) {
        self.waffleOption = option;
    }
    
    // MARK: MoonProtocol Delegate Methods
    
    func didTouchMoon() {
        self.collisionBehavior.removeItem(moon)
    }
    
    func didMoveMoon(_ locX: Double, _ locY: Double) {
        self.moon.center = CGPoint(x: locX, y: locY)
    }
    
    func didReleaseMoon() {
        self.collisionBehavior.addItem(self.moon)
    }
}

