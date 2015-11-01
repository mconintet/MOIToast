## About

Simple toast in Object-C for iOS.

## Usage

```objc
// top
[MOIToast successWithin:self.view
                    top:YES
                 margin:64
                  title:nil
                message:@"success"
               duration:1
                timeout:3
             completion:nil];
             
[MOIToast infoWithin:self.view
                 top:YES
              margin:64
               title:nil
             message:@"info"
            duration:1
             timeout:3
          completion:nil];	

// bottom
[MOIToast warningWithin:self.view
                    top:NO
                 margin:10
                  title:nil
                message:@"warning"
               duration:1
                timeout:3
             completion:nil];

[MOIToast errorWithin:self.view
                  top:NO
               margin:10
                title:nil
              message:@"error"
             duration:1
              timeout:3
           completion:nil];
```

## Screenshot

![](https://github.com/mconintet/MOIToast/blob/master/screenshot.gif)

## Installation

```
// in your pod file
pod 'MOIToast', :git => 'https://github.com/mconintet/MOIToast.git'
```

```
// command line
pod install
```

**Don't forget to add icon font to your project**

![](https://github.com/mconintet/MOIToast/blob/master/add-icon-font.png)
