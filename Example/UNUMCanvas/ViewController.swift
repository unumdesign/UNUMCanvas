//
//  ViewController.swift
//  UNUMCanvas
//
//  Created by li.zhao@laverne.edu on 08/29/2018.
//  Copyright (c) 2018 li.zhao@laverne.edu. All rights reserved.
//

import UIKit
import UNUMCanvas

class ViewController: UIViewController {

    @IBOutlet var canvasView: CanvasView!
    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view1.backgroundColor = UIColor.red

        let view2 = UIView(frame: CGRect(x: 30, y: 30, width: 20, height: 20))
        view2.backgroundColor = UIColor.green

        let media1 = MediaScalableObject(scalableView: view1 )

        let media2 = MediaScalableObject(scalableView: view2 )

        canvasView.addMediaObject(mediaObject: media1)
        canvasView.addMediaObject(mediaObject: media2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

