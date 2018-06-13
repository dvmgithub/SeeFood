//
//  ViewController.swift
//  SeeFood
//
//  Created by David Viñaras on 8/6/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let userPickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
    
            imageView.image = userPickerImage
            guard let ciImage = CIImage(image: userPickerImage) else {
                fatalError("Could not convert UIimage into CIImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)  else {
            fatalError("Loading CorelML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationController?.title = "HotDog!!!"
                }else {
                    self.navigationController?.title = "Not HotDog!!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }catch {
            print(error)
        }
            
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker,animated: true, completion:  nil)
        
    }
    
}

