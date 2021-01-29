class Student

  attr_accessor :first_name, :last_name, :full_name, :student_id

  def initialize(first_name="Unknown", last_name="Unknown", student_id = "00000000", major="undecided")
    @first_name = first_name
    @last_name = last_name
    @student_id = student_id.to_str
    @full_name = "#{last_name}_#{first_name}"
    @major = major
  end

  def is_unique_name?
    puts "checking if they are new. default is true"
    matching_records = Dir["students/#{full_name}_[1-9]*.csv"]
    if matching_records.length > 0
      puts "#{matching_records.length} Matching records found:"
      matching_records.each do |record|
        puts record.match(/([a-z]*_[a-z]*_[1-9]*)/)
      end
      return false
    end
    true
  end


  def remove_student(id)
    puts "removing student"
    #look through all files in directory
    # if file is found, delete it
    # otherwise, return an error message
  end

  def update_student(attributes)
    puts "updating student"
    # update! (attribute: value)
  end

end