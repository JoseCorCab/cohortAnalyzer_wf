#!/usr/bin/env ruby

########################################################
## initialize
########################################################
require 'optparse'
########################################################
##functions
########################################################
def load_profile(file_name, header, column_to_filter)
	profiles = []
	header_line = ""
	File.readlines(file_name).each_with_index do |line, line_count|
		line = line.chomp.split("\t", 5)
    if header && line_count == 0
			header_line = line
			column_to_filter = line.index(column_to_filter) if !column_to_filter.nil?
		else
      phenotypes = line[column_to_filter].split("|")
			if phenotypes.empty?
        puts line.first + "\tpatient has no phenotypes"
        next
      end
     # p phenotypes.length
      profiles << [phenotypes.length,  line]
		end
	end
	profiles = [header_line.join("\t"), profiles]
	return profiles
end


def filter_and_save(profiles, output_file, minimun_phen_count)
	header, profiles = profiles
	File.open(output_file, 'w') do |outfile|
		outfile.puts header
		profiles.each do |phen_count, profile|
      #puts phen_count
			outfile.puts profile.join("\t") if phen_count > minimun_phen_count
		end
	end
end

########################################################
## options
########################################################
options = {}
OptionParser.new do |opts|

  options[:patients_filter] = 0
  opts.on("-p", "--phenotypes_filter INTEGER", "Minimum number of phenotypes to keep a pacient. Default #{options[:patients_filter]}") do |data|
    options[:patients_filter] = data.to_i
  end

  options[:header] = false
  opts.on("-H", "--header", "Set if the file has a line header. Default #{options[:header]}") do 
    options[:header] = true
  end

  options[:input_file] = nil
  opts.on("-i PATH", "--input_file PATH", "Input file with patient data") do |data|
    options[:input_file] = data
  end

  options[:output_file] = nil
  opts.on("-o PATH", "--output_file PATH", "Output file with patient data") do |data|
    options[:output_file] = data
  end

  options[:phen_col] = nil
  opts.on("-c INTEGER/STRING", "--column_of_phenotypes INTEGER/STRING", "Column name if header true or 0-based position of the column with the phenotypes") do |data|
  	options[:phen_col] = data
  end

  options[:separator] = '|'
  opts.on("-S STRING", "--separator STRING", "Set which character must be used to split the phenotypes. Default \'#{options[:separator]}\'") do |data|
  	options[:separator] = data
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
 
end.parse!

########################################################
## main
########################################################
profiles = load_profile(options[:input_file], options[:header], options[:phen_col])

filter_and_save(profiles, options[:output_file], options[:patients_filter])