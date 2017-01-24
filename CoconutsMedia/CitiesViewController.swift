//
//  CitiesViewController.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 12/9/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController {
    
    // UI Elements
    @IBOutlet var cityButtons: [UIButton]!
    
    
    // View Controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        let button = sender as! UIButton
        
        destination.city = button.titleLabel?.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up buttons
        for button in cityButtons {
            button.addTarget(self, action: #selector(segueToViewController(sender:)), for: .touchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Helpers
    func segueToViewController(sender: AnyObject) {
        performSegue(withIdentifier: "toViewController", sender: sender)
    }
    
}
