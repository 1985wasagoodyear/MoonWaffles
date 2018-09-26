//
//  MissionControlViewController.swift
//  MoonWaffles
//
//  Created by Kevin Yu on 9/13/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

final class MissionControlViewController: UIViewController, OptionsProtocol {

    @IBOutlet weak var optionsButton: UIButton!
    
    var animator : UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!

    var waffles = Set<WaffleImageView>()
    
    var waffleCount = 0
    
    var waffleOption: String!
    
    var moon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.gravityBehavior = UIGravityBehavior(items: [])
        gravityBehavior.magnitude = -0.4
        self.animator.addBehavior(gravityBehavior)
        
        moon = UIImageView(image: UIImage(named: "superMoon"))
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
        
        
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(intervalUpdate),
                             userInfo: nil,
                             repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moon.center = CGPoint(x: self.view.center.x, y: 100.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self.view)
        
        // create a new waffle
        let newWaffle = WaffleImageView.newWaffle(self.waffleOption)
        newWaffle.center = location!
        self.view.addSubview(newWaffle)

        self.waffles.insert(newWaffle)

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
        if (!moon.superview!.frame.intersects(moon.frame)) {
            let center = CGPoint(x: moon.superview!.center.x, y: 100.0)
            self.collisionBehavior.removeItem(moon)
            moon.alpha = 0.5
            UIView.animate(withDuration: 2.0, animations: { [unowned self] in
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
    
    func didSelectNewOption(_ option: String) {
        self.waffleOption = option;
    }
    
}

