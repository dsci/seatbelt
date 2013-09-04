# -*- encoding : utf-8 -*-
module Seatbelt

  # A tape deck holds several tapes and 'plays' the section for a query.
  # (See #respond for details.)
  module TapeDeck

    def self.included(base)
      base.class_eval do
        extend ClassMethods

        private_class_method  :delegate_answer,
                              :get_answer_from_tape
      end
    end

    module ClassMethods
      include Seatbelt::Tapes::Util::Delegate

      # A store to hold tapes for the class that implements the module.
      #
      # Returns store.
      def tapes
        @tapes = [] if @tapes.nil?
        @tapes
      end

      # Public: Adds a tape to the tape store. If a passed tape is already
      # included in the store, it will not included a second time.
      #
      # tape_name - (class) name of the tape.
      #
      def use_tape(tape_name)
        unless tape_name.in?(tapes)
          unless tape_name.tape_deck.nil?
            raise Seatbelt::Errors::MultipleTapeUsageDetectedError
          end
          tape_name.tape_deck.nil?
          tape_name.tape_deck = Module.const_get(self.name)
          tapes << tape_name
        end
      end
      alias_method :add_tape, :use_tape

      # Public: Adds a bunch of tapes to the store. See #use_tape.
      #
      # *tapes - A list of tapes.
      #
      def use_tapes(*tapes)
        tapes.flatten.each { |tape| self.use_tape(tape) }
      end

      # Public: Detects an answer that matches the question and calls the
      # translation block.
      #
      # question - The question or query as String
      #
      def respond(question)
        found_answer = nil
        tapes.each do |tape|
          found_answer = get_answer_from_tape(tape, :question => question)
          break if found_answer
        end
        raise Seatbelt::Errors::NoTapeFoundForQueryError unless found_answer
        delegate_answer(found_answer, :question => question) if found_answer
      end
      alias_method :answer, :respond

    end
  end
end