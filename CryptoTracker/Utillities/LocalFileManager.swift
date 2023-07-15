//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 12/13/1401 AP.
//

import Foundation
import SwiftUI

class LocalFileManager {
  static let instance = LocalFileManager()
  
  private init() { }
  
  
  func saveImage(image: UIImage, imageName: String, folderName: String) {
    // Create folder
    createFolderIfNeeded(folderName: folderName)
    
    // Get path for image
    guard let data = image.pngData(),
    let url = getUrlForImage(imageName: imageName, folderName: folderName) else { return }
      //because we're downloading png
    
    //Save image to path
    do {
      try data.write(to: url)
    } catch {
      print("Error saving image. ImageName: \(imageName) \(error.localizedDescription)")
    }
  }
  // not private because we're going to call it from app
  func getImage(imageName: String, folderName: String) -> UIImage? {
    guard let url = getUrlForImage(imageName: imageName, folderName: folderName),
          FileManager.default.fileExists(atPath: url.path)
    else {
      return nil
    }
    return UIImage(contentsOfFile: url.path)
    
  }
  
  private func createFolderIfNeeded(folderName: String) {
    guard let url = gerUrlForFolder(folder: folderName) else { return }
    if !FileManager.default.fileExists(atPath: url.path) {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
      } catch {
        print("Error creating directory. FolderName: \(folderName) \(error)")
      }
    }
  }
  
  private func gerUrlForFolder(folder: String) -> URL? {
    guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return nil
    }
    return url.appendingPathComponent(folder)
    
  }
  
  private func getUrlForImage(imageName: String, folderName: String) -> URL? {
    guard let folderUrl = gerUrlForFolder(folder: folderName) else {
      return  nil
    }
    return folderUrl.appendingPathComponent(imageName + ".png")
  }
}
