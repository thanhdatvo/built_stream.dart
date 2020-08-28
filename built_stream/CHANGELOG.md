## 1.0.15

* switch type of propertyType of StreamResult and StreamParam from `Type` to `String`
because that Dart currently does not support generic runtime type like `List<int>`
  
## 1.0.14

* Degrade meta library version to ^1.1.8

## 1.0.13

* Remove StreamResult and StreamParams interfaces
* Change Disposal interface to  StreamBloc interface
* Update documents
  
## 1.0.11+12

* Reconstruct project
  
## 1.0.8+9+10

* Add example + documents
  
## 1.0.7

* Update document
  
## 1.0.6

* Add new types: ErrorLocation and StreamError for error graceful handler
* Now allow wrap method with no params or not return
* Trigger stream that wrap a method with no params using EmptyParams object

## 1.0.5

* First release