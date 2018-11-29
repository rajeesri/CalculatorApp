//
//  ViewController.swift
//  CalculatorApp
//
//  Created by YaathmiAR on 5/15/18.
//  Copyright © 2018 YaathmiAR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var isNumberTyping : Bool = false
    var isOperatorType : Bool = false
    var isFirstNumberTyped : Bool = false
    var isDecimalNum : Bool = false
    var isNegative : Bool = false
    var isResultDisplay : Bool = false

    


    
    var value1 : Double = 0
    var value2 : Double = 0
    var result : Double = 0
    var operation : String = ""
    
    

    
    

    @IBOutlet weak var displayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        
        
        //print("number = \(sender.titleLabel?.text),\(sender.tag)")
        
        let typedNumber = sender.tag
        //isOperatorType = false
        
        if(isNumberTyping){
            
            displayLabel.text = displayLabel.text?.appending(String(typedNumber))
            
        }else{
            
            isNumberTyping = true
            displayLabel.text = String(typedNumber)
            
        }

    }
    @IBAction func dotButtonTapped(_ sender: UIButton) {
        
        print("dot button tapped")
        if(!isDecimalNum){
            isDecimalNum = true
            
            if(isNumberTyping){
                displayLabel.text = displayLabel.text?.appending(".")}
            else{
                displayLabel.text = "0."
                isNumberTyping = true
            }
            
            
        }
        
        
        
        
    }

    @IBAction func percentageTapped(_ sender: UIButton) {
        
        let tempVal = Double(displayLabel.text!)!
        var outputVal : Double = 0
        
        print("isFirstNumberTyped = \( isFirstNumberTyped)")
        
        if(isNumberTyping && !operation.isEmpty){
            outputVal = tempVal / 100 * value1
            value2 = outputVal //val1
            
            
        }
        else{
            outputVal = tempVal / 100
            value1 = outputVal //val1
            
            
        }
        
        
        displayLabel.text = outputVal.avoidNotation
        print("percentage val = \( outputVal)")
        
        
        
        
        isNumberTyping = false
        

    }
    
    @IBAction func signOperatorTapped(_ sender: UIButton) {
        
        
        var displayNum = Double(displayLabel.text!)!
        
        if (displayNum != 0){
            
            displayNum = -1 * displayNum
            
            if( displayNum.truncatingRemainder(dividingBy: 1) == 0){
                displayLabel.text = "\(Int(displayNum))"
            }
            else{
                displayLabel.text = "-" + displayLabel.text!
            }
            
            if(isResultDisplay){ // condition wrong if result is displaying then user press - we have to save the changes. number typing false, and operator  typing false !operation.isEmpty || (!isNumberTyping && !isOperatorType) ||                
                value1 = displayNum
            }
            
            
        }
        

    }
    
    @IBAction func operatorTapped(_ sender: UIButton) {
        
        
        
        let typedOperator = (sender.titleLabel?.text)!
        print("typedOperator = \(typedOperator) ,\(isNumberTyping),\(isResultDisplay)")
        
        if(isNumberTyping || isResultDisplay){
            valueUpdate()
        }
        self.operation = typedOperator
        isOperatorType = true


    }
    func valueUpdate(){
        
        let tempVal = getNumber()
        
        if(isFirstNumberTyped)
        {
            value2 = tempVal
            calculation()
            value1 = result
            isFirstNumberTyped = true


        }else{
            
            
            if(isNumberTyping || isResultDisplay){
                isResultDisplay = false
                
                value1 = tempVal
                isFirstNumberTyped = true

            }

        }
        
        
        isNumberTyping  = false

       

    }
    func getNumber() -> Double {
        
        var enteredNo : Double = 0
        if let  number = Double(displayLabel.text!)  {
            enteredNo = number
        }
        return enteredNo
    }

    @IBAction func clearTapped(_ sender: UIButton) {
        
        print("Clear all")
        
        isNumberTyping = false
        isDecimalNum = false
        isFirstNumberTyped = false
        isNegative = false
        isOperatorType = false
        
        
        operation =  ""
        displayLabel.text = "0"

        
        
        self.value1 = 0
        self.value2 = 0

    }

    @IBAction func equalPressed(_ sender: UIButton) {
        
        isDecimalNum = false
        
        let temp : Double = getNumber()
        
        if(isNumberTyping || isOperatorType){
            value2 = temp
        }
        if (isResultDisplay)
        {
            isResultDisplay = false
            value1 = result
        }
        
        isNumberTyping = false
        isOperatorType = false
        
        calculation()
        

    }
    
    func calculation()
    {
        var outputString = ""
        result  = 0
        
        
        switch self.operation {
        case "+":
            result = value1 + value2
        case "-":
            result = value1 - value2
        case "X" , "x":
            result = value1 * value2
        case "/":
            result = value1 / value2
            
        default:
            result = value1 + value2
            
        }
        outputString = "\(result)"
        print("value1 = \(value1), value2 = \(value2) ,result = \(result), self.operation=",self.operation,"isNegative = " ,isNegative)
        //value1 = result
        isFirstNumberTyped = false
        
        //check if result is integer
        if( result.truncatingRemainder(dividingBy: 1) == 0){
            outputString = "\(Int(result))"
        }
        
        displayLabel.text = outputString
        isResultDisplay = true
        
    }

    

}

extension Double {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? "k"
    }
}


