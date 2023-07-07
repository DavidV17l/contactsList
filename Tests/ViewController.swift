//
//  ViewController.swift
//  Tests
//
//  Created by davide on 23/06/23.
//

import UIKit
import Alamofire
import Swinject

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let container = Container()
        container.register(Animal.self) { _ in Cat(name: "Leo") }
        container.register(Person.self) { r in
            PetOwner(pet: r.resolve(Animal.self)!)
        }
        
        let person = container.resolve(Person.self)!
        person.feed() // prints "Feeding \(cat)"
    }
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if textField != nil {
            performSegue(withIdentifier: "exchange", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchange" {
            guard let vc = segue.destination as? SecondaSchermataVC else { return }
            vc.segueText = textField.text
        }
    }
}

protocol Animal {
    var name: String? { get }
}

class Cat: Animal {
    let name: String?

    init(name: String?) {
        self.name = name
    }
}

protocol Person {
    func feed()
}

class PetOwner: Person {
    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }

    func feed() {
        let name = pet.name ?? "/"
        print("Feeding \(name).")
    }
}
