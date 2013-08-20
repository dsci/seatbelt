# Seatbelt

Interface for communication between the Vagalo web application and a travel data
layer.

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

Defining classes that acts like API classes is a very simple step. Define a plain
Ruby class and include the

```ruby
Seatbelt::Ghost
```

module.

That gives you access to the ```api_method``` class method. API meta-methods are not implemented, they will only defined. Be sure that you have a specification of these methods like passing how many arguments and if a block is required.

```ruby
class Hotel
  include Seatbelt::Gate

  api_method  :find_nearby,
              :scope => :class
end
```

```api_method``` expects at least one argument, it's method name. The second argument is optional but has to be a ```Hash```.

```ruby
api_method  :find_nearby,
            :scope          => :class,
            :block_required => false
```

With this, a class method ```find_nearby``` is defined at the ```Hotel``` class. Calling that method is straight forward:

```ruby
Hotel.find_nearby(:city => "London") # returns all Hotels near London
```

To define an instance API meta-method at the ```Hotel``` class, just pass ```:instance``` to ```:scope``` or omit the ```:scope``` key:

```ruby
api_method :number_of_rooms_with_tv_sets
```

And, like above, calling is just pure Ruby:

```ruby
hotel = Hotel.new
hotel.number_of_rooms_with_tv_sets
```

If your API meta-method specification says that the method requires a block, just pass truthy
to the ```:block_required``` key.


### Implement API meta-methods

Defining API meta-methods is simple, but how to implement the logic of these methods? Use a plain Ruby class and include the ```Seatbelt::Gate``` module.

Then it's possible to associate the implemention method with the API meta-method definition.

```ruby
class ImplementHotel
  include Seatbelt::Gate

  def hotels_nearby_city(options={})
   # ...
  end
  implement :hotels_nearby_city, :as => "Hotel.find_nearby"
end
```

The ```implement``` directive takes two arguments. The first one is the method name of the
implementation, the second one is a ```Hash``` with a ```:as``` key.

The ```:as``` key takes a String that defines in which class the API meta-method is located and the name of the method to implement. The scope of the method (class or instance method) is identified with the seperator that isolates the Class namespace.

For identifying instance methods use ```#``` , for defining class methods use ```.``` .

```ruby
class ImplementHotel
  include Seatbelt::Gate

  def hotels_nearby_city(options={})
   # ...
  end
  implement :hotels_nearby_city, :as => "Hotel.find_nearby" # class method

  def rooms_with_tv
    #....
  end
  implement :rooms_with_tv,
            :as => "Hotel#number_of_rooms_with_tv_sets" #instance method
end
```

### Accessing the API class in implementations of API meta-methods

You can access the API class within the implementation methods through the
```proxy``` object.

Depending the type of method you are implementing, ```proxy``` will be a different scope:

* implementing a later class method, ```proxy``` is the class of the API class defined in ```:as```
* implementing a later instance method, ```proxy``` is the instance of the API class defined in ```:as```

The ```proxy``` object provides a ```call``` method to access the ```proxy``` methods. It expects the method name to call, an argument list and an optional block.

```ruby
def rooms_with_tv
  excluded_rooms  = proxy.call(:second_floor)
  room_criteria   = proxy.call(:criteria, :not => :gallery)
  # ....
end
```

**Hint**: Chaining API classes could be done by returning ```proxy.object``` from the implementation method.

### Defining attributes in API classes

You can define attributes within an API class by including the ```Seatbelt::Document```module.

```ruby
class Airport
  include Seatbelt::Ghost
  include Seatbelt::Document

  attribute :name,  String
  attribute :lat,   Float
  attribute :lng,   Float

  api_method :identifier

end
```

To access the attributes within an implementation class use the ```proxy``` and it's ```call``` method.

For more informations about attributes see the [Virtus](https://github.com/solnic/virtus) project.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
