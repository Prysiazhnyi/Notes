//
//  DetailTextViewController.swift
//  Lessons-74-Notes
//
//  Created by Serhii Prysiazhnyi on 20.11.2024.
//

import UIKit

// Протокол делегата для передачи данных
protocol DetailTextViewControllerDelegate: AnyObject {
    func didSaveNote(_ note: String, at index: Int?)
}

class DetailTextViewController: UIViewController {
    
    @IBOutlet var detailText: UITextView!
    
    var selectNote = String()   // Текущая заметка
    var noteIndex: Int?        // Индекс заметки (если редактируем существующую)
    
    weak var delegate: DetailTextViewControllerDelegate?  // Делегат
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Отображаем переданный текст заметки
        detailText.text = selectNote
        
        // для отображения клавиатуры
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Создаем две кнопки
            let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveNote))
            let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
            
            // Размещаем кнопки в правой части навигационной панели
            navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    
    // Удаляем наблюдателей, чтобы избежать утечек памяти
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            detailText.contentInset = .zero
        } else {
            detailText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        detailText.scrollIndicatorInsets = detailText.contentInset
        
        let selectedRange = detailText.selectedRange
        detailText.scrollRangeToVisible(selectedRange)
    }
    
    @objc func saveNote() {
           // Уведомляем делегата о сохранении заметки
           delegate?.didSaveNote(detailText.text, at: noteIndex)
           
           // Возвращаемся назад
           navigationController?.popViewController(animated: true)
        
        print("Detail save -- \(detailText.text)")
       }
    
    @objc func shareTapped() {
        guard let note = detailText.text else {
            print("No note found")
            return
        }
        print(note)
        // Создаем активити контроллер для обмена заметкой
        let activityVC = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        
        // Убираем дополнительные экшн-контроллеры, если не нужны
        activityVC.excludedActivityTypes = [.addToReadingList, .postToFacebook]  // Пример, можно убрать эти экшены
        
        // Представляем активити-контроллер
        present(activityVC, animated: true, completion: nil)
    }
}
