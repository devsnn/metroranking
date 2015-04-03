//
//  AniView.swift
//  image-scroll-swift
//
//  Created by kim dowan on 2015. 3. 6..
//  Copyright (c) 2015년 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class AniView:SpringView{
    
    @IBOutlet var view: SpringView!
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("AniView", owner: self, options: nil)
        self.addSubview(self.view)
        
        
    }
}
