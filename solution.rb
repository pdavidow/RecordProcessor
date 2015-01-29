require_relative 'person'
require_relative 'record_processor'

rp = RecordProcessor.new

rp.instanciator_proc = Proc.new{|r| Person.new_from_pipe_delimited_record(r)}
rp.instanciate_objects_from_records_in_file_named("pipe_delimited.txt")

rp.instanciator_proc = Proc.new{|r| Person.new_from_comma_delimited_record(r)}
rp.instanciate_objects_from_records_in_file_named("comma_delimited.txt")

rp.instanciator_proc = Proc.new{|r| Person.new_from_space_delimited_record(r)}
rp.instanciate_objects_from_records_in_file_named("space_delimited.txt")
###############################################################################

rp.sort_proc = Person.sort_proc__gender_females_before_males_then_by_last_name_asc
rp.output_to_file_named("output__sort_gender_females_before_males_then_by_last_name_asc")

rp.sort_proc = Person.sort_proc__birth_date_asc
rp.output_to_file_named("output__sort_birth_date_asc")

rp.sort_proc = Person.sort_proc__last_name_desc
rp.output_to_file_named("output__sort_last_name_desc")
