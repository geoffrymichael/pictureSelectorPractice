//
//  ViewController.swift
//  BasicCameraPickerPractice
//
//  Created by Geoffry Gambling on 4/10/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]() {
        didSet {
            save()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        load()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(camera))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let picture = pictures[indexPath.row]
        
        cell.textLabel?.text = picture.imageCaption
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        return cell
        
    }
    
    @objc func camera() {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Picture(image: imageName, imageCaption: "Unknown")
        
        pictures.append(picture)
        
        tableView?.reloadData()
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        
        let ac = UIAlertController(title: "Add a caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default)  { [weak self, ac] _ in
            let newCaption = ac.textFields![0].text
            
            picture.imageCaption = newCaption!
            
            self?.tableView.reloadData()
        })
        
        present(ac, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentsDirectory = path[0]
        
        return documentsDirectory
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "pictures")
        } else {
            print("could not save")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            
            do {
                pictures = try decoder.decode([Picture].self, from: savedPeople)
            } catch {
                print("failed to load data")
            }
        }
    }

}

