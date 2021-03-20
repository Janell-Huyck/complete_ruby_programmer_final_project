class Student

  attr_accessor :first_name, :last_name, :student_id, :major, :retrieve_selection

  def initialize( last_name="Unknown", first_name="Unknown", student_id = "00000000", major="Undecided")
    @first_name = first_name
    @last_name = last_name
    @student_id = student_id.to_str
    @major = major
    @student_id = student_id
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

  def remove_student(id)
    puts "removing student"
    #look through all files in directory
    # if file is found, delete it
    # otherwise, return an error message
  end

  def save_registration
    if @last_name && @first_name && @student_id
      csv_string = "#{@last_name},#{@first_name},#{@student_id},#{@major}"
      parsed_csv = CSV.parse(csv_string)
      CSV.open("students/#{@last_name}_#{@first_name}_#{@student_id}.csv", "w") do |csv|
        csv << parsed_csv
      end
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
      remove_student_record(student)
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
    new_first_name = gets.chomp!.capitalize
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

    #
    # student_record = retrieve_by_id_or_name
    # if student_record do
    #   student_csv = CSV.readlines(student_record)[0][0]
    #
    # p student_csv
    # student_csv.delete! '\\\"[]'
    # student_csv = student_csv.split(",")
    # p student_csv.is_a?(Array)
    #
    # p student_csv
    # student = Student.new("#{student_csv[0]}",
    #                       "#{student_csv[1]}",
    #                       "#{student_csv[2].to_i}",
    #                       "#{student_csv[3]}" )


    # student_csv = CSV.read(student_record)[0]
    # parsed_csv = CSV.parse(student_csv)
    # puts "CSV is #{student_csv}"
    # puts "Parsed CSV is #{parsed_csv}"
    # student = Student.new("#{student_csv[0]}",
    #                       "#{student_csv[1]}",
    #                       "#{student_csv[2]}",
    #                       "#{student_csv[3]}" )
    # puts "Current first name is #{student.first_name}."
    # puts "Or maybe it's #{student_csv[1]}"
    # puts "Or maybe it's #{parsed_csv[1]}"
    # puts "Enter new first name or leave blank to leave unchanged:"
    # student.first_name = gets.chomp! || student.first_name
    # puts "Final selected student is: "
  #   p student_csv
  #   puts "final new student is:"
  #   p student
  #   else
  #     puts "i'm an else"
  #   end


  def update_menu_text
    "\n1: Update first name\n" \
    "2: Update last name\n" \
    "3: Update major\n" \
    "4: Return to previous menu\n" \
  end

  def retrieve_by_id_or_name
    @retrieve_selection = nil
    student = nil
    until @retrieve_selection
      get_retrieve_selection

      case @retrieve_selection
      when 1
        student_record = retrieve_by_name
        @retrieve_selection = nil unless student_record
      when 2
        student_record = retrieve_by_id
        @retrieve_selection = nil unless student_record
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
        print "Please select menu option (1-2):"
        @retrieve_selection = gets.chomp!
        @retrieve_selection = nil unless retrieve_selection_is_valid?
      end
  end

  def retrieve_menu_text
    "\nPlease select from the following menu options: \n\n"\
    "1: Retrieve by name\n" \
    "2: Retrieve by id\n" \
  end

  def retrieve_selection_is_valid?
    @retrieve_selection = Integer(@retrieve_selection) rescue nil
    if @retrieve_selection
      @retrieve_selection == 1 || @retrieve_selection == 2
    else
      puts "Invalid selection.  :( \n"
      false
    end
  end

  def retrieve_by_name
    puts ""
    puts "Attempting to retrieve by name."
    print "Please enter student FIRST name: "
    first_name = gets.chomp
    print "Please enter student LAST name: "
    last_name = gets.chomp
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
      Student.new("#{student_csv[0]}",
                  "#{student_csv[1]}",
                  "#{student_csv[2].to_i}",
                  "#{student_csv[3]}" )
    end
  end
end


