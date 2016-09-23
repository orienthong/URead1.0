//
//  FourthViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/19/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import ElasticTransition

class FourthViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ElasticMenuTransitionDelegate {
    
    var dismissByForegroundDrag: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("customCollectionCell", forIndexPath: indexPath) as! customCollectionViewCell
        cell.configureCell(withImage: UIImage(named: "img_01")!, userName: "Chataa", messageText: "I love You", dateText: "YesterDay 10:23")
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        return CGSizeMake(CGRectGetWidth(self.view.bounds), layout.itemSize.height)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
