//
//  ViewController.swift
//  image-scroll-swift
//
//  Created by Evgenii Neumerzhitckii on 4/10/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

let imageScrollLargeImageName = "metro.png"


class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var imageSizeToggleButton:UIButton!

    @IBOutlet weak var imageConstraintTop:NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight:NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft:NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom:NSLayoutConstraint!
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var nameView:SpringView!
    

    var lastZoomScale:CGFloat = -1
    var is_first:Bool = false
    var items: [String] = ["We", "Heart", "Swift"]
    var is_tableview:Bool = false
    
    var first_tableview_y:CGFloat = 1.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // test2
        
        // test 3
        
        // test4 
    }
    
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        imageView.image = UIImage(named: imageScrollLargeImageName)
        scrollView.delegate = self
        
        if(is_first == false){
            is_first = true
            
            let image = UIImage(named: "t.png") as UIImage?
            let button   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            button.frame = CGRectMake(200, 200, 50, 50)
            button.setImage(image, forState: .Normal)
            button.addTarget(self, action: "metroSpotTapHandler:", forControlEvents:.TouchUpInside)
            
            
            imageView.addSubview(button)
            imageView.userInteractionEnabled = true // click event..
            
            
            first_tableview_y = tableView.frame.origin.y - tableView.frame.size.height
            
            scrollView.maximumZoomScale = 0.7
            
            nameView.hidden = true
            
        }
        
        updateZoom()
    }
    
    
    func toggleNameView(is_show:Bool){
        if(is_show == true){
            nameView.hidden = false
            nameView.animation = "zoomIn"
            nameView.curve = "spring"
            nameView.duration = 1.0
            nameView.scaleX = 2.2
            nameView.scaleY = 2.2
            nameView.animate()
        }else{
            nameView.animation = "zoomOut"
            nameView.curve = "spring"
            nameView.duration = 1.0
            nameView.scaleX = 2.2
            nameView.scaleY = 2.2
            nameView.animate()
            
        }
    }
    
    
    func toggleTableView(is_show:Bool){
        let x = tableView.frame.origin.x
        var y = tableView.frame.height
        let width = tableView.frame.size.width
        let height = tableView.frame.size.height
        
        if(is_show == false){
            y = tableView.frame.origin.y + tableView.frame.size.height
        }else{
            y = first_tableview_y
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.frame = CGRectMake(x, y, width, height)
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    
    
    func metroSpotTapHandler(sender:UIButton!){
        toggleControl()
    }
    
    
    func toggleControl(){
        if(is_tableview == true){
            is_tableview = false
        }else{
            is_tableview = true
        }
        
        toggleTableView(is_tableview)
        toggleNameView(is_tableview)
    }
    
    

    // Update zoom scale and constraints
    // It will also animate because willAnimateRotationToInterfaceOrientation
    // is called from within an animation block
    //
    // DEPRECATION NOTICE: This method is said to be deprecated in iOS 8.0. But it still works.
    /*override func willAnimateRotationToInterfaceOrientation(
    toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {

    println("aaa")
    //super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
    //updateZoom()
    }*/
    

    func updateConstraints() {
        
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height

            let viewWidth = view.bounds.size.width
            let viewHeight = view.bounds.size.height

            // center image if it is smaller than screen
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }

            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }

            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding

            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding

            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }

    // Zoom to show as much image as possible unless image is smaller than screen
    private func updateZoom() {
        if let image = imageView.image{
            var minZoom = min(view.bounds.size.width / image.size.width,
            view.bounds.size.height / image.size.height)
            
            
            if(minZoom > 1){minZoom = 1}

            scrollView.minimumZoomScale = minZoom

            // Force scrollViewDidZoom fire if zoom did not change
            if(minZoom == lastZoomScale){ minZoom += 0.000001 }

            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
            
        }
    }


    // UIScrollViewDelegate
    // -----------------------

    func scrollViewDidZoom(scrollView: UIScrollView) {
        //println("did zoom")
        updateConstraints()
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //println("zooming")
        if(is_tableview == true){
            toggleControl()
        }
        
        return imageView
    }
    
    // UITableViewDelegate
    // -----------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }

}

