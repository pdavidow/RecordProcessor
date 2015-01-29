class RecordProcessor

  attr_accessor :objects, :instanciator_proc, :sort_proc

  def objects
    @objects ||= []
  end

  def instanciator_proc
    @instanciator_proc ||= Proc.new{|record| nil}
  end

  def sort_proc
    @sort_proc ||= Proc.new{|a,b| 0}
  end

  def sorted_objects
    self.objects.sort(&self.sort_proc)
  end

  def instanciate_objects_from_records_in_file_named(filename)
    records = IO.readlines(filename)
    objects = records.collect(&self.instanciator_proc)
    self.objects.concat(objects)
  end

  def output_to_file_named(filename)
    File.open(filename, "w") do |f|
      self.sorted_objects.each do |o|
        f.write(o.to_file_output_string)
        f.write("\n")
      end
    end
  end
end