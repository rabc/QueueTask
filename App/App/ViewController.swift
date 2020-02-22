// Created on 22/02/2020

import UIKit
import AppRepository
import AppServices

class ViewController: UIViewController {
    
    let repository = SecondsRepository.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sendHour() {
        repository.sendTime(Date()) { (response) in
            print("Received [\(response.seconds)] with id [\(response.id)]")
        }
    }
    
}

