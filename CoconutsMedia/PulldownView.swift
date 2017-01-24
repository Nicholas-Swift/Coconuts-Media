//
//  PulldownView.swift
//  CoconutsMedia
//
//  Created by Nicholas Swift on 1/10/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

protocol PulldownViewDelegate {
    func citySelected(city: String)
}

class PulldownView: UIView {
    
    // Variables
    
    var isUp = true
    var delegate: PulldownViewDelegate?
    
    // UI Elements
    
    var tableView: UITableView!
    
    // View
    
    override init(frame: CGRect) {
        
        let newFrame = CGRect(x: 0.0, y: 64.5 - frame.size.height, width: frame.size.width, height: frame.size.height)
        
        super.init(frame: newFrame)
        
        // Setup table view with frame
        let tableFrame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        tableView = UITableView(frame: tableFrame, style: .plain)
        
        // Setup Style
        styleSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Functionality

extension PulldownView {
    
    func functionalitySetup() {
        
    }
    
    func tapped() {
        if isUp {
            goDown()
        }
        else {
            goUp()
        }
    }
    
    func goUp() {
        UIView.animate(withDuration: 0.2) {
            // pull up baby!
            self.frame.origin.y = -self.frame.size.height - 64
            self.isUp = true
        }
    }
    
    func goDown() {
        UIView.animate(withDuration: 0.2) {
            // pull down baby!
            self.frame.origin.y = 64
            self.isUp = false
        }
    }
    
}

// MARK: Style

extension PulldownView {
    
    func styleSetup() {
        
        // Set up background
        backgroundColor = UIColor.red;
        
        // Set up tableView
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        self.addSubview(tableView)
        
        tableView.separatorColor = UIColor.clear
    }
    
}

// MARK: Table View

extension PulldownView: UITableViewDelegate, UITableViewDataSource {
    
    func registerCell() {
        let nib: UINib = UINib(nibName: "CityTableViewXib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CityTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CityManager.cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell") as! CityTableViewCell
        cell.cityLabel.text = CityManager.cities[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.citySelected(city: CityManager.cities[indexPath.row])
    }
    
}
