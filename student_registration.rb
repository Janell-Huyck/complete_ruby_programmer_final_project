require 'csv'
require_relative 'Student'



class Menu
  attr_accessor :selection, :quit_program, :selected_student

  def initialize
    @selection = nil
    @quit_program = false
    @selected_student = nil
  end

  def perform
    print_welcome_message
    until @quit_program
      if @selected_student
        @selected_student.print_student_information
      end
      get_customer_selection
      case @selection
      when 1
        @selected_student = Student.new.retrieve_by_id_or_name
      when 2
        @selected_student = Student.new.create_new_student
      when 3
        update_this_student = false
        until update_this_student do
          if !@selected_student
            @selected_student = Student.new.retrieve_by_id_or_name
          end
          puts "\n\nYour selected student is: #{@selected_student.first_name} #{@selected_student.last_name}"
          puts "Student id number: #{@selected_student.student_id}"
          puts "Student major: #{@selected_student.major}\n"
          print "Edit this student?  [Y/N] :"
          if gets.chomp!.downcase[0] == 'y'
            update_this_student = true
          else
            @selected_student = Student.new.retrieve_by_id_or_name
          end
        end
        @selected_student.update_registration(@selected_student)
      when 4
        puts "pls delete student"
      when 5
        print_goodbye_message
        @quit_program = true
      else
        get_customer_selection
      end
    end
  end

  def print_welcome_message
    goodbye_message = "==================================== \n"\
    "  Welcome to Student Registration  \n"\
    '===================================='
    puts goodbye_message
  end

  def print_goodbye_message
    welcome_message = "\n============================================ \n"\
    "  Thank You For Using Student Registration  \n"\
    "============================================\n"
    puts welcome_message
  end

  def get_customer_selection
    @selection = nil

    until @selection do
      puts menu_text
      print "Enter option number (1-5): "
      @selection = gets.chomp
      @selection = nil unless selection_is_valid?
    end
  end

  def menu_text
    "\nPlease select from the following menu options: \n\n"\
    "1: Retrieve student record\n" \
    "2: Create new student record\n" \
    "3: Update student record\n"\
    "4: Delete student record\n"\
    "5: Quit program\n"
  end

  def selection_is_valid?
    @selection = Integer(@selection) rescue nil
    if @selection
      @selection.to_i >= 1 && @selection.to_i <= 5
    else
      puts "Invalid selection.  :( \n"
      false
    end
  end
end


#

#
#   # student_csv = CSV.read("#{records[0]}")
#   # p student_csv
#
#
#   #get student id if known
#   # confirm.  if no, or not known
#   # get first name
#   # get last name
#   # pull out list of students with name
#   # handle if none
#   # select from list
#   # return the student
#
#
# def new_registration
#   new_student = Student.new
#   new_student.create_new_student
#
#   puts ""
#   puts "Registration complete for #{new_student.full_name}. The student ID is #{new_student.student_id}."
#   puts ""
#   new_student
# end

Menu.new.perform
