//
//  NTHCollectionCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 17/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHConnectionsCellView: UIView {

    /// views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    
    @IBOutlet weak var firstConnection: UIButton!
    @IBOutlet weak var secondConnection: UIButton!
    
    typealias ConnectionTappedBlock = () -> Void
    private var firstConnectionBlock: ConnectionTappedBlock?
    private var secondConnectionBlock: ConnectionTappedBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.bottomSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.backgroundColor = UIColor.NTHWhiteSmokeColor()
        self.titleLabel.textColor = UIColor.NTHCadetGrayColor()
        self.firstConnection.backgroundColor = UIColor.clearColor()
        self.secondConnection.backgroundColor = UIColor.clearColor()
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if (self.subviews.count == 0) {
            let nib = UINib(nibName: "NTHConnectionsCellView", bundle: nil)
            let loadedView = nib.instantiateWithOwner(nil, options: nil).first as NTHConnectionsCellView
            
            /// set view as placeholder is set
            loadedView.frame = self.frame
            loadedView.autoresizingMask = self.autoresizingMask
            loadedView.setTranslatesAutoresizingMaskIntoConstraints(self.translatesAutoresizingMaskIntoConstraints())
            
            for constraint in self.constraints() as [NSLayoutConstraint] {
                var firstItem = constraint.firstItem as NTHConnectionsCellView
                if firstItem == self {
                    firstItem = loadedView
                }
                
                var secondItem = constraint.secondItem as NTHConnectionsCellView?
                if secondItem != nil {
                    if secondItem! == self {
                        secondItem = loadedView
                    }
                }
                
                loadedView.addConstraint(NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
            }
            
            return loadedView
        }
        
        return self
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title.uppercaseString
    }
    
    func setFirstConnection(connection: Connection, withBlock block: ConnectionTappedBlock) {
        self.firstConnectionBlock = block
        let data = ThumbnailCache.sharedInstance.read(connection.thumbnailKey ?? "")
        
        if let d = data {
            let image = UIImage(data: d)
            self.firstConnection.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    func setSecondConnection(connection: Connection, withBlock block: ConnectionTappedBlock) {
        self.secondConnectionBlock = block
    }
    
    @IBAction func firstConnectionTapped(sender: AnyObject) {
        self.firstConnectionBlock?()
    }
    
    @IBAction func secondConnectionTapped(sender: AnyObject) {
        self.secondConnectionBlock?()
    }
    
    func setEnabled(enabled: Bool) {
        if enabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.5
        }
    }
}
