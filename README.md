# AdidasCodingChallenge
iOS Coding Challenge for Adidas

## How to start the project

To start the project, do the folowing:
-open the terminal
-go to the project directory in the 
-Type in 'pod install' (cocoapods needs to be installed for this)
-Open the .xcworkspace file


## Architecture

MVVM has been used to implement thsi project. The reason to use that was so a clear distinction between the different layers could be established. The ModelView is injected with a service which conforms to some protocol. This is particularly useful in the case where the API is changed, or data has to be fetched from another source. In that scenario, any source conforming to the said protocol will be able to run and no other change will be required. 

Data sources and Delegates for tableViews could've been transferred to another file for more modularization but since the code in viewcontrollers was fairly readable and concise, it wasn't thought as particularly useful. 

## App Resiliance

The app displays an error whenever it fails to get data from an API.

## App Stability

The code for this app is free of any fatal errors or avoidable force unwrappings. 

## Testing

Test Cases for all major functions have been written. For API testing, mocks have been used.

## UI/UX

Native elements have been used for UI. The app has a structure to it and any modification can be done by tinkering with the view layer of the project. The only non-native element used is the rating view. The Review form has been custom designed to enable input of ratings. 

## Dependencies

2 pods have been used

- Kingfisher: To download and cache product images
- Cosmos: To display Rating View

## Issues

The reviews recieved in the Product Api are not reflected in the Review Api call for the same product.

