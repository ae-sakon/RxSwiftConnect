# RxSwiftConnect
RxSwiftConnect is similar Retrofit for iOS synonym name Retrofit iOS, We work with ReactiveX.io and Quicktype.io 
use our experience to compile result name RxSwiftConnect. SampleProject Result, as illustrated below. 
<p><img src="Tutorial/SampleProject.gif" width="210" height="360"></p>
<br />
RxSwiftConnect included Handle error, as illustrated below. 
<p float="left">
<img src="Tutorial/internetoffline.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/timeout.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/notfound.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/servererror.png" width="210" height="373">
&nbsp;&nbsp;&nbsp;<img src="Tutorial/unexpect.png" width="210" height="373">
</p>
<br />
Instruction gennerates Model vai Quicktype.io, as illustrated below. 
1. Go directly to https://jsonplaceholder.typicode.com/posts .
2. Copy result's response and post on https://app.quicktype.io .

Defending Against Man-in-the-Middle Attack (MITM) between API Server and iOS Mobile Application even though 
there was installed SSL on API Server. Attacker or Hacker able to listens package on network comunication using by
Burp this software provided by PortSwigger. MITM is one of top ten of hight vulnerable recommended by OWASP and one of law of    mobile penetration test (pentest). Images illustrated below demonstrate instruction defending Man-in-the-Middle Attack (MITM)
<br />
<br />
1. Looking for correct ceftificated which related with domain API and export SSL from Window Server.
<img src="Tutorial/16.jpg" width="600" height="295">
2. Choose export private key.
<img src="Tutorial/02.jpg" width="600" height="308">
3. Choose PKCS and also included all certificates.
<img src="Tutorial/03.jpg" width="600" height="308">
4. Create password it will be used gennerate .cer on iOS.
<img src="Tutorial/04.jpg" width="600" height="308">
5. Names file "input.pfx".
<img src="Tutorial/05.jpg" width="600" height="308">
6. Click finish's button.
<img src="Tutorial/06.jpg" width="600" height="308">
7. Copy file "input.pfx" and transfer to Mac.
<img src="Tutorial/07.jpg" width="600" height="305">
8. Open folder on Mac.
<img src="Tutorial/08.jpg" width="600" height="361">
9. Run terminal and write command follow image.
<img src="Tutorial/10.jpg" width="600" height="279">
10. It will be seen file "mycerts.crt".
<img src="Tutorial/12.jpg" width="600" height="308">
11.
<img src="Tutorial/13.jpg" width="600" height="312">
12.
<img src="Tutorial/15.jpg" width="600" height="378">
13.
<br />
<br />

Support RxSwift 5

```pod
pod 'RxSwiftConnect', '~> 2.8'
```


