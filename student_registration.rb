require_relative 'Student'

def customer_menu
  quit_program = false

  print_welcome_message
  until quit_program do
    print_menu_options
    customer_input=gets.chomp!
    new_registration if customer_input == '1'
    update_registratino if customer_input == '2'
    delete_registration if customer_input == '3'
    quit_program = true if customer_input.downcase == 'exit'
  end
end

def print_welcome_message
  welcome_message = "==================================== \n"\
    "  Welcome to Student Registration  \n"\
    '===================================='
  puts welcome_message
end

def print_menu_options
  menu_options = "\nHere are your menu options: \n\n"\
    "Create new registration: 1 \n" \
    "Update existing registration: 2 \n" \
    "Delete registration: 3 \n"\
    "Exit: exit \n"
  puts menu_options
end

def new_registration
  new_student = create_new_student
  unless new_student.is_unique_name?
    puts "Continue making new student record? [Y/N] "
    return if gets.chomp!.downcase[0] == 'n'
  end
  # verify before save
  # save new information
  puts new_student.student_id
  puts "registration sorta complete"
end

def create_new_student
  puts "First name: "
  first_name = gets.chomp!
  puts "Last name: "
  last_name = gets.chomp!
  puts "Major (if known): "
  major = (gets.chomp!) || "Unknown"
  new_student = Student.new(first_name: first_name, last_name: last_name, major: major)
  new_student.full_name = "#{last_name}_#{first_name}"
  new_student.student_id = create_unique_student_id
  new_student
end

def create_unique_student_id
  student_id = "some random number"
  student_id
end

customer_menu