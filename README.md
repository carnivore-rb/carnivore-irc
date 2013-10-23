# Carnivore IRC

Provides Irc `Carnivore::Source`

# Usage

## IRC

```ruby
require 'carnivore'
require 'carnivore-irc'

Carnivore.configure do
  source = Carnivore::Source.build(
    :type => :irc,
    :args => {
      :servers => [
        {:host => 'irc.example.com', :port => 9000},
        {:host => 'irc2.example.com', :port => 9001, :ssl => true, :verify => false}
      ],
      :nickname => '',
      :password => ''
    }
  )
end
```

# Info
* Carnivore: https://github.com/carnivore-rb/carnivore
* Repository: https://github.com/carnivore-rb/carnivore-irc
* IRC: Freenode @ #carnivore
