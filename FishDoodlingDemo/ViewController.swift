//
//  ViewController.swift
//  FishDoodlingDemo
//
//  Created by fish on 2020/4/25.
//  Copyright © 2020 fish. All rights reserved.
//

import UIKit

let key = "QDoodlingParams"

class ViewController: UIViewController {

    let viewDraw = QDoodlingDrawView()

    let viewBg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(viewDraw)
        viewDraw.frame = CGRect(x: 400, y: 50, width: UIScreen.main.bounds.size.width - 20 * 40, height: 600)
        viewDraw.backgroundColor = .clear
        viewDraw.lineWidth = 10
        viewDraw.lineColor = .orange
        
        
        if let params = UserDefaults.standard.value(forKey: key) as? String {
            viewDraw.initDoodling(params)
        }
        
        
        viewBg.image = UIImage(named: "bg")
        viewBg.contentMode = .scaleAspectFill
        viewBg.frame = viewDraw.frame
        view.addSubview(viewBg)
        view.sendSubviewToBack(viewBg)
        
        
    }
    
    

    @IBAction func actionSave(_ sender: Any) {
        let params = viewDraw.getPathsParams()
        
        UserDefaults.standard.set(params, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    @IBAction func actionRevoke(_ sender: Any) {
        viewDraw.undo()
    }
    
    @IBAction func actionClear(_ sender: Any) {
        viewDraw.clean()
    }
    
    @IBAction func actionEraser(_ sender: Any) {
        viewDraw.eraser()
    }
    
    @IBAction func actionPaint(_ sender: Any) {
        viewDraw.isEraser = false
    }
    
    @IBAction func valueColor(_ sender: UITextField) {
        guard let value = Int(sender.text ?? "") else {
            return
        }
        
        viewDraw.lineColor = QDoodlingModel.colors[value % QDoodlingModel.colors.count]
    }
    
    
    @IBAction func valueWidth(_ sender: UITextField) {
        guard let value = Int(sender.text ?? "") else {
            return
        }
        viewDraw.lineWidth = CGFloat(value)
    }
    
    @IBAction func valueSnip(_ sender: Any) {
        viewBg.image = viewDraw.snip()
    }
    
    
}

