//
//  ViewController.m
//  ServiceSOAP
//
//  Created by Miguel Mexicano on 02/01/18.
//  Copyright © 2018 Miguel Mexicano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startSoapRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    
    -(void)startSoapRequest{
        
        NSString *soapMessage =
        @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service.tokensoft.js.ks.grupobbva.com\">\n<soapenv:Header/>\n<soapenv:Body>\n<ser:getTokenStatusByUser>\n<parametroSTS>\n<ParametroSTS>\n<codParametroSTS>REFUID</codParametroSTS>\n<valorParametroSTS>169540993</valorParametroSTS>\n</ParametroSTS>\n<ParametroSTS>\n<codParametroSTS>ORIGEN</codParametroSTS>\n<valorParametroSTS>CASHMX</valorParametroSTS>\n</ParametroSTS>\n</parametroSTS>\n</ser:getTokenStatusByUser>\n</soapenv:Body>\n</soapenv:Envelope>";
        
        
        /*NSString *soapMessage =
        @"<soapenv:Envelopexmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:pm=\"http://appiancorp.com/webservices/pm\">\n<soapenv:Header/>\n<soapenv:Body>\n<pm:start>\n<username>awdmmappadmin1</username>\n<password>password</password>\n<completedDate>2016-04-25T13:37:34.699Z</completedDate>\n<gameMinutes>2</gameMinutes>\n<gameMoves>14</gameMoves>\n<gameSeconds>33</gameSeconds>\n<gameTimeSec>153</gameTimeSec>\n<guestId>2016</guestId>\n</pm:start>\n</soapenv:Body>\n</soapenv:Envelope>";*/
        
        NSURL *url = [NSURL URLWithString:@"https://150.250.242.224:36050/ksjs_mult_web/services/ServicioSTSComun"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSession *soapSession = [NSURLSession sessionWithConfiguration:   [NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *dataTask = [soapSession dataTaskWithURL: url];
        self.responseData = [[NSMutableData alloc]init];
        [dataTask resume];
    }

    
    - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
    {
        //handle data here
        [self.responseData appendData:data];
        
    }
    
    
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
    {
        //Called when the data transfer is complete
        //Client side errors are indicated with the error parameter
        
        if (error) {
            
            NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
            
        }else{
            
            NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[self.responseData length]);
            
            NSString *theXML = [[NSString alloc] initWithBytes:
                                [self.responseData bytes] length:[self.responseData length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@",theXML);
        }
    }
    
    
    - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
            NSString *host = challenge.protectionSpace.host;
            if([challenge.protectionSpace.host isEqualToString:@"150.250.242.224"]){
                NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
            }
        }
    }
    
    

@end
