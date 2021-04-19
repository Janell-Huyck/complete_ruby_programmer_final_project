class Student

  attr_accessor :first_name, :last_name, :student_id, :major, :retrieve_selection

  def initialize( last_name="Unknown", first_name="Unknown", student_id = "00000000", major="Undecided")
    @first_name = first_name
    @last_name = last_name
    @student_id = student_id
    @major = major
    @retrieve_selection = nil
  end

  def is_unique_name?
    matching_records = Dir["students/#{@last_name}_#{@first_name}_[1-9]*.csv"]
    if matching_records.length > 0
      puts "#{matching_records.length} Matching records found:"
      matching_records.each do |record|
        puts record
      end
      return false
    end
    true
  end

  def is_unique_id?
    matching_records = Dir["students/[a-zA-Z_]*_#{@student_id}*.csv"]
    return false if matching_records.length > 0
    true
  end

  def delete_registration
    if @last_name && @first_name && @student_id
      confirm_delete = false
      until confirm_delete do
        print_student_information
        print "Really delete this student?  This cannot be undone.  [Y/N] :"
        if gets.chomp!.downcase[0] == 'y'
          confirm_delete = true
        else
          puts "Delete aborted.  Returning to previous menu."
          return
        end
      end
      path_to_file = "students/#{@last_name.strip}_#{@first_name.strip}_#{@student_id.strip}.csv"
      if File.exist?(path_to_file)
        puts "Deleting student file. \n"
        File.delete(path_to_file)
        reset_student_attributes
      else
        puts "Unable to delete file #{path_to_file} because it does not exist."
      end
    end
  end

  def save_registration
    if @last_name && @first_name && @student_id
      csv_string = "#{@last_name},#{@first_name},#{@student_id},#{@major}"
      parsed_csv = CSV.parse(csv_string)
      CSV.open("students/#{@last_name}_#{@first_name}_#{@student_id}.csv", "w") do |csv|
        csv << parsed_csv
      end
    else
      puts "Unable to save registration because it is lacking a name or id."
    end
  end

  def create_new_student
    reset_student_attributes
    puts "\n Creating New Student Record: "
    set_first_name
    set_last_name
    unless is_unique_name?
      puts "Continue making new student record? [Y/N] "
      if gets.chomp!.downcase[0] == 'n'
        reset_student_attributes
        return
      end
    end
    set_major
    set_new_student_id
    save_registration
    Student.new("#{@last_name}",
                          "#{@first_name}",
                          "#{@student_id}",
                          "#{@major}" )
  end

  def reset_student_attributes
    @first_name = nil
    @last_name = nil
    @major = nil
    @student_id = nil
  end

  def update_registration(student)
    exit_update = false
    until exit_update
      print_student_information
      puts update_menu_text
      print "Please enter your selection (1-4): "
      update_menu_selection = Integer(gets.chomp!)
      rename_record_to_temp(student)
      case update_menu_selection
      when 1
        set_first_name
      when 2
        set_last_name
      when 3
        set_major
      when 4
        save_registration
        # TODO - when saving with a new name, we need to erase the old one.
        exit_update = true
      end
    end
    student
  end

  def print_student_information
    puts "\nThe student you are working with is: "
    puts "First name: #{@first_name}"
    puts "Last name: #{@last_name}"
    puts "Major: #{@major}"
    puts "Student id: #{@student_id}\n"
  end

  def set_first_name
    if @first_name
      puts "First name is currently #{@first_name}. \n"\
            "To leave this unchanged, leave blank and hit enter below."
    end
    print "Enter first name: "
    new_first_name = gets.capitalize.chomp!
    if new_first_name.length > 0
      @first_name = new_first_name
    end
    save_registration
  end

  def set_last_name
    if @last_name
      puts "Last name is currently #{@last_name}. \n"\
            "To leave this unchanged, leave blank and hit enter below."

    end
    print "Enter last name:"
    new_last_name = gets.chomp!.capitalize
    if new_last_name.length > 0
      @last_name = new_last_name
    end
    save_registration
  end

  def set_major
    if @major
      puts "Major is currently #{@major}. \n"\
            "To leave this unchanged, leave blank and hit enter below."

    end
    print "Enter major: "
    new_major = gets.chomp!.capitalize
    if new_major.length > 0
      @major = new_major
    end
    save_registration
  end

  def set_new_student_id
    @student_id = rand(100000...999999)
    until is_unique_id?
      @student_id = rand(100000...999999)
    end
  end

  def update_menu_text
    "\n1: Update first name\n" \
    "2: Update last name\n" \
    "3: Update major\n" \
    "4: Return to previous menu\n" \
  end

  def retrieve_by_id_or_name
    @retrieve_selection = nil
    until @retrieve_selection
      get_retrieve_selection
      case @retrieve_selection
      when 1
        student_record = retrieve_by_name
        @retrieve_selection = nil unless student_record
      when 2
        student_record = retrieve_by_id
        @retrieve_selection = nil unless student_record
      when 3
        return

      else
        @retrieve_selection = nil
      end
    end
    read_student_record(student_record)
  end

  def get_retrieve_selection
      @retrieve_selection = nil
      until @retrieve_selection do
        puts retrieve_menu_text
        print "Please select menu option (1-3):"
        @retrieve_selection = gets.chomp!.to_i
        @retrieve_selection = nil unless [1,2,3].include? Integer(@retrieve_selection)
      end
  end

  def retrieve_menu_text
    "\nPlease select from the following menu options: \n\n"\
    "1: Retrieve by name\n" \
    "2: Retrieve by id\n" \
    "3: Return to previous menu"
  end

  def retrieve_by_name
    puts ""
    puts "Attempting to retrieve by name."
    print "Please enter student FIRST name: "
    first_name = gets.capitalize.chomp!
    print "Please enter student LAST name: "
    last_name = gets.capitalize.chomp!
    if first_name.length == 0 && last_name.length == 0
      records = Dir["students/[A-Z][a-z]*_[A-Z][a-z]*_[1-9]*.csv"]
    elsif last_name.length == 0
      records = Dir["students/[A-Z][a-z]*_#{(first_name)}_[1-9]*.csv"]
    elsif first_name.length == 0
      records = Dir["students/#{(last_name)}_[A-Z][a-z]*_[1-9]*.csv"]
    else
      records = Dir["students/#{last_name}_#{first_name}_[1-9]*.csv"]
    end
    student_record = select_student_from_records(records)
    puts "\nSorry, no records found for that name." unless student_record
    student_record
  end

  def retrieve_by_id
    puts ""
    puts "Please enter student ID (Leave blank if unknown) : "
    lookup_id = gets.chomp!
    return if lookup_id == nil
    records = Dir["students/[a-zA-Z_]*_#{lookup_id}.csv"]
    student_record = select_student_from_records(records)
    puts "\nSorry, no student found for that id number." unless student_record
    student_record || nil
  end

  def select_student_from_records(records)
    return if records.length == 0
    return records[0] if records.length == 1
    print_retrieved_records(records)
    print "Please enter record number to select: "
    record_index = gets.chomp!.to_i - 1
    if record_index.integer?
      student_record = records[record_index]
    end
    student_record || nil
  end

  def print_retrieved_records(records)
    puts ""
    puts "Found #{records.length} record(s): "
    records.each.with_index(1) do |record, index|
      puts "#{index}. #{record}"
    end
  end

  def read_student_record(student_record)
    if student_record
      student_csv = CSV.readlines(student_record)[0][0]
      student_csv.delete! '\\\"[]'
      student_csv = student_csv.split(",")
      student = Student.new("#{student_csv[0]}",
                  "#{student_csv[1]}",
                  "#{student_csv[2]}",
                  "#{student_csv[3]}")
    end
    student
  end

  def rename_record_to_temp(student)
    @first_name = student.first_name.strip! || @first_name
    @last_name = student.last_name || @last_name
    @major = student.major || @major
    @student_id = student.student_id.strip! || @student_id
    path_to_file = "students/#{student.last_name}_#{student.first_name}_#{student.student_id}.csv"
    if File.exist?(path_to_file)
      File.rename(path_to_file, "students/temp")
    else
      puts "Unable to rename file #{path_to_file} because it does not exist."
    end
  end
end


