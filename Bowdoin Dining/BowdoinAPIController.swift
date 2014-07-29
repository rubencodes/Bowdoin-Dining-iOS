//
//  BowdoinAPIController.swift
//  Bowdoin Dining
//
//  Created by Ruben on 7/28/14.
//  Translated & modified from ObjC 
//  Original Created by Ben Johnson on 9/23/10
//

import Foundation

class BowdoinAPIController : NSObject, NSURLConnectionDelegate {
    var transactionData : NSMutableData?
    var username : NSString?
    var password : NSString?
    var user     : User?
    
    init(username : NSString, password : NSString, user : User) {
        self.username = username
        self.password = password
        self.user     = user
        
        super.init()
    }
    
    //gets user account data (balance, points, meals)
    func getAccountData() {
        self.createSOAPRequestWithEnvelope(self.returnSoapEnvelopeForService("<tem:GetCSGoldSVCBalances/>"))
    }
    
    //gets line status
    func getLineData() {
        self.createSOAPRequestWithEnvelope(self.returnSoapEnvelopeForService("<tem:GetCSGoldLineCountsHistogram/>"))
    }
    
    //gets recent transactions
    func getTransactionData() {
        self.createTransactionSOAPRequestWithEnvelope(self.returnSoapEnvelopeForService("<tem:GetCSGoldGLTrans/>"))
    }
    
    func returnSoapEnvelopeForService(serviceRequested : NSString) -> NSMutableString {
        var soapEnvelope : NSMutableString = NSMutableString(string: "")
        soapEnvelope.appendString("<?xml version=\"1.0\"?>")
        soapEnvelope.appendString("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">")
        soapEnvelope.appendString("<soapenv:Header/>")
        soapEnvelope.appendString("<soapenv:Body>")
        soapEnvelope.appendString(serviceRequested)
        soapEnvelope.appendString("</soapenv:Body>")
        soapEnvelope.appendString("</soapenv:Envelope>")
        
        return soapEnvelope
    }
    
    func createSOAPRequestWithEnvelope(soapEnvelope : NSMutableString) {
        //create request
        var url = NSURL(string: "https://gooseeye.bowdoin.edu/ws-csGoldShim/Service.asmx")
        var req = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 5000)
        
        req.addValue("text/xml",    forHTTPHeaderField: "Content-Type")
        req.addValue("bowdoin.edu", forHTTPHeaderField: "Host")
        req.HTTPMethod = "POST"
        req.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        //begin connection
        var connection = NSURLConnection(request: req, delegate: self, startImmediately: false)
        connection.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

        connection.start()
    }
    
    func createTransactionSOAPRequestWithEnvelope(soapEnvelope : NSMutableString) {
        //create request
        var url = NSURL(string: "https://gooseeye.bowdoin.edu/ws-csGoldShim/Service.asmx")
        var req = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 5000)
        
        req.addValue("text/xml",    forHTTPHeaderField: "Content-Type")
        req.addValue("bowdoin.edu", forHTTPHeaderField: "Host")
        req.HTTPMethod = "POST"
        req.HTTPBody = soapEnvelope.dataUsingEncoding(NSUTF8StringEncoding)
        
        //begin connection
        var connection = NSURLConnection(request: req, delegate: self, startImmediately: false)
        connection.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        connection.start()
    }
    
    //takes care of HTTP Authentication
    func connection(connection: NSURLConnection!, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge!) {
        var authMethod = challenge.protectionSpace.authenticationMethod as NSString;
        
        if authMethod.isEqualToString(NSURLAuthenticationMethodNTLM) {
            var credential = NSURLCredential(user: self.username,
                password: self.password,
                persistence: NSURLCredentialPersistence.ForSession)
            
            challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
        }
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Response received, clear out data
        self.transactionData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Store received data
        self.transactionData?.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        //The request has failed for some reason!
        // Check the error var
        NSLog("ERR \(error)");
        self.user?.dataLoadingFailed()
    }
    
    func connection(connection: NSURLConnection!, willCacheResponse cachedResponse : NSCachedURLResponse) -> NSCachedURLResponse? {
        return nil
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        self.user?.parseData(self.transactionData!)
    }
}