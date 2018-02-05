//
//  ViewController.swift
//  CardView
//
//  Created by chq on 2018/1/27.
//  Copyright © 2018年 chq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let count = 6
    var cardView: CardView!
    var startButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addCardView()
    }
    
    func addCardView() {
        
        cardView = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        cardView.center = view.center
//        cardView.isOverlap = false
        view.addSubview(cardView)
        cardView?.delegate = self
        cardView?.dataSource = self
        cardView?.reloadData()
        
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
//        cardView.removeTopItem()
        cardView.removeAll()
    }
    
    @IBAction func revokeAction(_ sender: UIButton) {
        cardView.revokeCard()
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: CardViewDelegate {
    func revoke(cardView: CardView, item: CardItem, with index: Int) {
        print("revoke index: \(index)")
    }
    
    
    func didClick(cardView: CardView, with index: Int) {
        print("click index: \(index)")
    }
    
    func remove(cardView: CardView, item: CardItem, with index: Int) {
        print("remove: \(index)")
        if index == count - 1 {
            cardView.reloadData()
        }
    }
    
    
}

extension ViewController: CardViewDataSource {
    
    func numberOfItems(in cardView: CardView) -> Int {
        return count
    }
    
    func cardView(_ cardView: CardView, cellForItemAt Index: Int) -> CardItem {
        
        //序号越靠前,越在前面..0最上面.
        var item: ImageCardItem!
        if let image = UIImage(named: "img_0" + "\(Index)") {
            item = ImageCardItem(image: image)
        } else {
            item = ImageCardItem(image: UIImage.getImageWithColor(color: UIColor.randomColor))
        }
        
        if Index == count - 1 {
            addStartButton(item: item)
            item.isPan = false  //此属性可以让cardItem不能拖动.
        }
        return item
    }
    
    func addStartButton(item: CardItem) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        button.setBackgroundImage(#imageLiteral(resourceName: "start_button"), for: .normal)
        button.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
        item.contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        item.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: item, attribute: .centerX, multiplier: 1, constant: 0))
        item.addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: item, attribute: .bottom, multiplier: 1, constant: -30))
        
        startButton = button
    }
    
    @objc func startAction(_ button: UIButton) {
        print("start button clicked")
        cardView.removeTopItem(with: .up)
    }
    
}




extension UIImage {
    /// 将颜色转换为图片
    static func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}


