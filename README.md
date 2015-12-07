![Seatbelt](http://datenspiel.s3.amazonaws.com/vagalo/seatbelt_top.jpg)
# Seatbelt

Tool to define implementation interfaces that should be decoupled from their
implementations. (A Ruby header file approach.)

## Development instructions

### Install RSpec Git Pre-commit hook

To get a working testsuite before committing code to the repository you have to install a Git pre-commit hook that prevends you from committing unless your specs passed or are pending.

If you haven't <code>wget</code> installed already, install it using homebrew:

```
brew install wget
```

Install the hook:

```
wget -O .git/hooks/pre-commit https://raw.github.com/markhazlett/RSpec-Pre-commit-Git-Hook/master/rspec-precommit
```

After installing, call

```
chmod +x .git/hooks/pre-commit
```

to make it executable.

### Testing

Although running the testsuite with [Guard](http://guardgem.org/) I highly recommened the
[RubyTest](https://sublime.wbond.net/packages/RubyTest) Sublime Text package.


## Installation

Add this line to your application's Gemfile:

    gem 'seatbelt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seatbelt

## Usage

### Defining API classes and API meta-methods

Defining classes that act like API classes is a very simple step. Define a plain
Ruby class and include the

```ruby
Seatbelt::Ghost
```

module.

That gives you access to the ```interface``` class method. API meta-methods are not implemented, they will only be defined. Be sure that you have a specification of these methods like passing how many arguments and if a block is required.

```interface``` takes an argument that defines which object level the method should be
callable at (The implementation class has to define a matcher for this. See below.)

```ruby
class Hotel
  include Seatbelt::Gate

  interface :class do
    define  :find_nearby,
            :args => [:options]
  end

end
```

```define``` expects at least one argument, it's method name. The second argument is optional but has to be a ```Hash```.

If your API meta-method expects arguments you have to specify the list of arguments.

```ruby
define  :find_nearby,
        :block_required => false,
        :args => [:options]
```

With this, a class method ```find_nearby``` is defined at the ```Hotel``` class. Calling that method is straight forward:

```ruby
Hotel.find_nearby(:city => "London") # returns all Hotels near London
```

To define an instance API meta-method at the ```Hotel``` class, just pass ```:instance``` to ```:interface``` method:

```ruby
interface :instance do
  define :number_of_rooms_with_tv_sets
end
```

And, like above, calling is just pure Ruby:

```ruby
hotel = Hotel.new
hotel.number_of_rooms_with_tv_sets
```

If your API meta-method specification says that the method requires a block, just pass truthy
to the ```:block_required``` key.

A note about method argument specification:

```ruby
define  :foo,
        :args => ["name", "*args", "&block"]
```

expects that you have an implementation body - let's say - like this:

```
def implement_foo(name, *args, &block)
  # ...
end
```

**Defining API properties**

If the API class should provide properties use the ```define_property``` for single property or ```define_properties``` for multiple property definiton.

```ruby
interface :instance do
  define_property :foo
  define_properties :bar, :foobar
end
```

If you want to update a bunch of properties at once, you must mark them as accessible.

```ruby
interface :instance do
  define_property :foo
  define_properties :bar, :foobar

  property_accessible :foo, :bar
end


foo = Foo.new

foo.properties = { :foo => 12, :bar => "glasses", :foobar => "of beer." }
```

In the example above, the ```foobar``` property will not be set, because it's not marked as accessible.

### Implementing API meta-methods

Defining API meta-methods is simple, but how do you implement the logic of these methods? Use a plain Ruby class and include the ```Seatbelt::Gate``` module.

Then it's possible to associate the implemention method with the API meta-method definition.

```ruby
class ImplementHotel
  include Seatbelt::Gate

  implementation "Hotel", :class do
    match 'hotels_nearby_city'  => 'find_nearby'
    match 'all'                 => 'all'
  end

  def hotels_nearby_city(options={})
   # ...
  end

  def self.all
    # ....
  end

end
```

The ```implementation``` directive takes two arguments. The first one is the method name of the API class, the second one is the object level the implementation is defined on (```:instance```, ```:class```).

The ```match``` directive takes an Hash containing the implementation method name as key and the API method as value.

```ruby
class ImplementHotel
  include Seatbelt::Gate

  # Class methods.
  implementation "Hotel", :class do
    match 'hotels_nearby_city'  => 'find_nearby'
  end

  # Instance methods.
  implementation "Hotel", :instance do
    match 'rooms_with_tv' => 'number_of_rooms_with_tv_sets'
  end

  def hotels_nearby_city(options={})
   # ...
  end

  def rooms_with_tv
    #....
  end

end
```

With the ```match``` directive it is also possible to bind an implementation method from the superclass to the given interface class:

```ruby

class MetaBook
  # An implementation method used for all childs of MetaBook
  def general_stuff_for_books
    #...
  end
end

class ImplementationNovel < MetaBook
  include Seatbelt::Gate

  implementation "Novel", :instance do
    match 'general_stuff_for_books' => 'publisher', :superclass => true
  end

end

```

Note that this is only possible for ```:instance``` level implementations.

(Thanks to @LarsM for suggesting this feature.)

**Using delegated methods**

If you want to use a method as implementation method that is delegated to another object you can mark these methods as
delegated and Seatbelt will recognize them too.

```ruby
class BookImplementation
  delegate :distributor_name, to: :@distributor

  implementation "Book", :instance do
    match 'distributor_name' => 'distributor', delegated: true
  end
end
```

**Implementing API properties**

Similiar to ```match``` associate the properties of your implementation class and your API class with ```match_property```.

```ruby
 # Having an identical property wthin the interface.
 implementation "Book", :instance do
   match_property 'author'
 end

 # Property names differ
 implementation "Book", :instance do
   match_property 'implementation_title' => 'title'
 end

 # Property is defined in the superclass
 implementation "Novel", :instance do
   match_property :publisher, :superclass => true
 end
```


### Accessing the API class in implementations of API meta-methods

You can access the API class within the implementation methods through the
```proxy``` object.

Depending the type of method you are implementing, ```proxy``` will be a different scope:

* implementing a later class method, ```proxy``` is the class of the API class defined in ```implementation```
* implementing a later instance method, ```proxy``` is the instance of the API class defined in ```implementation```

The ```proxy``` object provides a ```call``` method to access the ```proxy``` methods. It expects the method name to call, an argument list and an optional block.

```ruby
def rooms_with_tv
  excluded_rooms  = proxy.call(:second_floor)
  room_criteria   = proxy.call(:criteria, :not => :gallery)
  # ....
end
```

```#call``` could be omitted and message send directly to the API class or instance receiver.

```ruby
def rooms_with_tv
  excluded_rooms  = proxy.second_floor
  room_criteria   = proxy.criteria(:not => :gallery)
end
```

**Hint**: Chaining API classes is possible by returning ```proxy.object``` from the implementation method.

**Note:** If you want to delegate a class method of your implementation class to a class API method by using the ```:type``` key, the proxy object acts as the class object of the API class.

### Defining attributes in API classes

You can define attributes within an API class by including the ```Seatbelt::Document```module.

```ruby
class Airport
  include Seatbelt::Ghost
  include Seatbelt::Document

  attribute :name,  String
  attribute :lat,   Float
  attribute :lng,   Float

  interface :instance do
    define :identifier
  end

end
```

To access the attributes within an implementation class use the ```proxy``` and it's ```call``` method.

For more informations about attributes see the [Virtus](https://github.com/solnic/virtus) project.

**A note about attributes and Mongoid**: If you include ```mongoid``` in your project and any ```attribute``` should be a boolean, you have use the full path to the type:

```ruby
attribute :is_read, Virtus::Attribute::Boolean
```

For further informations see: https://github.com/solnic/virtus/issues/132#issuecomment-11611142


### Defining associations between objects

Associations between objects is possible in two ways if ```Seatbelt::Document``` is included in the class.

**one-to-many**

```ruby
module Seatbelt
  module Models
	class Airport
	  include Seatbelt::Document

	  has_many :flights, Seatbelt::Models::Flight

	end
  end
end
```

A ```has_many``` relationship definition takes two arguments:

* the association name
* the class used for a single item in the relationship collection

That creates an accessor method acts like an ```Array```.

You can add items to the collection (association) in two ways:

*instance level*

```ruby
airport = Seatbelt::Models::Airport.where(:name => "London Stansted")
Flights.find_to(airport.name).each do |flight|
  aiport.flights << flight
end
```

*attribute level*

```ruby
airport = Seatbelt::Models::Airport.where(:name => "London Stansted")
GetFromTheInternet.fetch_flights.each do |flight|
  aiport.flights << {:number => flight["fn_num"], :return_flight_at => flight["RRUECK"]}
end
```

**one-to-one**

```ruby
module Seatbelt
  module Models
    class Hotel
      include Seatbelt::Document

      has :region
    end
  end
end
```

A ```has``` association takes two arguments where the last one is optional.

* the association name
* the class used for the assocation

If the second argument is omitted ```has``` guessed the corrosping model class. In the example above it will use the
```Seatbelt::Models::Region``` class.

You can assign an object to the association the same way as assigning an attribute.

### Synthesize objects

Synthesizing objects is only available at the instance level. By now Seatbelt will only synthesize the state of an object, not its behaviour!

To synthesize an implementation class instance and the proxy object, add ```synthesize``` to the Implementation class.

```ruby
class ImplementationAirport
  include Seatbelt::Gate
  include Mongoid::Document

  field :name,  :type => String
  field :lat,   :type => Float
  field :lng,   :type => Float

  synthesize  :from     => "Seatbelt::Models::Airport",
              :adapter  => "Seatbelt::Synthesizers::Mongoid"
end
```

Then - every time ```proxy.[attribute_name]``` is changed within the implementation class - the instance of the implementation class is changed too. And vice versa:

```ruby
aiport = Seatbelt::Models::Airport.new(:name => "London Stansted")
# in implementation class self.name will be "London Stansted"

# in a implementation method
def something
  proxy.name = "London Gatewick"
  p self.name # => "London Gatewick"
end
```

If attribute names are the same on both sides, all is fine. If not, the implementation class has to implement a ```synthesize_map``` method where the keys are the attributes from the ```API class``` and the values are attributes from the ```implementation class```.

```ruby
class ImplementAirport
  include Seatbelt::Gate
  include Mongoid::Document

  field :l_name,    :type => String
  field :gidd_lat,  :type => Float
  field :gidd_lng,  :type => Float

  synthesize  :from     => "Seatbelt::Models::Airport",
              :adapter  => "Seatbelt::Synthesizers::Mongoid"

  synthesize_map :name => :l_name, :lat => :gidd_lat, :lng => :gidd_lng
end
```

### Defining custom synthesizers

Seatbelt provides to synthesizers:

* ```Seatbelt::Synthesizers::Document```
* ```Seatbelt::Synthesizers::Mongoid```

The first one synthesizes ```Seatbelt::Document``` or ```Virtus``` based implementation classes. The second one synthesizes ```Mongoid::Document``` based implementation classed.

Defining custom synthesizers helpful, if

* the implementation class uses a not supported backend
* only a few attributes should be synthesized that exists on both sides

A Synthesizer is a plain Ruby class which includes the ```Seatbelt::Synthesizer``` module and implements a ```synthesizable_attributes``` method.

```ruby
class CustomSynthesizer
  include Seatbelt::Synthesizer

  def synthesizable_attributes
    [:l_name, :gidd_lat]
  end
end
```

Which only synthesizes the ```:l_name``` and ```:gidd_lat``` properties.

### Tunneling from API class instances to implementation class instances

Any API class that implements Seatbelt::Ghost can have access to its
implementation class instance. This behaviour has to be enabled before using
because its a violation of the Public/Private API approach.

(**And yes - in Ruby private methods are not really private methods.**)

Accessing the implementation instance is only available after the API Class
was instantiated.

Example:

```ruby
class Hotel
  include Seatbelt::Ghost

  enable_tunneling! # access to the implementation instance is now
                    # possible.

end

class ImplementationHotel
  include Seatbelt::Document
  include Seatbelt::Gate

  attribute :ignore_dirty_rooms, Boolean

end

hotel = new Hotel
hotel.tunnel(:ignore_dirty_rooms=,false)
```

Passing blocks is also available if the accessed method supports blocks

```ruby
class ImplementationHotel
  include Seatbelt::Document
  include Seatbelt::Gate

  attribute :ignore_dirty_rooms, Boolean

  def filter_rooms(sections)
    rooms = self.rooms.map{|room| sections.include?(room_type)}
    yield(rooms)
  end
end

hotel.tunnel(:filter_rooms, ["shower, kitchen"]) do |rooms|
  rooms.select do |room|
    # do something
  end
end
```

**Note** that this is a dangerous approach and should be avoided. If you change the implementation layer and you are using tunneling from API classes to Implementation classes you have to make sure that the new implementation layer provides the attribute or
method you are tunneling to with your API class instance.

To disable tunneling just call the ```disable_tunneling!``` class method.

### Man ... we need a translator here

> "The Babel fish," said The Hitchhiker's Guide to the Galaxy quietly, "is small, yellow and leech-like, and probably the oddest thing in the Universe. It feeds on brainwave energy received not from its own carrier but from those around it. It absorbs all unconscious mental frequencies from this brainwave energy to nourish itself with. It then excretes into the mind of its carrier a telepathic matrix formed by combining the conscious thought frequencies with nerve signals picked up from the speech centres of the brain which has supplied them. The practical upshot of all this is that if you stick a Babel fish in your ear you can instantly understand anything in any form of language. The speech patterns you actually hear decode the brainwave matrix which has been fed into your mind by your Babel fish.

*(The Hitchhiker's Guide to the Galaxy)*

Let's talk about basics of the TQL (Translation Query Language). TQL is basically a query formed in a natural sentence (language doesn't matter) after a defined syntax.

TQL basic support is implemented in Seatbelt v0.4. Basic support means that you are able to implement your own translations and tapes.

**Tapes?**

A tape is collection of ```translate``` blocks that will translate a query into some business logic. A tape is added to a tape deck that will play the corrosponding tape section to a given query (or better said - call the translation of this query).

Let's take a closer look at what a tape deck is and what tapes are.

Any class could act as a tape deck by including the ```Seatbelt::TapeDeck``` module. Mostly that classes are also including the ```Seatbelt::Document``` module.

Adding the ```Seatbelt::TapeDeck``` module to a class gives the class the opportunity to

* add tapes to the class
* answer a query with a translation defined within a tape

Before diving into some example code, let's record a tape. As mentioned above, a tape is just a bunch of translation blocks defining the query syntax and an associated logic implementation.

To have translation implemented or defined you should be familiar with regular expressions, the core tool of a tape.

A tape class inherits from ```Seatbelt::Tape``` and is very simple to implement.

```ruby
class PubTape < Seatbelt::Tape

  translate /Gimme (\d+) beers!/ do |sentence, count_of_beer|
    #
  end

end
```

A ```translate```block takes arguments. If your argument list to the ```translate``` block has only one item, this item is the first matched value from your sentence (or if the query didn't expect any matched value then it's the original query sentence).

Anyhow - every match marked with your regular expression is passed do the ```translate``` block if there are enough arguments defined.

```ruby
translate /Gimme (\d+) beers!/ do |sentence, count_of_beer|
  # sentence is original query sentence
  # count_of_beer is the value matched by (\d+)
end
```

**Note:** Any argument passed to the block is passed as String. So you have to take care
of type casts.

To have access to the tape's translation block, a tape has to be assigned to a tape deck.

```ruby
class Pub
  include Seatbelt::Document
  include Seatbelt::Tape

  use_tape PubTape
end
```

Also possible:

```ruby
Pub.add_tape PubTape
```

Having more than one tape:

```ruby
class Pub
  include Seatbelt::Document
  include Seatbelt::Tape

  use_tapes PubTape,
            AnotherTape
end
```

Calling ```Pub.answer("Gimme 4 beers!")``` will call the corrosponding translation block.

**Calling other tapes from a tape**

To call another tape or a specific translation of a tape use the ```play_tape``` method within the ```translate```block.

```ruby
class CreditCardTape < Seatbelt::Tape

  translate /Charge the credit card with (\d+) Euro./ do |amount|
    # do something
  end

end

class PubTape < Seatbelt::Tape

  translate /Gimme (\d+) beers!/ do |sentence, count_of_beer|
    overall_costs = play_tape(:section => "Want the bill for #{count_of_beer} beer")
    play_tape(CreditCardTape, :section => "Charge the credit card with #{overall_costs} Euro.")
  end

  translate /Want the bill for (\d+) beer/ do |beer_amount|
    costs_of_beer = 2
    sum           = 2 * beer_amount.to_i
    sum
  end

end
```

Note the difference between the two ```play_tape``` calls.

With the ```tape_deck``` object within your translate block you have access to the associated tape deck class (not instance).

### Translator

By knowing what tapes and tape decks are, it's easy to understand what the Translator is doing.

The Translator takes the query and delegates the query to the responsible model.

```ruby
Translator.tell_me "Hotel: 3 persons want to travel for 10 days beginning at next friday to Finnland."
```

Delegates the query ```3 persons want to travel for 10 days beginning at next friday to Finnland.``` to the ```Hotel``` model.

The model declaration can be ommitted, if this is done, the query is delegated to the
model that is defined in the ```Translator.setup```:

```ruby
Seatbelt::Translator.setup do |c|
  c.namespace           = "Seatbelt::Models::"
  c.default_model_class = "Offer"
end
```

That will call ```Seatbelt::Models::Offer``` if no model declaration is given within a query.


Define your tapes in ```lib/seatbelt/tapes```!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
