# Dictionary Challenge

## Introduction
In April of 2020, during the Covid "Lockdown" a reddit member posted a question to the  [SQL subreddit](https://www.reddit.com/r/SQL/ "https://www.reddit.com/r/SQL/") titled "[What are some good resources to practice SQL? (Practice through exercises)](https://www.reddit.com/r/SQL/comments/g4ct1l/what_are_some_good_resources_to_practice_sql/ "https://www.reddit.com/r/SQL/comments/g4ct1l/what_are_some_good_resources_to_practice_sql/")".  A very active and knowledgeable [member](https://www.reddit.com/user/stiffupperleg/ "https://www.reddit.com/user/stiffupperleg/") of the subreddit posted this insightful [response](https://github.com/iweld/one_column_sql/blob/main/dictionary_challenge.md "Want to really learn some advanced SQL?").

Check out [My Questions and Answers](https://github.com/iweld/one_column_sql/blob/main/questions_and_answers.md "My Questions and Answers").

## Problem Statement

>"Want to really learn some advanced SQL?  Download the dictionary as a CSV. A single file with one column called **WORDS** where all the words in the English language are there.  Now there is a lot of things you can do with that data....."

- Create a one column table with English words inserted from a csv file.
- Test table by randomly selecting a word.
- How many words are in our table?
- How many words start with the letter '**J**'?
- How many words end with the letter '**J**'?
- How many words are x letters long and what is the percentage of the total number of words?
- How many words contain '**jaime**'?
- How many words contain '**shaker**'?
- What are those words?
- Convert the words that contain '**shaker**' to uppercase and concatnate their lengths (#).
- Use two different methods to find the words that come before and after 'shaker'.
- What words comes 5 words before and 10 words after **'shaker**'? Using the LAG()/LEAD() functions.
- What is the longest word in this table and how many characters does it contain?
- What are the top 3 longest words in this table and how many characters do they contain (including ties)?
- What is the average length of a word?
- What is the 25th percentile, Median and 90th percentile length?
- What is the word count for every letter in the words table and what is the percentage of the total? Sort by letter in ascending order.
- What row number is the word '**shaker**' in?
- Find the count of all the palindromes (Excluding single and two letter words).
- Find the first 10 of all the palindromes that begin with the letter 'r' (Excluding single and two letter words).
- Return the 15th palindrome (Excluding single and double letter words) of words that start with the letter 's'.
- Write a query that returns the first 10 anadromes that contain 4 or more letters that start with the letter B.
- Find the row number for every month of the year and sort them in chronological order.
- Create a function that returns the number of words between a low and high letter count.
- Create a function that counts the number of vowels in a word for words greater than or equal to 3 letters long.
- Find the anagrams.

Check out [My Questions and Answers](https://github.com/iweld/one_column_sql/blob/main/questions_and_answers.md "My Questions and Answers").

## Datasets used
- <strong>words</strong>: A simple one column table with english words.
- <strong>csv</strong>/<strong>words.csv</strong>: CSV file containing one column of english words
