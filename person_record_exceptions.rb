module  PersonRecordExceptions
  class PersonRecordError < StandardError
    def message
      "Invalid format"
    end
  end

  class MiddleInitialError < PersonRecordError
    def message
      "Field must be of length one"
    end
  end

  class GenderError < PersonRecordError
    def message
      "Field must start with any of: m M f F"
    end
  end

  class PipeDelimitedPersonRecordError < PersonRecordError
    def message
      "Expected format: LastName | FirstName | MiddleInitial | Gender(M/F) | FavoriteColor | DateOfBirth(M-D-YYYY)"
    end
  end

  class CommaDelimitedPersonRecordError < PersonRecordError
    def message
      "Expected format: LastName, FirstName, Gender(Male/Female), FavoriteColor, DateOfBirth(M/D/YYYY)"
    end
  end

  class SpaceDelimitedPersonRecordError < PersonRecordError
    def message
      "Expected format: LastName FirstName MiddleInitial Gender(M/F) DateOfBirth(M-D-YYYY) FavoriteColor"
    end
  end
end