//
//  S3ClientExtension.swift
//  PodcastCMS
//
//  Created by Jinbo Pan on 10/31/22.
//

import Foundation

import AWSS3
import ClientRuntime
import AWSClientRuntime

// https://docs.aws.amazon.com/sdk-for-swift/latest/developer-guide/examples-s3-objects.html
extension S3Client {
    
    // Upload file to S3
    public func uploadFile(bucket: String, key: String, file: String) async throws {
        let fileUrl = URL(fileURLWithPath: file)
        let fileData = try Data(contentsOf: fileUrl)
        let dataStream = ByteStream.from(data: fileData)
        
        let input = PutObjectInput(
            body: dataStream,
            bucket: bucket,
            key: key
        )
        _ = try await self.putObject(input: input)
    }
    
    
    // Upload Swift Data Object to S3
    public func createFile(bucket: String, key: String, withData data: Data) async throws {
        let dataStream = ByteStream.from(data: data)
        
        let input = PutObjectInput(
            body: dataStream,
            bucket: bucket,
            key: key
        )
        _ = try await self.putObject(input: input)
    }
    
    
    // Download an object to a local file
    public func downloadFile(bucket: String, key: String, to: String) async throws {
        let fileUrl = URL(fileURLWithPath: to).appendingPathComponent(key)
        
        let input = GetObjectInput(
            bucket: bucket,
            key: key
        )
        let output = try await self.getObject(input: input)
        
        // Get the data stream object. Return immediately if there isn't one.
        guard let body = output.body else {
            return
        }
        let data = body.toBytes().toData()
        try data.write(to: fileUrl)
    }
    
    
    // Read an object into a Swift Data object.
    public func readFile(bucket: String, key: String) async throws -> Data {
        let input = GetObjectInput(
            bucket: bucket,
            key: key
        )
        let output = try await self.getObject(input: input)
        
        // Get the stream and return its contents in a `Data` object. If
        // there is no stream, return an empty `Data` object instead.
        guard let body = output.body else {
            return "".data(using: .utf8)!
        }
        let data = body.toBytes().toData()
        return data
    }
}



func getDefaultS3Client() -> S3Client? {
    // Get required credential fields
    guard let awsRegion = UserDefaults.standard.string(forKey: awsRegionString) else {
        return nil
    }
    guard let accessKey = UserDefaults.standard.string(forKey: accessKeyString) else {
        return nil
    }
    guard let secreteAccessKey = UserDefaults.standard.string(forKey: secreteAccessKeyString) else {
        return nil
    }
    
    let awsConfig = AWSCredentialsProviderStaticConfig(
        accessKey: accessKey,
        secret: secreteAccessKey
    )
    
    do {
        return  try S3Client(config: S3Client.S3ClientConfiguration(
            region: awsRegion,
            credentialsProvider: AWSCredentialsProvider.fromStatic(awsConfig)))
    } catch {
        return nil
    }
}
