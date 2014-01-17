## v0.10.0 (2014-01-17)

* Add configuration for Translator the specify custom values
* Rename TravelAgent to Translator
* Remove Seatbelt::Collections::Collection subclasses
* Remove Seatbelt::Models
* Support mass assignment of properties and (if present) attributes

## v0.4.2 (2013-12-17)

* Include superclass method implementations to match directive
* Add property defining and matching

## v0.4.1 (2013-11-19)

* Change internal API to Virtus 1.0.0
* Fixes an issue that prevents class methods used as implementation methods
* Add #interface and #implementation directives to have a cleaner API
* Add support for specifying arguments to a API method definition.
* Add tunneling from API class instances to implementation class instances
* Add tunneling of private API properties
* Add synthesize support on instance level between two objects.

## v0.4.0 (2013-30-09)

* New internal API method delegating by introducing an Eigenmethod object

## v0.3.3 (2013-09-25)

* Fixes an error that raises TypeMissmatchError if multiple has_many is used
* Fixes assigning identical proxy object to multiple implementation classes.

## v0.3.2 (2013-09-24)

* API class methods are now delegatable to implementation class methods

## v0.3.1 (2013-09-17)

* Add tapes support for TQL

## v0.3.0 (2013-09-06)

* Add association support to Seatbelt::Document (has_many, has)

## v0.2.0 (2013-08-27)

* Add Dynamic Proxy pattern to have direct access to proxy objects klass methods
* Add validations of attributes to Seatbelt::Document

## v0.1.0 (2013-08-21)

* Add API method definition
* Add forward declaration of API methods to implementation classes
* Add proxy object to access API class or instance in implementation methods
* Add attributes to Seatbelt::Document classes