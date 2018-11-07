//
//  DatePickerController.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/5/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController {
    
    @IBOutlet weak var getInfoButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: DatePickerDelegate!
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        getInfoButton.addTarget(self, action: #selector(getInfoButtonPressed(_:)), for: .touchUpInside)
        getInfoButton.layer.cornerRadius = 20
        datePicker.backgroundColor = .clear
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    @objc private func getInfoButtonPressed(_ sender: UIButton) {
        delegate.datePicker(datePicker, didChangeDate: datePicker.date)
        dismiss(animated: true, completion: nil)
    }

}

protocol DatePickerDelegate: class {
    func datePicker(_ datePicker: UIDatePicker, didChangeDate date: Date)
}
