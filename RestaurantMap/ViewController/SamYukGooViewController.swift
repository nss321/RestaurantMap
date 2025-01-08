//
//  SamYukGooViewController.swift
//  RestaurantMap
//
//  Created by BAE on 1/8/25.
//

import UIKit

class SamYukGooViewController: UIViewController, UIPickerViewDataSource {

    var numArray: [String] {
        let arr: [String] = Array(1...100).map { String($0) }.reversed()
        return arr
    }

    @IBOutlet var textField: UITextField!
    @IBOutlet var gameTextView: UITextView!
    let pickerView = UIPickerView()
    @IBOutlet var notiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        textField.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
//        print(numArray)
//        print(countChar(string: "3321"))
//        print(view.gestureRecognizers)
    }
    
    
    func setUI() {
        textField.attributedPlaceholder = NSAttributedString(
            string: "최대 숫자를 입력해주세요.",
            attributes: [
                .font : UIFont.systemFont(ofSize: 24),
                .foregroundColor : UIColor.secondaryLabel
            ])
        gameTextView.contentInset = UIEdgeInsets(top: gameTextView.bounds.height * 0.2, left: 0, bottom: 0, right: 0)
        gameTextView.textColor = .secondaryLabel
        gameTextView.isEditable = false
        notiLabel.text = "삼육구, 삼육구!\n빈칸을 눌러 삼육구 게임을 시작해보세요!"
        textField.inputView = pickerView
    }
    
    func countChar(string: String) -> Int {
        var count = 0
        for item in string {
            count += checkSYG(char: item) ? 1 : 0
        }
        return count
    }
    
    func checkSYG(char: Character) -> Bool {
        switch char {
        case "3":
            return true
        case "6":
            return true
        case "9":
            return true
        default:
            return false
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        print(#function)
    }

}

extension SamYukGooViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        numArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var clapCount = 0
        
        let selectedNum = Int(numArray[row])
        var numRange = Array(1...selectedNum!).map { String($0) }
        
        // MARK: foreach, for item in collection 은 item이 immutable해서 이렇게 구현해봤습니다. 혹시 제가 잘못 알고 있는 부분이 있다면 피드백 부탁드립니다!
        for i in 0..<numRange.count {
            if numRange[i].contains("3") || numRange[i].contains("6") || numRange[i].contains("9") {
                print(numRange[i], numRange[i].count)
                let count = countChar(string: numRange[i])
                numRange[i] = String(String(repeating: "👏", count: count))
                clapCount += count
            }
        }
        
        gameTextView.text = numRange.joined(separator: ", ")
        notiLabel.text = "숫자 \(selectedNum!)까지 총 박수는 \(clapCount)번 입니다."
    }
}

extension SamYukGooViewController: UITextFieldDelegate {
    
}
