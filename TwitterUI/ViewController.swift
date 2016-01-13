//
//  ViewController.swift
//  TwitterUI
//
//  Created by Peyman Khanjan on 12/01/2016.
//  Copyright © 2016 Snupps. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let offsetHeaderStop:CGFloat // At this offset the Header stops its transformations
    let offsetBLabelHeader:CGFloat // At this offset the Black label reaches the Header
    let distanceWLabelHeader:CGFloat = 40 // The distance between the top of the screen and the top of the White Label

    private let navTitleLabel = UILabel()
    private let tableView = UITableView()
    private let headerView = UIView()
    private let imageView = UIImageView(image: UIImage(named: "HeaderImg"))
    private let visualEffectView = UIVisualEffectView()
    
    private let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.offsetHeaderStop = self.screenWidth - 67
        self.offsetBLabelHeader = self.offsetHeaderStop + 10
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navTitleLabel.text = "Cafe Latte"
        self.navTitleLabel.textColor = UIColor.whiteColor()
        
        self.visualEffectView.effect = UIBlurEffect(style: .Dark)
        self.visualEffectView.alpha = 0
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.headerView.clipsToBounds = true
        let touchgesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.headerView.addGestureRecognizer(touchgesture)
        
        self.headerView.addSubview(self.imageView)
        self.headerView.addSubview(self.visualEffectView)
        self.headerView.addSubview(self.navTitleLabel)
        
        self.view.addSubview(self.headerView)
        
        self.tableView.addSubview(self.headerView)
        self.view.addSubview(self.tableView)
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.screenWidth, 0, 0, 0)
        self.tableView.contentOffset = CGPointMake(0, -self.screenWidth)
        
        self.applyLayout()
    
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tweetCell")
        self.tableView.registerClass(CustomTitleCell.self, forCellReuseIdentifier: "titleCell")
        
        self.tableView.reloadData()
    }
    
    func handleTap(gesture: UIGestureRecognizer) {
        NSLog("whatever")
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + self.headerView.bounds.height
        
        var headerTransform = CATransform3DIdentity
        
        let setTransform = { () -> Void in
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-self.offsetHeaderStop, -offset), 0)
        }
        if offset >= 0 {
            setTransform()
            // ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-self.distanceWLabelHeader, self.offsetBLabelHeader - offset), 0)
            self.navTitleLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            self.visualEffectView.alpha = min (1.0, (offset - self.offsetBLabelHeader) / self.distanceWLabelHeader)
        } else if offset > -self.screenWidth {
            setTransform()
        }
        
        headerView.layer.transform = headerTransform
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.headerView.frame.maxY, 0, 0, 0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        
        return 45
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let retVal = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! CustomTitleCell
            retVal.titleLabel.text = self.navTitleLabel.text
            
            return retVal
        } else {
            let retVal = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath)
            retVal.textLabel?.text = "Tweet Tweet! IndexPath = \(indexPath.row)"
            
            return retVal
        }
    }
    
    private func applyLayout() {
        self.headerView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(self.screenWidth)
        }
        
        self.imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.headerView)
        }
        
        
        self.visualEffectView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.headerView)
        }
        
        self.navTitleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.headerView)
            make.top.equalTo(self.headerView.snp_bottom)
        }
        
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
}

