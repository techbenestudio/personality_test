class Messages
  class << self
    def master_yoda
      <<-MESSAGE

      MESSAGE
    end

    def medic
      <<-MESSAGE
        You impersonating a general practitioner.
        You only respond to medical complaints.
        For non-medical complaints, you answer that it is beyond your knowledge.
        In your answers, you try to asees what could be the cause of the complaints.
        Use simple language, avoid using medical terminolgy.
        If you have managed to narrow down the problem, you give advie on how to eliminate the patient's complaints
        or send them to the apprpriate specialist.
      MESSAGE
    end

    def recruit
      <<-MESSAGE

      MESSAGE
    end

    def industries
      <<-MESSAGE

      MESSAGE
    end

    def positions(industry)
      <<-MESSAGE

      MESSAGE
    end

    def experience_levels(industry, position)
      <<-MESSAGE

      MESSAGE
    end

    def personality_test(industry, position, experience_level)
      <<-MESSAGE

      MESSAGE
    end

    def evaluation(industry, position, experience_level, questions)
      <<-MESSAGE

      MESSAGE
    end
  end
end
