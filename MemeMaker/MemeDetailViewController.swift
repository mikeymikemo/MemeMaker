//
//  MemeDetailViewController.swift
//  MemeMaker
//
//  Created by Michael Montoya on 2/3/17.
//  Copyright © 2017 Michael Montoya. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    //==================================================
    // MARK: Outlets
    //==================================================

    @IBOutlet weak var memeImageView: UIImageView!
    
    //==================================================
    // MARK: Properties
    //==================================================

    var meme: Meme?
    
    //==================================================
    // MARK: Life Cycle
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.memeImageView.image = meme?.memedImage
    }
}
