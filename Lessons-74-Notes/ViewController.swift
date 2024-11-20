//
//  ViewController.swift
//  Lessons-74-Notes
//
//  Created by Serhii Prysiazhnyi on 20.11.2024.
//

import UIKit

class ViewController: UITableViewController, DetailTextViewControllerDelegate {
    
    var notes = [String]()
    private let notesKey = "notes"
    //var selectedNote: String?  // Переменная для хранения выбранной заметки
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Нотатки"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        DispatchQueue.global().async {
            let defaults = UserDefaults.standard
            if let savedData = defaults.data(forKey: self.notesKey),
               let decodedLists = try? JSONDecoder().decode([String].self, from: savedData) {
                self.notes = decodedLists
            }
            print("Выполнена загрузка по дефолту")
        }
        DispatchQueue.main.async {
            // Сортировка и обновление UI на главном потоке
            // self.notes.sort
            self.tableView.reloadData() // Обновление таблицы после завершения загрузки
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        // Основной текст
        cell.textLabel?.text = notes[indexPath.row]
        // Подзаголовок для каждой строки
        // cell.detailTextLabel?.text = "Кол-во просмотров: \(pictures[indexPath.row].viewCount)"  // Пример текста подзаголовка
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let note = notes[indexPath.item]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTextViewController {
            
            vc.selectNote = note
            vc.noteIndex = indexPath.row  // Передаем индекс заметки для редактирования
            vc.delegate = self  // Устанавливаем делегата для обновлений
            print(note)
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.reloadData()
    }
    
    @objc func addNote() {
        print("Add new note")
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTextViewController {
            vc.delegate = self  // Устанавливаем делегата для обновлений
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // Метод для свайпа и удаления
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем заметку
            notes.remove(at: indexPath.row)
            
            // Обновляем таблицу
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveNotesLists()
        }
    }
    
    // MARK: - Реализация делегата
    func didSaveNote(_ note: String, at index: Int?) {
        
        print("Tab view save - \(note)")
        
        if let index = index {
            // Обновляем существующую заметку
            notes[index] = note
        } else {
            // Добавляем новую заметку
            notes.append(note)
        }
        
        // Обновляем таблицу
        tableView.reloadData()
        saveNotesLists()
    }
    
    func saveNotesLists() {
        print("save - \(notes)")
        let defaults = UserDefaults.standard
        if let encodedData = try? JSONEncoder().encode(notes) {
            defaults.set(encodedData, forKey: notesKey)
        }
    }
}

