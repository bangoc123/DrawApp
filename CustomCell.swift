//
//  CustomCell.swift
//  DrawApp
//
//  Created by Ngoc on 9/24/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit


let kCellWidth = 50
class CustomCell: UICollectionViewCell {
    var colorFilter: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    func addSubviews(){
        if(colorFilter == nil){
            colorFilter = UIImageView(frame: CGRect(x: 0, y: 0, width: kCellWidth, height: kCellWidth))
            colorFilter.layer.borderColor = tintColor.CGColor
            contentView.addSubview(colorFilter)
            NSNotificationCenter.defaultCenter().addObserver(self, selector:  #selector(unselectColor), name: "EraserSelection", object: nil)
        
        }
    
    }
    
    override var selected: Bool{
        didSet{
            colorFilter.layer.borderWidth = selected ? 2 : 0
            
            NSNotificationCenter.defaultCenter().postNotificationName("ColorSelection", object: nil, userInfo: nil)
        }
    
    }
    
    
    func unselectColor(){
        colorFilter.layer.borderWidth = 0.0
    }

}
    
    
    

