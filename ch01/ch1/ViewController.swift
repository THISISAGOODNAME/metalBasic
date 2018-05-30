//
//  ViewController.swift
//  ch1
//
//  Created by AICDG on 2018/5/28.
//  Copyright © 2018年 Ya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /**
         * The MTLCopyAllDevices() function is only available in macOS.
         * For iOS/tvOS devices use MTLCreateSystemDefaultDevice() instead.
         */
        let devices = MTLCopyAllDevices()
        guard let _ = devices.first else {
            fatalError("Your GPU does not support Metal!")
        }
        
        print("Number of GPU supporting metal : \(devices.count)")
        
        label.stringValue = "Your system has the following GPU(s):\n"
        for device in devices {
            label.stringValue += "\(device.name)\n"
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

