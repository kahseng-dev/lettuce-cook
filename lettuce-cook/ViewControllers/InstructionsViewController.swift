//
//  InstructionViewController.swift
//  lettuce-cook
//
//  Created by Mac on 26/1/22.
//

import UIKit

class InstructionsViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var instructions:[String]?
    var currentStep:Int = 0
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var totalStepLabel: UILabel!
    @IBOutlet weak var instructionsText: UITextView!
    
    @IBOutlet weak var instructionsPrevButtonUI: UIButton!
    @IBOutlet weak var instructionsNextButtonUI: UIButton!
    
    @IBAction func instructionsBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func instructionsTextPrevButton(_ sender: Any) {
        currentStep -= 1
        setInstructionsText(index: currentStep)
    }
    
    @IBAction func instructionsTextNextButton(_ sender: Any) {
        currentStep += 1
        setInstructionsText(index: currentStep)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var selectedInstructions = appDelegate.selectedInstructions
        let filterCharacters: Set<Character> = [ "\r", "\n", "\r\n" ]
        selectedInstructions?.removeAll(where: { filterCharacters.contains($0) })
        instructions = selectedInstructions?.components(separatedBy: ".")
        instructions?.removeLast()
        setInstructionsText(index: currentStep)
    }
    
    func setInstructionsText(index:Int) {
        instructionsNextButtonUI.isEnabled = true
        instructionsPrevButtonUI.isEnabled = true
        
        if currentStep >= instructions!.count - 1 { // next button check
            instructionsNextButtonUI.isEnabled = false
        }
        
        if currentStep <= 0 { // prev button check
            instructionsPrevButtonUI.isEnabled = false
        }
        
        stepLabel.text = "Step \(index + 1)"
        totalStepLabel.text = "/ \(instructions!.count)"
        instructionsText.text = instructions?[index].trimmingCharacters(in: .whitespaces)
    }
}
