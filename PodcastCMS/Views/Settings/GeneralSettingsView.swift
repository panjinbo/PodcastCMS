//
//  CloudStorageSettingsView.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/28/22.
//

import SwiftUI

struct GeneralSettingsView: View {
    
    // TODO integrate with CloudKit to store those information
    @State private var defaultCloudStorageProvider: String =  "AWS S3"
    @State private var awsRegion: String = UserDefaults.standard.string(forKey: awsRegionString) ?? ""
    @State private var accessKey: String = UserDefaults.standard.string(forKey: accessKeyString) ?? ""
    @State private var secreteAccessKey: String = UserDefaults.standard.string(forKey: secreteAccessKeyString) ?? ""
    @State private var s3Bucket: String = UserDefaults.standard.string(forKey: s3BucketString) ?? ""
    @State private var cloudfrontURL = UserDefaults.standard.string(forKey: cloudfrontURLString) ?? ""
    
    
    
    var body: some View {
        LazyVStack() {
            Form {
                HStack {
                    Text("Cloud Stroage Provider").padding(.leading, 2).frame(width: 160, alignment:.leading).padding()
                    Picker("", selection: $defaultCloudStorageProvider) {
                        Text("AWS S3").tag("AWS S3")
                    }
                }
                
                HStack {
                    Text("AWS Region").padding(.leading, 2).frame(width: 160, alignment:.leading).padding()
                    TextField(text:$awsRegion, prompt: Text("Required")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                HStack {
                    Text("AWS Access Key").padding(.leading, 2).frame(width: 160, alignment:.leading).padding()
                    TextField(text:$accessKey, prompt: Text("Required")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                
                HStack {
                    Text("AWS Secrete Access Key").padding(.leading, 2).frame(width: 160, alignment:.leading).padding()
                    SecureField(text:$secreteAccessKey, prompt: Text("Required")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                HStack {
                    Text("S3 Bucket").padding(.leading, 2).frame(width: 160, alignment:.leading).padding()
                    SecureField(text:$s3Bucket, prompt: Text("Required")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                HStack {
                    Text("AWS Cloundfront URL").padding(.leading, 2).frame(width: 160, alignment:.leading).padding()
                    TextField(text:$cloudfrontURL, prompt: Text("Optional")) {
                    }.disableAutocorrection(true).textFieldStyle(.plain)
                }
                
                HStack (){
                    Button(action: saveAWSProfile) {
                        Text("Save")
                        
                    }
                    .padding()
                    Button(action: reset) {
                        Text("Reset")
                        
                    }
                    .padding()
                }
            }
        }
    }
    
    func saveAWSProfile() {
        UserDefaults.standard.set(awsRegion, forKey: awsRegionString)
        UserDefaults.standard.set(accessKey, forKey: accessKeyString)
        UserDefaults.standard.set(secreteAccessKey, forKey: secreteAccessKeyString)
        UserDefaults.standard.set(s3Bucket, forKey: s3BucketString)
        UserDefaults.standard.set(cloudfrontURL, forKey: cloudfrontURLString)
    }
    
    func reset() {
        awsRegion = ""
        accessKey = ""
        secreteAccessKey = ""
        s3Bucket = ""
        cloudfrontURL = ""
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
