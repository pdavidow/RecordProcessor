require 'test/unit'
require 'date'
require_relative 'person'
require_relative 'record_processor'
require_relative 'person_record_exceptions'

class Tester < Test::Unit::TestCase
  include PersonRecordExceptions

  TEST_INPUT_FILE_NAME = 'test_input'
  TEST_OUTPUT_FILE_NAME = 'test_output'

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    @p = nil
    File.delete(TEST_OUTPUT_FILE_NAME) if File.exists?(TEST_OUTPUT_FILE_NAME)
    File.delete(TEST_INPUT_FILE_NAME) if File.exists?(TEST_INPUT_FILE_NAME)
  end

  def four_example_persons
    @four_example_persons ||= [self.example_person0, self.example_person1, self.example_person2, self.example_person3]
  end

  def example_person0
    @example_person0 ||= (
      p = Person.new
      p.first_name = 'Neil'
      p.middle_initial = 'Q'
      p.last_name = 'Abercrombie'
      p.be_male
      p.favorite_color = :tan
      p.birth_date = Date.new(1943,2,13)
      p)
  end

  def example_person1
    @example_person1 ||= (
      p = Person.new
      p.first_name = 'Timothy'
      p.middle_initial = 'Q'
      p.last_name = 'Bishop'
      p.be_male
      p.favorite_color = :yellow
      p.birth_date = Date.new(1967,4,23)
      p)
  end

  def example_person2
    @example_person2 ||= (
      p = Person.new
      p.first_name = 'Sue'
      p.middle_initial = 'Q'
      p.last_name = 'Kelly'
      p.be_female
      p.favorite_color = :pink
      p.birth_date = Date.new(1959,7,12)
      p)
  end

  def example_person3
    @example_person3 ||= (
      p = Person.new
      p.first_name = 'Anna'
      p.middle_initial = 'F'
      p.last_name = 'Kournikova'
      p.be_female
      p.favorite_color = :red
      p.birth_date = Date.new(1975,6,3)
      p)
  end

  ###############################################################

  def test_file_out_person_1
    p = Person.new
    p.first_name = 'First'
    p.middle_initial = 'I'
    p.last_name = 'Last'
    p.be_male
    p.birth_date = Date.new(2015,2,3)
    p.favorite_color = :green

    p.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(1, lines.size)
    self.assert_equal('Last First Male 02/03/2015 Green', lines.first)
  end

  def test_file_out_person_2
    p = Person.new
    p.first_name = 'FIRST'
    p.middle_initial = 'I'
    p.last_name = 'LAST'
    p.be_male
    p.birth_date = Date.new(2015,2,3)
    p.favorite_color = :green

    p.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(1, lines.size)
    self.assert_equal('Last First Male 02/03/2015 Green', lines.first)
  end

  def test_file_out_person_3
    p = Person.new
    p.first_name = 'first'
    p.middle_initial = 'i'
    p.last_name = 'last'
    p.be_male
    p.birth_date = Date.new(2015,2,3)
    p.favorite_color = :green

    p.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(1, lines.size)
    self.assert_equal('Last First Male 02/03/2015 Green', lines.first)
  end

  def test_file_out_person_4
    p = Person.new
    p.first_name = 'first'
    p.middle_initial = 'i'
    p.last_name = 'last'
    p.be_female
    p.birth_date = Date.new(2015,2,3)
    p.favorite_color = :green

    p.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(1, lines.size)
    self.assert_equal('Last First Female 02/03/2015 Green', lines.first)
  end

  def test_file_out_person_5
    p = Person.new
    p.first_name = 'first'
    p.middle_initial = 'i'
    p.last_name = 'last'
    p.be_female
    p.birth_date = Date.new(2015,2,3)
    p.favorite_color = 'green'

    p.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(1, lines.size)
    self.assert_equal('Last First Female 02/03/2015 Green', lines.first)
  end

  def test_file_out_person_6
    p = Person.new
    p.first_name = 'first'
    p.middle_initial = 'i'
    p.last_name = 'last'
    p.birth_date = Date.new(2015,2,3)
    p.favorite_color = 'green'

    p.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(1, lines.size)
    self.assert_equal('Last First unknown 02/03/2015 Green', lines.first)
  end

  def test_file_out_many_persons
    rp = RecordProcessor.new
    persons = self.four_example_persons
    rp.objects.concat(persons)

    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(4, lines.size)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[0].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[1].chomp)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[2].chomp)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[3].chomp)
  end

  def test_file_out_sort__favorite_color_asc
    rp = RecordProcessor.new
    persons = self.four_example_persons
    rp.objects.concat(persons)
    rp.sort_proc = Proc.new{|a,b| a.favorite_color <=> b.favorite_color}

    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(4, lines.size)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[0].chomp)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[1].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[2].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[3].chomp)
  end

  def test_file_out_sort__gender_females_before_males_then_by_last_name_asc
    rp = RecordProcessor.new
    persons = self.four_example_persons
    rp.objects.concat(persons)
    rp.sort_proc = Person.sort_proc__gender_females_before_males_then_by_last_name_asc

    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(4, lines.size)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[0].chomp)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[1].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[2].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[3].chomp)
  end


  def test_file_out_sort__birth_date_asc
    rp = RecordProcessor.new
    persons = self.four_example_persons
    rp.objects.concat(persons)
    rp.sort_proc = Person.sort_proc__birth_date_asc

    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(4, lines.size)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[0].chomp)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[1].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[2].chomp)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[3].chomp)
  end

  def test_file_out_sort__last_name_desc_1
    rp = RecordProcessor.new
    persons = self.four_example_persons
    rp.objects.concat(persons)
    rp.sort_proc = Person.sort_proc__last_name_desc

    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(4, lines.size)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[0].chomp)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[1].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[2].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[3].chomp)
  end

  def test_file_out_sort__last_name_desc_2
    rp = RecordProcessor.new
    persons = [self.example_person0, self.example_person0, self.example_person0, self.example_person0]
    rp.objects.concat(persons)
    rp.sort_proc = Person.sort_proc__last_name_desc

    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(4, lines.size)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[0].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[1].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[2].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[3].chomp)
  end

  def test_instanciate_person_from_pipe_delimited_record
    record = 'Smith | Steve | D | M | Red | 3-3-1985'
    self.assert_nothing_raised(Exception){@p = Person.new_from_pipe_delimited_record(record)}
    self.assert_equal('Smith', @p.last_name)
    self.assert_equal('Steve', @p.first_name)
    self.assert_equal('D', @p.middle_initial)
    self.assert(@p.male?)
    self.assert_equal('red', @p.favorite_color.downcase)
    self.assert_equal('03/03/1985', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'smith | SHEILA | d | female | RED | 12-13-1985'
    self.assert_nothing_raised(Exception){@p = Person.new_from_pipe_delimited_record(record)}
    self.assert_equal('Smith', @p.last_name)
    self.assert_equal('Sheila', @p.first_name)
    self.assert_equal('D', @p.middle_initial)
    self.assert(@p.female?)
    self.assert_equal('red', @p.favorite_color.downcase)
    self.assert_equal('12/13/1985', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'smIth | SHEilA | d | f99LE321 | red | 12-13-1985'
    self.assert_nothing_raised(Exception){@p = Person.new_from_pipe_delimited_record(record)}
    self.assert_equal('Smith', @p.last_name)
    self.assert_equal('Sheila', @p.first_name)
    self.assert_equal('D', @p.middle_initial)
    self.assert(@p.female?)
    self.assert_equal('red', @p.favorite_color.downcase)
    self.assert_equal('12/13/1985', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'Steve | D | M | Red | 3-3-1985'
    exception = self.assert_raise(PipeDelimitedPersonRecordError){Person.new_from_pipe_delimited_record(record)}
    self.assert_equal("Expected format: LastName | FirstName | MiddleInitial | Gender(M/F) | FavoriteColor | DateOfBirth(M-D-YYYY)", exception.message)

    record = 'Dr | Smith | Steve | D | M | Red | 3-3-1985'
    exception = self.assert_raise(PipeDelimitedPersonRecordError){Person.new_from_pipe_delimited_record(record)}
    self.assert_equal("Expected format: LastName | FirstName | MiddleInitial | Gender(M/F) | FavoriteColor | DateOfBirth(M-D-YYYY)", exception.message)

    record = 'Smith | Steve | Dr | M | Red | 3-3-1985'
    exception = self.assert_raise(MiddleInitialError){Person.new_from_pipe_delimited_record(record)}
    self.assert_equal("Field must be of length one", exception.message)

    record = 'Smith | Steve | D | gM | Red | 3-3-1985'
    exception = self.assert_raise(GenderError){Person.new_from_pipe_delimited_record(record)}
    self.assert_equal("Field must start with any of: m M f F", exception.message)

    record = 'Smith | Steve | D | M | Red | 3.3.1985'
    exception = self.assert_raise(ArgumentError){Person.new_from_pipe_delimited_record(record)}
    self.assert_equal("invalid date", exception.message)
  end

  def test_instanciate_person_from_comma_delimited_record
    record = 'Abercrombie, Neil, Male, Tan, 2/13/1943'
    self.assert_nothing_raised(Exception){@p = Person.new_from_comma_delimited_record(record)}
    self.assert_equal('Abercrombie', @p.last_name)
    self.assert_equal('Neil', @p.first_name)
    self.assert_equal(nil, @p.middle_initial)
    self.assert(@p.male?)
    self.assert_equal('tan', @p.favorite_color.downcase)
    self.assert_equal('02/13/1943', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'ABCDE, neil, m, TAN, 12/3/1943'
    self.assert_nothing_raised(Exception){@p = Person.new_from_comma_delimited_record(record)}
    self.assert_equal('Abcde', @p.last_name)
    self.assert_equal('Neil', @p.first_name)
    self.assert_equal(nil, @p.middle_initial)
    self.assert(@p.male?)
    self.assert_equal('tan', @p.favorite_color.downcase)
    self.assert_equal('12/03/1943', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'ABCDE, neil, mqqq123, tan, 12/3/1943'
    self.assert_nothing_raised(Exception){@p = Person.new_from_comma_delimited_record(record)}
    self.assert_equal('Abcde', @p.last_name)
    self.assert_equal('Neil', @p.first_name)
    self.assert_equal(nil, @p.middle_initial)
    self.assert(@p.male?)
    self.assert_equal('tan', @p.favorite_color.downcase)
    self.assert_equal('12/03/1943', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'Neil, Male, Tan, 2/13/1943'
    exception = self.assert_raise(CommaDelimitedPersonRecordError){Person.new_from_comma_delimited_record(record)}
    self.assert_equal("Expected format: LastName, FirstName, Gender(Male/Female), FavoriteColor, DateOfBirth(M/D/YYYY)", exception.message)

    record = 'Dr, Abercrombie, Neil, Male, Tan, 2/13/1943'
    exception = self.assert_raise(CommaDelimitedPersonRecordError){Person.new_from_comma_delimited_record(record)}
    self.assert_equal("Expected format: LastName, FirstName, Gender(Male/Female), FavoriteColor, DateOfBirth(M/D/YYYY)", exception.message)

    record = 'Abercrombie, Neil, gMale, Tan, 2/13/1943'
    exception = self.assert_raise(GenderError){Person.new_from_comma_delimited_record(record)}
    self.assert_equal("Field must start with any of: m M f F", exception.message)

    record = 'Abercrombie, Neil, Male, Tan, 2-13-1943'
    exception = self.assert_raise(ArgumentError){Person.new_from_comma_delimited_record(record)}
    self.assert_equal("invalid date", exception.message)
  end

  def test_instanciate_person_from_space_delimited_record
    record = 'Hingis Martina M F 4-2-1979 Green'
    self.assert_nothing_raised(Exception){@p = Person.new_from_space_delimited_record(record)}
    self.assert_equal('Hingis', @p.last_name)
    self.assert_equal('Martina', @p.first_name)
    self.assert_equal('M', @p.middle_initial)
    self.assert(@p.female?)
    self.assert_equal('green', @p.favorite_color.downcase)
    self.assert_equal('04/02/1979', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'hingis martina m f 12-12-1979 green'
    self.assert_nothing_raised(Exception){@p = Person.new_from_space_delimited_record(record)}
    self.assert_equal('Hingis', @p.last_name)
    self.assert_equal('Martina', @p.first_name)
    self.assert_equal('M', @p.middle_initial)
    self.assert(@p.female?)
    self.assert_equal('green', @p.favorite_color.downcase)
    self.assert_equal('12/12/1979', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'hingiS martinA m fM__%# 12-12-1979 green'
    self.assert_nothing_raised(Exception){@p = Person.new_from_space_delimited_record(record)}
    self.assert_equal('Hingis', @p.last_name)
    self.assert_equal('Martina', @p.first_name)
    self.assert_equal('M', @p.middle_initial)
    self.assert(@p.female?)
    self.assert_equal('green', @p.favorite_color.downcase)
    self.assert_equal('12/12/1979', @p.birth_date.strftime("%m/%d/%Y"))

    record = 'Martina M F 4-2-1979 Green'
    exception = self.assert_raise(SpaceDelimitedPersonRecordError){Person.new_from_space_delimited_record(record)}
    self.assert_equal("Expected format: LastName FirstName MiddleInitial Gender(M/F) DateOfBirth(M-D-YYYY) FavoriteColor", exception.message)

    record = 'Dr Hingis Martina M F 4-2-1979 Green'
    exception = self.assert_raise(SpaceDelimitedPersonRecordError){Person.new_from_space_delimited_record(record)}
    self.assert_equal("Expected format: LastName FirstName MiddleInitial Gender(M/F) DateOfBirth(M-D-YYYY) FavoriteColor", exception.message)

    record = 'Hingis Martina MI F 4-2-1979 Green'
    exception = self.assert_raise(MiddleInitialError){Person.new_from_space_delimited_record(record)}
    self.assert_equal("Field must be of length one", exception.message)

    record = 'Hingis Martina M gF 4-2-1979 Green'
    exception = self.assert_raise(GenderError){Person.new_from_space_delimited_record(record)}
    self.assert_equal("Field must start with any of: m M f F", exception.message)

    record = 'Hingis Martina M F 4_2_1979 Green'
    exception = self.assert_raise(ArgumentError){Person.new_from_space_delimited_record(record)}
    self.assert_equal("invalid date", exception.message)
  end

  def test_instanciate_objects_from_records_in_file
    File.open(TEST_INPUT_FILE_NAME, "w") do |f|
      f.write("Smith | Steve | D | M | Red | 3-3-1985\n")
      f.write("Bonk | Radek | S | M | Green | 6-3-1975\n")
      f.write("Bouillon | Francis | G | M | Blue | 6-3-1975\n")
    end

    rp = RecordProcessor.new
    rp.instanciator_proc = Proc.new{|r| Person.new_from_pipe_delimited_record(r)}
    rp.instanciate_objects_from_records_in_file_named(TEST_INPUT_FILE_NAME)

    self.assert_equal(3, rp.objects.size)
    self.assert_equal('Smith Steve D Male 03/03/1985 Red', rp.objects[0].to_s)
    self.assert_equal('Bonk Radek S Male 06/03/1975 Green', rp.objects[1].to_s)
    self.assert_equal('Bouillon Francis G Male 06/03/1975 Blue', rp.objects[2].to_s)
  end

  def test_default_instanciate_objects_from_records_in_file
    File.open(TEST_INPUT_FILE_NAME, "w") do |f|
      f.write("Smith | Steve | D | M | Red | 3-3-1985\n")
      f.write("Bonk | Radek | S | M | Green | 6-3-1975\n")
      f.write("Bouillon | Francis | G | M | Blue | 6-3-1975\n")
    end

    rp = RecordProcessor.new
    rp.instanciate_objects_from_records_in_file_named(TEST_INPUT_FILE_NAME)

    self.assert_equal(3, rp.objects.size)
    self.assert_nil(rp.objects[0])
    self.assert_nil(rp.objects[1])
    self.assert_nil(rp.objects[2])
  end

  def test_start_to_finish
    rp = RecordProcessor.new

    File.open(TEST_INPUT_FILE_NAME, "w") do |f|
      f.write("Smith | Steve | D | M | Red | 3-3-1985\n")
      f.write("Bonk | Radek | S | M | Green | 6-3-1975\n")
      f.write("Bouillon | Francis | G | M | Blue | 6-3-1975\n")
    end
    rp.instanciator_proc = Proc.new{|r| Person.new_from_pipe_delimited_record(r)}
    rp.instanciate_objects_from_records_in_file_named(TEST_INPUT_FILE_NAME)

    File.open(TEST_INPUT_FILE_NAME, "w") do |f|
      f.write("Abercrombie, Neil, Male, Tan, 2/13/1943\n")
      f.write("Bishop, Timothy, Male, Yellow, 4/23/1967\n")
      f.write("Kelly, Sue, Female, Pink, 7/12/1959\n")
    end
    rp.instanciator_proc = Proc.new{|r| Person.new_from_comma_delimited_record(r)}
    rp.instanciate_objects_from_records_in_file_named(TEST_INPUT_FILE_NAME)

    File.open(TEST_INPUT_FILE_NAME, "w") do |f|
      f.write("Kournikova Anna F F 6-3-1975 Red\n")
      f.write("Hingis Martina M F 4-2-1979 Green\n")
      f.write("Seles Monica H F 12-2-1973 Black\n")
    end
    rp.instanciator_proc = Proc.new{|r| Person.new_from_space_delimited_record(r)}
    rp.instanciate_objects_from_records_in_file_named(TEST_INPUT_FILE_NAME)

    self.assert_equal(9, rp.objects.size)
    self.assert_equal('Smith Steve D Male 03/03/1985 Red', rp.objects[0].to_s)
    self.assert_equal('Bonk Radek S Male 06/03/1975 Green', rp.objects[1].to_s)
    self.assert_equal('Bouillon Francis G Male 06/03/1975 Blue', rp.objects[2].to_s)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', rp.objects[3].to_s)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', rp.objects[4].to_s)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', rp.objects[5].to_s)
    self.assert_equal('Kournikova Anna F Female 06/03/1975 Red', rp.objects[6].to_s)
    self.assert_equal('Hingis Martina M Female 04/02/1979 Green', rp.objects[7].to_s)
    self.assert_equal('Seles Monica H Female 12/02/1973 Black', rp.objects[8].to_s)

    rp.sort_proc = Person.sort_proc__gender_females_before_males_then_by_last_name_asc
    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(9, lines.size)
    self.assert_equal('Hingis Martina Female 04/02/1979 Green', lines[0].chomp)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[1].chomp)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[2].chomp)
    self.assert_equal('Seles Monica Female 12/02/1973 Black', lines[3].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[4].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[5].chomp)
    self.assert_equal('Bonk Radek Male 06/03/1975 Green', lines[6].chomp)
    self.assert_equal('Bouillon Francis Male 06/03/1975 Blue', lines[7].chomp)
    self.assert_equal('Smith Steve Male 03/03/1985 Red', lines[8].chomp)

    rp.sort_proc = Person.sort_proc__birth_date_asc
    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(9, lines.size)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[0].chomp)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[1].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[2].chomp)
    self.assert_equal('Seles Monica Female 12/02/1973 Black', lines[3].chomp)
    self.assert(((s='Bouillon Francis Male 06/03/1975 Blue') == lines[4].chomp) || (s == lines[5].chomp)  || (s == lines[6].chomp))
    self.assert(((s='Bonk Radek Male 06/03/1975 Green') == lines[4].chomp) || (s == lines[5].chomp)  || (s == lines[6].chomp))
    self.assert(((s='Kournikova Anna Female 06/03/1975 Red') == lines[4].chomp) || (s == lines[5].chomp)  || (s == lines[6].chomp))
    self.assert_equal('Hingis Martina Female 04/02/1979 Green', lines[7].chomp)
    self.assert_equal('Smith Steve Male 03/03/1985 Red', lines[8].chomp)

    rp.sort_proc = Person.sort_proc__last_name_desc
    rp.output_to_file_named(TEST_OUTPUT_FILE_NAME)
    lines = IO.readlines(TEST_OUTPUT_FILE_NAME)

    self.assert_equal(9, lines.size)
    self.assert_equal('Smith Steve Male 03/03/1985 Red', lines[0].chomp)
    self.assert_equal('Seles Monica Female 12/02/1973 Black', lines[1].chomp)
    self.assert_equal('Kournikova Anna Female 06/03/1975 Red', lines[2].chomp)
    self.assert_equal('Kelly Sue Female 07/12/1959 Pink', lines[3].chomp)
    self.assert_equal('Hingis Martina Female 04/02/1979 Green', lines[4].chomp)
    self.assert_equal('Bouillon Francis Male 06/03/1975 Blue', lines[5].chomp)
    self.assert_equal('Bonk Radek Male 06/03/1975 Green', lines[6].chomp)
    self.assert_equal('Bishop Timothy Male 04/23/1967 Yellow', lines[7].chomp)
    self.assert_equal('Abercrombie Neil Male 02/13/1943 Tan', lines[8].chomp)
    end
end
