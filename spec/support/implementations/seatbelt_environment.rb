["Hotel", "Offer", "Flight"].each do |model|
  code = <<-RUBY
    module Seatbelt
      module Models
        class #{model}
          include Seatbelt::Document
          include Seatbelt::Ghost
        end
      end

      module Collections
        class #{model}Collection < Seatbelt::Collections::Collection

        end
      end
    end
  RUBY
  eval(code)
end
