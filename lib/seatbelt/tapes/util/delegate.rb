module Seatbelt
  module Tapes
    module Util

      # Public: Various methods to delegate answers or sections of a tape
      # to corrosponding implementation.
      # All methods are module methods and should be included as a class
      # extension in a tape related class as private methods.
      module Delegate

        # Public: Calls the implementation block for a query.
        #
        # *args - An argument list containing
        #         answer  - the answer implementation config
        #                   (see Tape.translate for details)
        #         options - A hash containing
        #                   :question - The query question as String
        #
        # Returns the evaluated result of answer[:action].
        def delegate_answer(*args)
          options         = args.extract_options!
          question        = options[:question]
          answer          = args.pop
          argument_length = answer[:action].arity - 1
          data            = question.match(answer[:regex]).captures
          first_data_item = if data.empty?
            question
          else
            data.first
          end
          case argument_length
            when 0 then answer[:action].call(first_data_item)
            when 1 then answer[:action].call(question,data.first)
            else answer[:action].call(question,*data)
          end
        end

        # Public: Extracts an answer from a tape where the answer's regex
        # matches the question string.
        #
        # tape        - A Tape class
        # options={}  - A Hash containing
        #               :question - The query question as String
        #
        # Returns a found answer or nil.
        def get_answer_from_tape(tape, options={})
          question = options[:question]
          tape.answers.detect do |answer|
            question.match(answer[:regex])
          end
        end

      end
    end
  end
end
