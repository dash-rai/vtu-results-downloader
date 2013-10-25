=begin

Note: This script will not output pretty results for you. If that is what you're looking for take a look at the bash script here:
https://code.google.com/p/vtu-results-download/
This is hence more useful from a data analysis and research point-of-view.

@author: Darshan Rai
ruby "2.0.0"
Written October, 2013.

This script is free to use and modify and licensed under the GNU General Public License 2 as long as proper attribution is given.

Output is in the form of:
[USN], [subject code], [external marks], [internal marks], [Result (P/F)] ...
=end

require 'csv'
prompt = '> '

puts "Enter college code (eg. \"BY\"): "
print prompt
college_code = STDIN.gets.chomp

puts "Enter year of joining [YY]: "
print prompt
year_of_joining = STDIN.gets.chomp

puts "Enter the branch code (eg. \"CS\"): "
print prompt
branch_code = STDIN.gets.chomp

puts "Enter the strength of branch: "
print prompt
strength = STDIN.gets.chomp.to_i

exp = /\((\d{2}\w+\d{2,})\).*?<td.*?>(\d+).*?<td.*?>(\d+).*?<td.*?>(\d+).*?<b>(\w)<\/b>/

(1..strength).each do |roll_no|
  
  usn = "1%s%d%s%03d" % [college_code, year_of_joining, branch_code, roll_no]

  html = %x[curl -s -d "rid=#{usn}&submit=SUBMIT" http://results.vtu.ac.in]

  result = html.scan exp

  if not result.empty?
    row = [usn]
    (0...result.length).each do |i|
      row.push result[i][0]
      row.push result[i][1]
      row.push result[i][2]
      row.push result[i][3]
      row.push result[i][4]
    end


    CSV.open("vtu-results.csv", "a") do |csv|
      csv << row
    end
    puts usn
  end

  sleep (1) # Slow down, cowboy!
end

puts "Results are saved as a CSV file in 'vtu-results.csv'"
puts
