//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Santhosh on 22/01/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
    
    var pickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pickerController.delegate = self
    }

    @IBAction func captureTapped(_ sender: Any) {
        
            let alertController = UIAlertController(title: "Choose", message: "Choose from below options to capture image", preferredStyle: .actionSheet)
            let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { _ in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.pickerController.sourceType = .camera
                    self.pickerController.allowsEditing = true
                    self.present(self.pickerController, animated: true, completion: nil)
                } else {
                    self.showAlert(message: "Camera is not avaliable for this device.")
                }
                
            })
            
            let galleryButton = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.pickerController.sourceType = .photoLibrary
                self.pickerController.allowsEditing = true
                self.present(self.pickerController, animated: true, completion: nil)
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                print("Cancel Clicked")
            })
            
            alertController.addAction(cameraButton)
            alertController.addAction(galleryButton)
            alertController.addAction(cancelButton)


            self.present(alertController, animated: true, completion: nil)
        
  
        
    }
    
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            print("Ok Clicked")
        })
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let path = self.getDocumentsDirectory()
        
        print(path)
        
        if let image = info[.editedImage] as? UIImage {
            displayImage.image = image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    
            let newPath = self.getDocumentsDirectory().appendingPathComponent("\(self.getCurrentDate).jpg")
            print(newPath)
            if let jpgImage = image.jpegData(compressionQuality: 1.0) {
                do {
                    try jpgImage.write(to: newPath)
                } catch  {
                    print(error)
                }
            }

            
          
            
            
            
            
        }
        
        
      
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        return dateFormatter.string(from: Date())
    }
   
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
}

