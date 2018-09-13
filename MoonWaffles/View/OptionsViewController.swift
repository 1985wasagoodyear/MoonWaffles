//
//  OptionsViewController.swift
//  MoonWaffles
//
//  Created by Kevin Yu on 9/13/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

final class OptionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let CELL_IDENTIFIER = "Cell"
    
    weak var delegate: OptionsProtocol!
    
    private var options = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        
        if let settingsURL = Bundle.main.path(forResource: "WaffleOptions", ofType: "plist") {
            let vals = NSDictionary(contentsOfFile: settingsURL)
            self.options = vals?.allKeys as! [String]
        }
    }
    
}

extension OptionsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        let name = self.options[indexPath.row]
        if let image = UIImage(named: name) {
            cell.imageView?.image = image
        }
        else {
            cell.imageView?.image = UIImage(named: "superWaffle")
        }
        cell.textLabel?.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelectNewOption(self.options[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
