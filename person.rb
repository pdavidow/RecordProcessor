require 'date'
require_relative 'person_record_exceptions'

class Person
  include PersonRecordExceptions

  GENDER_MALE = :m
  GENDER_FEMALE = :f

  attr_accessor :first_name, :middle_initial, :last_name, :birth_date, :favorite_color

  def self.new_from_pipe_delimited_record(string)
    # Record format: LastName | FirstName | MiddleInitial | Gender(M/F) | FavoriteColor | DateOfBirth(M-D-YYYY)
    p = self.new
    substrings = string.split(' | ')
    raise PipeDelimitedPersonRecordError.new unless substrings.length == 6
    p.last_name = substrings[0].capitalize
    p.first_name = substrings[1].capitalize
    p.set_middle_initial_from(substrings[2])
    p.set_gender_from_string__male_female(substrings[3])
    p.favorite_color = substrings[4].capitalize
    p.birth_date = Date.strptime(substrings[5], '%m-%d-%Y')
    return p
  end

  def self.new_from_comma_delimited_record(string)
    # Record format: LastName, FirstName, Gender(Male/Female), FavoriteColor, DateOfBirth(M/D/YYYY)
    p = self.new
    substrings = string.split(', ')
    raise CommaDelimitedPersonRecordError.new unless substrings.length == 5
    p.last_name = substrings[0].capitalize
    p.first_name = substrings[1].capitalize
    p.set_gender_from_string__male_female(substrings[2])
    p.favorite_color = substrings[3].capitalize
    p.birth_date = Date.strptime(substrings[4], '%m/%d/%Y')
    return p
  end

  def self.new_from_space_delimited_record(string)
    # Record format: LastName FirstName MiddleInitial Gender(M/F) DateOfBirth(M-D-YYYY) FavoriteColor
    p = self.new
    substrings = string.split(' ')
    raise SpaceDelimitedPersonRecordError.new unless substrings.length == 6
    p.last_name = substrings[0].capitalize
    p.first_name = substrings[1].capitalize
    p.set_middle_initial_from(substrings[2])
    p.set_gender_from_string__male_female(substrings[3])
    p.birth_date = Date.strptime(substrings[4], '%m-%d-%Y')
    p.favorite_color = substrings[5].capitalize
    return p
  end

  def self.sort_proc__gender_females_before_males_then_by_last_name_asc
    Proc.new do |a,b|
      result = (a.gender <=> b.gender)
      result == 0 ? (a.last_name <=> b.last_name) : result
    end
  end

  def self.sort_proc__birth_date_asc
    Proc.new{|a,b| a.birth_date <=> b.birth_date}
  end

  def self.sort_proc__last_name_desc
    Proc.new{|a,b| b.last_name <=> a.last_name}
  end

  def birth_date
    @birth_date ||= Date.today
  end

  def set_middle_initial_from(string)
    raise MiddleInitialError.new unless string.length == 1
    self.middle_initial = string.capitalize
  end

  def set_gender_from_string__male_female(string)
    flag = string[0].downcase.to_sym
    return self.be_male if (flag == GENDER_MALE)
    return self.be_female if (flag == GENDER_FEMALE)
    raise GenderError.new
  end

  def gender
    @gender
  end

  def gender_unknown?
    self.gender.nil?
  end

  def be_male
    @gender = GENDER_MALE
  end

  def male?
    self.gender == GENDER_MALE
  end

  def be_female
    @gender = GENDER_FEMALE
  end

  def female?
    self.gender == GENDER_FEMALE
  end

  def output_to_file_named(filename)
    File.open(filename,  "a") do |f|
      f.write(self.to_file_output_string)
    end
  end

  def to_file_output_string
    "#{self.last_name_as_file_output} #{self.first_name_as_file_output} #{gender_as_file_output} #{birth_date_as_file_output} #{favorite_color_as_file_output}"
  end

  def to_s
    "#{self.last_name_as_file_output} #{self.first_name_as_file_output}#{self.middle_initial.nil? ? '' : ' ' + self.middle_initial_as_file_output} #{gender_as_file_output} #{birth_date_as_file_output} #{favorite_color_as_file_output}"
  end

  def last_name_as_file_output
    self.last_name.to_s.capitalize
  end

  def first_name_as_file_output
    self.first_name.to_s.capitalize
  end

  def middle_initial_as_file_output
    self.middle_initial.to_s.capitalize
  end

  def gender_as_file_output
    return 'unknown' if self.gender_unknown?
    return 'Male' if self.male?
    return 'Female' if self.female?
    raise('error') # should never get here
  end

  def birth_date_as_file_output
    self.birth_date.strftime("%m/%d/%Y")
  end

  def favorite_color_as_file_output
    self.favorite_color.to_s.capitalize
  end
end