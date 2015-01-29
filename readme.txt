PROBLEM:
Write a Ruby program to first assemble a single set of records by parsing data from 3 different file formats, and then display these records sorted in 3 different ways.

INPUT DATA
A record consists of the following 5 fields: last name, first name, gender, date of birth and favorite color. You will be given 3 files, each containing records stored in a different format.

The pipe-delimited file record format:
LastName | FirstName | MiddleInitial | Gender(M/F) | FavoriteColor | DateOfBirth(M-D-YYYY)

The comma-delimited file record format:
LastName, FirstName, Gender(Male/Female), FavoriteColor, DateOfBirth(M/D/YYYY)

The space-delimited file record format:
LastName FirstName MiddleInitial Gender(M/F) DateOfBirth(M-D-YYYY) FavoriteColor

You may assume that the delimiters (commas, pipes and spaces) do not appear anywhere in the data values themselves.

DISPLAY REQUIREMENTS
Create and display 3 different views of the recordset:
Output 1 – sorted by gender (females before males) then by last name ascending.
Output 2 – sorted by birth date, ascending.
Output 3 – sorted by last name, descending.
Ensure that fields are displayed in the following order: last name, first name, gender, date of birth, favorite color.
Display dates in the format MM/DD/YYYY.

===================================
SOLUTION:
Ruby version:  1.9.3
Run solution.rb
