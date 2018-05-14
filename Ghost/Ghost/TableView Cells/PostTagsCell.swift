//
//  PostTagsCell.swift
//  Ghost
//
//  Created by Ray Bradley on 5/14/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class PostTagsCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
  @IBOutlet weak var tagsTextField: UITextField!
  private var _tags: [Tag] = []
  private var _tagPicker: UIPickerView?

//  override func layoutSubviews() {
//    super.layoutSubviews()
//    _tags = Tag.all()
//    _tagPicker = UIPickerView()
//    tagsTextField.inputView = _tagPicker
//  }
  
  // MARK: delegates
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return _tags[row].name
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return _tags.count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
}
