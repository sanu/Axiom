# Axiom

Displays Catalog page of all mobile handsets retrieved from backend. Catalog page will have a search area to filter mobile handsets. Category tabs are based on different “brand” fields in response. Search area will provide a search field for keywords plus filtering criteria for main fields like brand, phone, price, sim, gps, and audio jack.

For the API details, please refer the below link.
* [jsonbin](https://jsonbin.io/api-reference/bins/read)

## System Requirements
- Xcode 10.5 and above
- iOS Version 13.0 and above

## Implementaion

- Application has all the must and Good to have points implemented.
- Application follows MVC design architecture.
- Make use of the DTO [Data Transfer Object] concept.
- Added Schema support for Development & Production making it simpler to work with different stages of Application development life-cycle.
- Highly scalable ServiceWrapper which makes it easy to switch to other Networking Libraries like Alamofire
- Model stores data and responsible for API call. ViewController is reponsible for UI updates.
- Application loads data from the server on every fresh launch.
- Users will be able to search mobile handsets.
- Swift language is used and made use of Swift features like class, struct, enum, optionals, closures, protocols

## Installation

- To run the project, Open 'AxiomTelecom.xcodeproj' via Xcode and run.
- To run it on a device, select Team and generate certificate and provisioning automatically by checking 'Automatically manage signing' in General tab of target setting.
- To run it on a simulator, Select any of the simulators in front of selected scheme and run.

## Build

To build using xcodebuild without code signing
```
xcodebuild clean build -project "AxiomTelecom.xcodeproj" -scheme "Development" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
```

# User Interface

![](https://github.com/sanu/Axiom/blob/master/Screenshots/Home.png)  |  ![](https://github.com/sanu/Axiom/blob/master/Screenshots/Search.png)


## License

is released under the MIT license.

### Contact
* [Linkedin](https://www.linkedin.com/in/sanu-s-078b254b/)
