//
//  LocalFileManger.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 17/05/2023.
//

import Foundation
import UIKit

class LocalFileManager{
    
    static var instance = LocalFileManager()
    private init(){}

    func getURLForFolder(folderName: String) ->  URL?  {
        guard  let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return path.appendingPathComponent(folderName)

    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }

      //write data
    func saveIamgeInFileManger(image:UIImage,imageName:String,folderName: String){
          
        // create folder
        createFolderIfNeeded(folderName: folderName)
          guard
            let data = image.pngData(),
            let folderPath = getURLForImage(imageName: imageName, folderName: folderName)
          else {return}
          do{
              try data.write(to: folderPath)
          }catch let error{
              print("Error saving image. ImageName: \(imageName). \(error)")
          }
      }
    
 
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    //read data
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }

}

