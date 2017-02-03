//
//  SentMemesCollectionViewController.swift
//  MemeMaker
//
//  Created by Michael Montoya on 2/3/17.
//  Copyright © 2017 Michael Montoya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCVCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    //==================================================
    // MARK: Outlets
    //==================================================

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
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
        
        flowLayoutSetup(size: view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.reloadInputViews()
        self.collectionView?.reloadData()
    }
    
    
    //==================================================
    // MARK: Flow Layout
    //==================================================
    
    func flowLayoutSetup(size: CGSize) {
        
        let space: CGFloat = 2.0
        let dimension: CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 6.0: (size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        flowLayoutSetup(size: size)
    }
    
    
    //==================================================
    // MARK: DataSource Functions
    //==================================================
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MemeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.memeImageView.image = self.memes[indexPath.row].memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destinationVC = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController else { return  }
        
       destinationVC.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}



