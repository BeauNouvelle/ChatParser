//
//  ViewController.swift
//  Example
//
//  Created by Beau Young on 19/01/2016.
//  Copyright © 2016 Beau Nouvelle. All rights reserved.
//

import UIKit
import ChatParser

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let jsonText = ChatParser(extractContent: .Any, fromString: textField.text!).prettyJSON {
            outputTextView.text = jsonText
        }
        
        return true
    }
    
}