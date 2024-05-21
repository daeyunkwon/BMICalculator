//
//  ViewController.swift
//  BMICalculator
//
//  Created by 권대윤 on 5/21/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightTextField: UITextField!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var securityButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        configureLabel()
        configureTextField()
        configureButton()
    }
    
    func configureLabel() {
        titleLabel.text = "BMI Calculator"
        titleLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        
        subTitleLabel.text = "당신의 BMI 지수를\n알려드릴게요."
        subTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subTitleLabel.numberOfLines = 0
        
        heightLabel.text = "키가 어떻게 되시나요?(cm)"
        heightLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        weightLabel.text = "몸무게가 어떻게 되시나요?(kg)"
        weightLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    func configureTextField() {
        setupTextFieldUI(heightTextField)
        setupTextFieldUI(weightTextField)
    }
    
    func setupTextFieldUI(_ textField: UITextField) {
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 2
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.returnKeyType = .done
    }
    
    func configureButton() {
        securityButton.tintColor = .lightGray
        
        randomButton.setTitleColor(UIColor(red: 0.76, green: 0.07, blue: 0.12, alpha: 1.00), for: .normal)
        randomButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomButton.titleLabel?.font = .systemFont(ofSize: 14)
        randomButton.contentHorizontalAlignment = .right
        
        calculateButton.setTitle("결과 확인", for: .normal)
        calculateButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        calculateButton.tintColor = .white
        calculateButton.backgroundColor = .purple
        calculateButton.layer.cornerRadius = 18
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func keyboardDismiss(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @IBAction func securityButtonTapped(_ sender: UIButton) {
        if weightTextField.isSecureTextEntry {
            weightTextField.isSecureTextEntry = false
        } else {
            weightTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        guard let heightText = heightTextField.text else {return}
        guard let weightText = weightTextField.text else {return}
        
        guard let height = Double(heightText) else {
            print("텍스트필드 키 값 Double로 변환 실패")
            return
        }
        guard let weight = Double(weightText) else {
            print("텍스트필드 몸무게 값 Double로 변환 실패")
            return
        }
        
        var calculatedValue = ((weight / (height * height)) * 1000000).rounded()
        calculatedValue = calculatedValue / 100
        
        var message: String = ""
        
        switch calculatedValue {
        case 0.0...18.4:
            message = "나의 신체질량지수(BMI): \(calculatedValue)(저체중)"
        case 18.5...22.9:
            message = "나의 신체질량지수(BMI): \(calculatedValue)(정상)"
        case 23.0...24.9:
            message = "나의 신체질량지수(BMI): \(calculatedValue)(과체중)"
        case 25.0...29.9:
            message = "나의 신체질량지수(BMI): \(calculatedValue)(비만)"
        case 30.0...:
            message = "나의 신체질량지수(BMI): \(calculatedValue)(고도비만)"
        default:
            break
        }
        
        showCalculateResultAlert(message: message)
    }
    
    func showCalculateResultAlert(message: String) {
        let alert = UIAlertController(title: "계산 결과", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let randomHeightValue = Float.random(in: 0...300)
        let randomWeightValue = Float.random(in: 0...200)
        
        heightTextField.text = makeNumberFormatter(value: randomHeightValue)
        weightTextField.text = makeNumberFormatter(value: randomWeightValue)
    }
    
    func makeNumberFormatter(value: Float) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor
        
        if value > 99 {
            numberFormatter.maximumSignificantDigits = 5
        } else if value < 10 {
            numberFormatter.maximumSignificantDigits = 3
        } else {
            numberFormatter.maximumSignificantDigits = 4
        }
        
        return numberFormatter.string(from: value as NSNumber)
    }
}

