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
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nicknameTextField: UITextField!
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightTextField: UITextField!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var securityButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    
    @IBOutlet var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
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
        
        nicknameLabel.text = "닉네임을 알려주세요"
        nicknameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        heightLabel.text = "키가 어떻게 되시나요?(cm)"
        heightLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        weightLabel.text = "몸무게가 어떻게 되시나요?(kg)"
        weightLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    func configureTextField() {
        setupTextFieldUI(nicknameTextField)
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
        
        randomButton.setTitleColor(.systemBlue, for: .normal)
        randomButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomButton.titleLabel?.font = .systemFont(ofSize: 14)
        randomButton.contentHorizontalAlignment = .right
        
        calculateButton.setTitle("결과 확인", for: .normal)
        calculateButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        calculateButton.tintColor = .white
        calculateButton.backgroundColor = .purple
        calculateButton.layer.cornerRadius = 18
        
        resetButton.setTitle("초기화", for: .normal)
        resetButton.tintColor = .systemRed
        resetButton.titleLabel?.font = .systemFont(ofSize: 14)
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
        guard let nicknameText = nicknameTextField.text, nicknameText != "" else {return}
        
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
            message = "Error"
        }
        
        showCalculateResultAlert(message: message)
        saveData(nicknameValue: nicknameText, heightValue: heightText, weightValue: weightText)
    }
    
    func showCalculateResultAlert(message: String) {
        let alert = UIAlertController(title: "\(nicknameTextField.text ?? "none")님의 BMI 계산 결과", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let randomHeightValue = Float.random(in: 0...300)
        let randomWeightValue = Float.random(in: 0...200)
        
        heightTextField.text = makeNumberFormatter(value: randomHeightValue) ?? "None"
        weightTextField.text = makeNumberFormatter(value: randomWeightValue) ?? "None"
    }
    
    func makeNumberFormatter(value: Float) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor
        numberFormatter.maximumFractionDigits = 2 //소수점 뒤에 최대 자리 수 지정
        
        return numberFormatter.string(from: value as NSNumber)
    }
    
    func fetchData() {
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            nicknameTextField.text = nickname
        } else {
            nicknameTextField.text = nil
        }
        
        if let height = UserDefaults.standard.string(forKey: "height") {
            heightTextField.text = height
        } else {
            heightTextField.text = nil
        }
        
        if let weight = UserDefaults.standard.string(forKey: "weight") {
            weightTextField.text = weight
        } else {
            weightTextField.text = nil
        }
    }
    
    func saveData(nicknameValue: String ,heightValue: String, weightValue: String) {
        UserDefaults.standard.setValue(nicknameValue, forKey: "nickname")
        UserDefaults.standard.setValue(heightValue, forKey: "height")
        UserDefaults.standard.setValue(weightValue, forKey: "weight")
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        deleteData()
        
        nicknameTextField.text = nil
        heightTextField.text = nil
        weightTextField.text = nil
        showDeleteAlert()
    }
    
    func deleteData() {
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "시스템 알림", message: "키와 몸무게 데이터가 초기화 되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}

