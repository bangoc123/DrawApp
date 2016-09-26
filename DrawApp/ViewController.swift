//
//  ViewController.swift
//  DrawApp
//
//  Created by Ngoc on 9/24/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var lbl_sizeStt: UILabel!
    
    @IBOutlet weak var mainView: UIImageView!
    
    @IBOutlet weak var filteredView: UICollectionView!
    
    @IBOutlet weak var btn_eraser: UIButton!
    
    @IBOutlet weak var btn_pen: UIButton!
    
    @IBOutlet weak var btn_hightlight: UIButton!
    
    @IBOutlet weak var btn_chisel: UIButton!

    var buttons: NSMutableArray!
    

    var lastPoint = CGPoint.zero

    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var baseImage = UIImage()
    
    let imgColors = ["Black", "Grey", "Red", "Blue", "LightBlue", "DarkGreen", "LightGreen", "Brown", "DarkOrange", "Yellow"]
    
    var brushType = CGLineCap(rawValue: 1)
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [(0,0,0),(171.0 / 255.0, 171.0 / 255.0, 171.0 / 255.0), (242.0 / 255.0, 61.0 / 255.0, 61.0 / 255.0), (44.0 / 255.0, 61.0 / 255.0, 220.0 / 255.0), (58.0 / 255.0, 185.0 / 255.0, 222.0 / 255.0), (13.0 / 255.0, 117.0 / 255.0, 2.0 / 255.0), (141.0 / 255.0, 198.0 / 255.0, 63.0 / 255.0), (123.0 / 255.0, 77.0 / 255.0, 5.0 / 255.0), (200.0 / 255.0 , 124.0 / 255.0, 3.0 / 255.0),(255.0 / 255.0, 235.0 / 255.0, 16.0 / 255.0), (1.0, 1.0, 1.0)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(unselectEraser), name: "ColorSelection", object: nil)
        
         buttons = [btn_eraser, btn_pen, btn_hightlight, btn_chisel]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func eraserDidFinishUsing() {
        if((red, green, blue) == colors[10]){
            (red, green, blue) = colors[0]
        }
    }
    
    func penSelected(button: UIButton){
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.init(red: 58.0 / 255.0, green: 185.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0).CGColor
        
        buttons.removeObject(button)
        
        for otherButton in buttons{
            otherButton.layer.borderWidth = 0.0
           
        }
        
         buttons.addObject(button)
    }
    

    @IBAction func btn_click(sender: AnyObject) {
        let index = sender.tag
        switch index {
        case 0:
            brushWidth = 5
            lbl_sizeStt.text = "5px"
        case 1:
            brushWidth = 10
            lbl_sizeStt.text = "10px"
        case 2:
            brushWidth = 30
            lbl_sizeStt.text = "30px"
        case 3:
            penSelected(btn_eraser)
            (red, green, blue) = colors[10]
            NSNotificationCenter.defaultCenter().postNotificationName("EraserSelection", object: nil, userInfo: nil)
            
        case 4:
            brushType = CGLineCap(rawValue: 0)
            btn_eraser.layer.borderWidth = 0.0
            eraserDidFinishUsing()
            penSelected(btn_chisel)

        case 5:
            brushType = CGLineCap(rawValue: 2)
            btn_eraser.layer.borderWidth = 0.0
            eraserDidFinishUsing()
            penSelected(btn_hightlight)
        case 6:
            brushType = CGLineCap(rawValue: 1)
            btn_eraser.layer.borderWidth = 0.0
            eraserDidFinishUsing()
            penSelected(btn_pen)
        default:
            break
        }
        
    }
    
    
    func unselectEraser(notification: NSNotification){

        btn_eraser.layer.borderWidth = 0.0
        
    }

    @IBAction func savePhoto(sender: AnyObject) {
        var alert: UIAlertView!
        if let image: UIImage = mainView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
             alert = UIAlertView.init(title: "Save sucessfully", message: "Your photo is saved sucessfully", delegate: nil, cancelButtonTitle: "OK")

        }else{
            alert = UIAlertView.init(title: "Warning", message: "Please draw something on it", delegate: nil, cancelButtonTitle: "Yep")
        
        }

        alert.show()
        
        
    }

    
    @IBAction func album(sender: AnyObject) {
        let imgPicker = UIImagePickerController()
        
        imgPicker.delegate = self
        
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imgPicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage: UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage{
            baseImage = pickedImage
            mainView.image = baseImage
        }
        
        [self.dismissViewControllerAnimated(true, completion: nil)]
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touches = touches.first{
            lastPoint = touches.locationInView(mainView)
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.locationInView(mainView)
            drawLine(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!swiped){
            drawLine(lastPoint, toPoint: lastPoint)
        }
    }
    
    
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint){
        UIGraphicsBeginImageContext(mainView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        mainView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, brushType!)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextStrokePath(context)
        
        
        mainView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count - 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = filteredView.dequeueReusableCellWithReuseIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        cell.colorFilter.image = UIImage(named: (imgColors[indexPath.item]))
        
        return cell
    
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        red = colors[indexPath.item].0
        green = colors[indexPath.item].1
        blue = colors[indexPath.item].2
        
    }
    
    
    @IBAction func reset(sender: AnyObject) {
        self.mainView.image = nil
    }
    
    

    
    
    
    
    
    
}

