//
//  CategoryCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class CategoryCardTVCell: CardTVCell, UIPickerViewDelegate, UIPickerViewDataSource {
  

  var options:[String] = ["Amusement","Restaurant","Clothes","Park","Cafe","Other"]

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return options.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     let row = options[row]
     return row
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    textField.text = options[row]
  }

  
  
  let textField: UITextField = {
    let text = UITextField()
    text.textAlignment = .center
    text.borderStyle = .bezel
    text.text = "hello"
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  
  let picker: UIPickerView = UIPickerView()
//  let picker: UIPickerView = {
//    let picker = UIPickerView()
//    return picker
//  }()
//  let toolbar:  UIToolbar = {
//    let bar = UIToolbar()
//    bar.translatesAutoresizingMaskIntoConstraints = false
//    return bar
//  }()
//
//  let label: UILabel = {
//    let label = UILabel()
//    label.text = "hello"
//    label.textAlignment = .center
//    label.translatesAutoresizingMaskIntoConstraints = false
//    return label
//  }()

//  let label = MediumHeaderLabel(text: "hello")
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

//      super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.textField.delegate = self

//    let picker: UIPickerView = UIPickerView()
          picker.delegate = self as UIPickerViewDelegate
          picker.dataSource = self as UIPickerViewDataSource
//          contentView.addSubview(picker)
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 35))
           let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
           toolbar.setItems([doneItem], animated: true)
//    contentView.addSubview(toolbar)

    contentView.addSubview(textField)
    textField.centerXin(contentView)
    textField.centerYin(contentView)
    textField.constraintWidth(equalToConstant: 250)
    textField.constraintHeight(equalToConstant: 40)
    textField.inputView = picker
    textField.inputAccessoryView = toolbar

//    contentView.addSubview(label)
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.centerXin(contentView)
//    label.textAlignment = .center
//    label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
//    label.constraintWidth(equalToConstant: 250)
//    label.constraintHeight(equalToConstant: 40)
//
//    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
//           label.isUserInteractionEnabled = true
//           label.addGestureRecognizer(tap)
//
  }
    
    
  

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
//  @objc func tapped() {
//    contentView.addSubview(picker)
//    picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
//    picker.constraintWidth(equalToConstant: 300)
//    picker.constraintHeight(equalToConstant: 200)
//    picker.centerXin(contentView)
    
//    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 35))
//    let toolbar = UIToolbar()
//    toolbar.constraintWidth(equalToConstant: 300)
//    toolbar.constraintHeight(equalToConstant: 35)
//           let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//           toolbar.setItems([doneItem], animated: true)
//    picker.addSubview(toolbar)
//
//  }
//
  @objc func done() {
        textField.endEditing(true)
        textField.text = "\(options[picker.selectedRow(inComponent: 0)])"
//    picker.isHidden = true
//    toolbar.isHidden = true
    }
}

extension CategoryCardTVCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.endEditing(true)
        return false
    }
    
}
