//
//  NewRestaurantController.swift
//  Foodster
//
//  Created by Magzhan Zhumaly on 30.11.2022.
//

import UIKit
import CoreData

class NewRestaurantController: UITableViewController {
    
    var restaurant: Restaurant!

    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
//            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
     
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
   @IBOutlet var phoneTextField: RoundedTextField! {
       didSet {
           phoneTextField.tag = 4
           phoneTextField.delegate = self
       }
   }
    
   @IBOutlet var descriptionTextView: UITextView! {
       didSet {
           descriptionTextView.tag = 5
           descriptionTextView.layer.cornerRadius = 10.0
           descriptionTextView.layer.masksToBounds = true
       }
   }
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if let appearance = navigationController?.navigationBar.standardAppearance {
     
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
     
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: Colors.accentColor.rawValue)!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: Colors.accentColor.rawValue)!, .font: customFont]
            }
     
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
//        nameTextField, typeTextField, addressTextField, phoneTextField, descriptionTextView, photoImageView

        if nameTextField.text != "" && typeTextField.text != "" && addressTextField.text != "" && phoneTextField.text != "" && descriptionTextView.text != "" {
            print("Name: \(nameTextField.text!)\nType: \(typeTextField.text!)\nLocation: \(addressTextField.text!)\nPhone: \(phoneTextField.text!)\nDescription: \(descriptionTextView.text!)\nPhoto: \(photoImageView.image ?? UIImage())")
            
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                restaurant = Restaurant(context: appDelegate.persistentContainer.viewContext)
                restaurant.name = nameTextField.text!
                restaurant.type = typeTextField.text!
                restaurant.location = addressTextField.text!
                restaurant.phone = phoneTextField.text!
                restaurant.summary = descriptionTextView.text
                restaurant.isFavorite = false
             
                if let imageData = photoImageView.image?.pngData() {
                    restaurant.image = imageData
                }
             
                print("Saving data to context...")
                appDelegate.saveContext()
            }

            
            dismiss(animated: true, completion: nil)

        } else {
            
            let saveNotFullController = UIAlertController(title: String(localized: "Please fill in all the information"), message: nil, preferredStyle: .alert)

            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            { (action) in
//                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.delegate = self
//
//                    imagePicker.allowsEditing = false
//                    imagePicker.sourceType = .photoLibrary
//     
//                    self.present(imagePicker, animated: true, completion: nil)
//                }
//            })
     
            saveNotFullController.addAction(dismissAction)

            // For iPad
            if let popoverController = saveNotFullController.popoverPresentationController {
//                if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
            }
     
            present(saveNotFullController, animated: true, completion: nil)

            return
        }
        
    }

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
     
            let photoSourceRequestController = UIAlertController(title: "", message: String(localized: "Choose your photo source"), preferredStyle: .actionSheet)
     
            let cameraAction = UIAlertAction(title: String(localized: "Camera"), style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self

                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
     
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })  
     
            let photoLibraryAction = UIAlertAction(title: String(localized: "Photo library"), style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self

                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
     
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
     
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
     
            // For iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
     
            present(photoSourceRequestController, animated: true, completion: nil)
     
        }
        
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewRestaurantController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
 
        return true
    }
}

extension NewRestaurantController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
 
        dismiss(animated: true, completion: nil)
    }
 
}
