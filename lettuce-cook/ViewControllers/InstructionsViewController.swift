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
    
    // if user clicks on close button, dismiss the view
    @IBAction func instructionsBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // if user clicks on the previous step button, decrease the current step global variable by 1
    @IBAction func instructionsTextPrevButton(_ sender: Any) {
        currentStep -= 1
        setInstructionsText(index: currentStep) // set the instruction text for the given current step
    }
    
    // if user clicks on the next step button, increase the current step global variable by 1
    @IBAction func instructionsTextNextButton(_ sender: Any) {
        currentStep += 1
        setInstructionsText(index: currentStep) // set the instruction text for the given current step
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var selectedInstructions = appDelegate.selectedInstructions
        
        // filter data given the set characters
        let filterCharacters: Set<Character> = [ "\r", "\n", "\r\n" ]
        selectedInstructions?.removeAll(where: { filterCharacters.contains($0) })
        
        // seperate the instruction text by the full stop
        instructions = selectedInstructions?.components(separatedBy: ".")
        
        // remove extra empty array
        instructions?.removeLast()
        
        // set the inital instruction text step
        setInstructionsText(index: currentStep)
    }
    
    func setInstructionsText(index:Int) {
        
        // initally set both the next and previous button as enabled
        instructionsNextButtonUI.isEnabled = true
        instructionsPrevButtonUI.isEnabled = true
        
        // check if there should be a next button
        if currentStep >= instructions!.count - 1 {
            // disable the next button if the current step index is more than the instructions array
            instructionsNextButtonUI.isEnabled = false
        }
        
        // check if there should be a previous button
        if currentStep <= 0 {
            // disable the previous button if current step index is less than 0 or 0
            instructionsPrevButtonUI.isEnabled = false
        }
        
        // set the step instruction details
        stepLabel.text = "Step \(index + 1)"
        totalStepLabel.text = "/ \(instructions!.count)"
        instructionsText.text = instructions?[index].trimmingCharacters(in: .whitespaces)
    }
}
