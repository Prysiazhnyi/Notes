//
//  ViewController.swift
//  Lessons-74-Notes
//
//  Created by Serhii Prysiazhnyi on 20.11.2024.
//

import UIKit

class ViewController: UITableViewController, DetailTextViewControllerDelegate {
    
    var notes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Нотатки"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        
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
            //vc.delegate = self  // Устанавливаем делегата для обновлений
            print(note)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNote() {
        print("Add new note")
        
        let ac = UIAlertController(title: "Введіть назву", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let noteAction = UIAlertAction(title: "Зберегти", style: .default) { [weak self, weak ac] action in
            guard let newNote = ac?.textFields?[0].text, !newNote.isEmpty else { return }
            
            // Добавляем новую заметку в массив
            self?.notes.append(newNote)
            
            // Обновляем таблицу
            self?.tableView.reloadData()
        }
        ac.addAction(noteAction)
        present(ac, animated: true)
    }
    
    
    @objc func deleteNote() {
        if let indexPath = tableView.indexPathForSelectedRow {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
    }
}

