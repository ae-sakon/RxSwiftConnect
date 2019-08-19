# RxSwiftConnect
RxSwiftConnect, also known as Retrofit for iOS, is a framework that serves as a protection against 
Man-in-the-Middle Attack (MITM). According to https://us.norton.com/, a man-in-the-middle attack is 
like eavesdropping. It is an attack where the attacker secretly relays and possibly alters the communications
between two parties who believe they are directly communicating with each other (Wikipedia).
After years of trials and tests, working with ReactiveX.io and Quicktype.io, 
RxSwiftConnect was finally born. 

Support RxSwift 5
```pod
pod 'RxSwiftConnect', '~> 2.8'
```
Shown below are sample project results;
<p><img src="Tutorial/SampleProject.gif" width="210" height="360"></p>
<br />
How to coding and use RxSwiftConnect Framework?
<br >
1. Set End Point

```EndPoint
let beseUrl = "https://jsonplaceholder.typicode.com"
```

2. Set URL API Service

```APIClient
func getOtherUser() -> O<R<OtherUser,E>> {
  return requester.get(path: "posts")
}
```

3. Create Model for receive result's data from API Service, uses https://quicktype.io to Auto-Generate Code, as illustrated below.

```Model
import Foundation

struct OtherUserElement: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias OtherUser = [OtherUserElement]
```

4. Finish and RUN!!

```ViewController
apiOther.getOtherUser()
.observeOn(MainScheduler.instance)
.subscribe(onNext:{ r in

    guard let result = r.value else{
        return self.alertPopup(initMessage: r.error!.errorFriendlyEn!)
    }
    result.forEach {
        print("User ID: \($0.id), User Title: \($0.title)")
    }
},onError:{ e in
    self.alertPopup(initMessage: "Application Error")
}).disposed(by: stepBag)
```            

RxSwiftConnect included Handle error, as illustrated below. 
<p float="left">
<img src="Tutorial/internetoffline.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/timeout.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/notfound.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/servererror.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/unexpect.png" width="210" height="373">
</p>
<br />
Instruction gennerates Model vai Quicktype.io there're two solution, the best solution Model by JSON Schema
if your team are developing API Server by C# easy to Generate JSON Schema following link https://blog.quicktype.io/swift-types-from-csharp it help iOS Developer enhancement mirror Model from API Server and avoid error from object null and
error from complex JSON Structure, as illustrated below. 
<br />
1. Copy example JSON Schema from bellow.
<br />

```JSON Schema
{
  "definitions": {
    "BannerInfo": {
      "type": [
        "object",
        "null"
      ],
      "properties": {
        "Image": {
          "type": [
            "string",
            "null"
          ]
        },
        "IdentityType": {
          "type": "integer"
        },
        "BannerType": {
          "type": [
            "string",
            "null"
          ]
        },
        "PopUpText": {
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "Image",
        "IdentityType",
        "BannerType",
        "PopUpText"
      ]
    }
  },
  "type": "object",
  "properties": {
    "Result": {
      "type": [
        "array",
        "null"
      ],
      "items": {
        "$ref": "#/definitions/BannerInfo"
      }
    }
  },
  "required": [
    "Result"
  ]
}
```

<br />
2. Paste JSON Schema on https://app.quicktype.io and changed Source type to "JSON Schema".
<img src="Tutorial/quicktypeioschema.png" width="600" height="368">
<br />
Or Basic Solution create Model by JSON Data, as illustrated below. 
<br />
1. Go directly to https://jsonplaceholder.typicode.com/posts .
<img src="Tutorial/jsonplaceholder.png" width="600" height="407">
2. Copy result's response and post on https://app.quicktype.io .
<img src="Tutorial/quicktypeio.png" width="600" height="368">
RxSwiftConnect serves as a defense against Man-in-the-Middle Attack (MITM) between API Server and iOS 
Mobile Application. An installed SSL on API Server doesn't guarantee non- vulnerability of your data and privacy 
online. Attacker or hacker may be able to track your data on network communication by using Burp, a software
 provided by PortSwigger. MITM is named as one of the top ten most common types of cyber attacks as highted 
by OWASP https://www.owasp.org/index.php/Mobile_Top_10_2016-Top_10 . Below are images of the installation and setting- up of RxSwiftConnect.
<br />
1. Run mmc on Window Server it will be showed popup below.
<img src="Tutorial/mmc1.jpg" width="600" height="415">
2. Choose "Computer Account".
<img src="Tutorial/mmc2.jpg" width="600" height="415">
3. Choose "Certificates" and click "OK" button.
<img src="Tutorial/mmc3.jpg" width="600" height="410">
4. Looking for correct ceftificated which related with domain API and export SSL from Window Server.
<img src="Tutorial/16.jpg" width="600" height="295">
5. Choose export private key.
<img src="Tutorial/02.jpg" width="600" height="308">
6. Choose PKCS and also included all certificates.
<img src="Tutorial/03.jpg" width="600" height="308">
7. Create password it will be used gennerate .cer on iOS.
<img src="Tutorial/04.jpg" width="600" height="308">
8. Names file "input.pfx".
<img src="Tutorial/05.jpg" width="600" height="308">
9. Click finish's button.
<img src="Tutorial/06.jpg" width="600" height="308">
10. Copy file "input.pfx" and transfer to Mac.
<img src="Tutorial/07.jpg" width="600" height="305">
11. Open folder on Mac.
<img src="Tutorial/08.jpg" width="600" height="361">
12. Run terminal and write command follow image.
<img src="Tutorial/terminalexportcrt.jpg" width="600" height="279">
13. It will be seen file "mycerts.crt".
<img src="Tutorial/12.jpg" width="600" height="308">
14. Run terminal to export certificate it's be used in XCODE
<img src="Tutorial/terminalexportcer.jpg" width="600" height="308">
15. There's a file "certificate.cer".
<img src="Tutorial/13.jpg" width="600" height="312">
16. Additional file "certificate.cer" to iOS project.
<img src="Tutorial/15.jpg" width="600" height="378">
17. Finish change status "isPreventPinning = true" of RxSwiftConnect to protect MITM  and RUN!!

```ChangeStatus
private init() {
        let beseUrl = "https://webstarter.megazy.com"
        requester = Requester(initBaseUrl: beseUrl,timeout: 5, isPreventPinning: true, initSessionConfig: URLSessionConfiguration.default)
    }
```







