//
//  ViewController.swift
//  BruteForceTask
//
//  Created by Artem Mushtakov on 06.01.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlet

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonStart: UIButton!

    //MARK: - Properties

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                changeColorElements(isBlack: isBlack)
            } else {
                changeColorElements(isBlack: isBlack)
            }
        }
    }

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // bruteForce(passwordToUnlock: "1!gr")

        textField.isSecureTextEntry.toggle()
    }

    //MARK: - Actions

    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }

    //MARK: - SetupElements

    func changeColorElements(isBlack: Bool) {
        if isBlack {
            view.backgroundColor = .black
            label.textColor = .white
            button.backgroundColor = .white
            button.tintColor = .black
            buttonStart.backgroundColor = .white
            buttonStart.tintColor = .black
        } else {
            view.backgroundColor = .white
            label.textColor = .black
            button.backgroundColor = .black
            button.tintColor = .white
            buttonStart.backgroundColor = .black
            buttonStart.tintColor = .white
        }
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
