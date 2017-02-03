//
//  SentMemesTableViewController.swift
//  MemeMaker
//
//  Created by Michael Montoya on 2/3/17.
//  Copyright © 2017 Michael Montoya. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    
    //==================================================
    // MARK: Properties
    //==================================================
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    //==================================================
    // MARK: Life cycle
    //==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    //==================================================
    // MARK: Data source
    //==================================================
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memeTVC", for: indexPath) as? MemeTableViewCell else { return UITableViewCell() }
        
        // Configure the cell...
        cell.memeTextLabel.text = self.memes[indexPath.row].bottomText + " " + self.memes[indexPath.row].topText
        cell.memeImageView.image = self.memes[indexPath.row].memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationVC = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController else { return  }
        
        destinationVC.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }}
    
}


