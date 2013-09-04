# -*- encoding : utf-8 -*-
module Seatbelt
  # Public: A Tape is a collection of translations to common queries.
  # It's the base class of all tapes that provides handling the querys
  # and delegating translations to other tapes.
  #
  # Example:
  #
  #   class HotelSampleTape < Seatbelt::Tape
  #     translate /Show me (\d+) of the (\w+) in (\w+)/ do |sentence,
  #                                                         count,
  #                                                         price_type,
  #                                                         location|
  #       # do some code here ....
  #     end
  #   end
  #
  # A translation or answer to a query is defined with #translate following
  # by a regular expression and a block.
  #
  # The block takes at least one argument. If the block argument list contains
  # only one item then the item is the first machted data from the regular
  # expression.
  #
  # If you want to have the original query and you expect matched data (at
  # least one) than define your block argument list with at least two items
  # where the first one is the query and the second, third ... are the
  # matched data entries.
  #
  # Note that the extracted data from any query is passed to your translation
  # block as a String, so you have to handle the type casts by yourself.
  #
  # To call other translation or delegate some values to a different
  # translation at another tape use the #play_tape method within your
  # #translation block.
  #
  # Example
  #
  #   translate /Send me (\d+) postcards from (\w+)/ do |sentence,
  #                                                      post_card_count,
  #                                                      location|
  #     country = Region.find(:location => location)
  #     amount  = play_tape(PostcardTape, :section => "send #{post_card_count}")
  #
  #     CardDispatcher.send_cards(:num => 2, :rate => amount,
  #                               :lc => country.iso_code)
  #   end
  #
  # Calls the /send (\d+)/ answer of the PostCardTape. The Tape has not to be
  # attached with the own tape deck.
  # If the first argument of #play_tape is omitted, any section of the
  # current tape is called. Note that the section hash is needed.
  class Tape
    extend Seatbelt::Tapes::Util::Delegate

    private_class_method  :delegate_answer,
                          :get_answer_from_tape

    class << self
      # Public: Gets/Sets the tape deck of the tape.
      attr_accessor :tape_deck
    end

    # A store to hold answers for the tape.
    #
    # Returns the store.
    def self.answers
      @answers = [] if @answers.nil?
      @answers
    end

    # Public: Defines a translation implementation for a query/question.
    #
    # query  - A regular expression for identifying the question.
    # &block - An implementation block.
    #
    def self.translate(query, &block)
      answers << { :regex   => query,
                   :action  => block }
    end

    # Public: Delegates or call another tape translation section.
    #
    # *args - An argument list containing:
    #         tape (class)  - The tape to call (optional)
    #         options       - A Hash to refine the :section (required)
    #
    def self.play_tape(*args)
      options = args.extract_options!
      tape    = args.pop
      section = options[:section]

      tape    = self if tape.nil?

      answer  = get_answer_from_tape(tape, :question => section)
      raise Seatbelt::Errors::NoTapeFoundForQueryError unless answer
      delegate_answer(answer, :question => section)        if answer
    end

    class << self
      alias_method :listen_to, :translate
    end

  end
end
