//
//  LoadingPageViewController.swift
//  Nardwuar
//
//  Created by Xavier La Rosa on 5/2/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit

//source code from let's build that app, attempting to implement some of this code somehow for loading page one day
class LoadingPageViewController: UIViewController, URLSessionDownloadDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadUI()
    }
    
//Setting Load UI
    //setting label inside circle layer
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    let shapeLayer = CAShapeLayer() //for the colored loading line
    func setLoadUI(){
        //actual circle layer
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = view.center
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = view.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc private func handleTap() {
        print("Attempting to animate stroke")
        beginDownloadingFile()
    }

//Get request while keeping track of download
    //https://nardwuar.herokuapp.com/artist-info/6l3HvQ5sa6mXTsMTB19rO5
    let urlString = "https://nardwuar.herokuapp.com/users?id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjM4MDEwNjVlNGI1NjNhZWVlZWIzNTkwOTEwZDlmOTc3YTgxMjMwOWEiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiWGF2aWVyIExhIFJvc2EiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy1CazJ4M1hFSVJMZy9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBYy9QaWY4TFVWZDZjRS9zOTYtYy9waG90by5qcGciLCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbmFyZHd1YXItN2U2ZmMiLCJhdWQiOiJuYXJkd3Vhci03ZTZmYyIsImF1dGhfdGltZSI6MTU1Njg2MDM1NiwidXNlcl9pZCI6IjQwalZzYXdBUExma2lVdXZXdlF6WXVuTW5XdTEiLCJzdWIiOiI0MGpWc2F3QVBMZmtpVXV2V3ZRell1bk1uV3UxIiwiaWF0IjoxNTU2ODYwMzU3LCJleHAiOjE1NTY4NjM5NTcsImVtYWlsIjoieGF2aWVyLmEubGFyb3NhQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTE2OTY3Mzc4NzU3NTEyMjcxNTI4Il0sImVtYWlsIjpbInhhdmllci5hLmxhcm9zYUBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.Nrmd5gY0ERZfvhd6mD6KoNjfVdNH1XV95QDsojbwN6EGBcymQ2qdCxBBViInuI2AWU2uCz9_WQcXt5T49B-sDMvNeksoLdxL26GdgZHpw5nBYyv8rrDddYRHCGpZb-KkuGwp0g4tPySOBT7MU9HAjq6slcv6sld-n9iBK7nCOlOI9kwrPECa-Ckf2BMQPicXfD2edbYZD9VTWLahj07fLPFyMZl48yp18hlONRI-600_HZLLeLvTDEZdXA9b3UsEtMVqyh3oBe32ZaAkO26mqC6f7YOJT6pUOQDhGWkSUL-yUj-xFINRh294i49E3foPnAenrsKf9Wds5OopA3KLcA"
    private func beginDownloadingFile() {
        print("Attempting to download file")
        
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    //data of bytes while download is happening
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    //protocol we must always have when download done
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }

}
