# Dictionary Challenge

## Introduction
In April of 2020, during the Covid "Lockdown" a reddit member posted a question to the  [SQL subreddit](https://www.reddit.com/r/SQL/ "https://www.reddit.com/r/SQL/") titled "[What are some good resources to practice SQL? (Practice through exercises)](https://www.reddit.com/r/SQL/comments/g4ct1l/what_are_some_good_resources_to_practice_sql/ "https://www.reddit.com/r/SQL/comments/g4ct1l/what_are_some_good_resources_to_practice_sql/")".  A very active and knowledgeable [member](https://www.reddit.com/user/stiffupperleg/ "https://www.reddit.com/user/stiffupperleg/") of the subreddit posted this insightful [response](https://github.com/iweld/one_column_sql/blob/main/dictionary_challenge_post.md "Want to really learn some advanced SQL?").

Check out [My Questions and Answers](https://github.com/iweld/one_column_sql/blob/main/questions_and_answers.md "My Questions and Answers").

## Problem Statement

>"Want to really learn some advanced SQL?  Download the dictionary as a CSV. A single file with one column called **WORDS** where all the words in the English language are there.  Now there is a lot of things you can do with that data....."

1. Create a one column table with English words inserted from a csv file.
2. Test table by randomly selecting a word.
3. How many words are in our table?
4. How many words start with the letter '**J**'?
5. How many words end with the letter '**J**'?
6. How many words are x letters long and what is the percentage of the total number of words?
7. How many words contain '**jaime**'?
8. How many words contain '**shaker**'?
9. What are those words?
10. Convert the words that contain '**shaker**' to uppercase and concatnate their lengths (#).
11. Use two different methods to find the words that come before and after 'shaker'.
12. What words comes 5 words before and 10 words after **'shaker**'? Using the LAG()/LEAD() functions.
13. Use two different methods to find the longest word in this table and how many characters it contains.
14. What are the top 3 longest words in this table and how many characters do they contain (including ties)?
15. What is the average length of a word?
16. What is the 25th percentile, Median and 90th percentile length?
17. What is the word count for every letter in the words table and what is the percentage of the total? Sort by letter in ascending order.
18. What row number is the word '**shaker**' in?
19. Find the count of all the palindromes (Excluding single and two letter words).
20. Find the first 10 of all the palindromes that begin with the letter 'r' (Excluding single and two letter words).
21. Return the 15th palindrome (Excluding single and double letter words) of words that start with the letter 's'.
22. Write a query that returns the first 10 anadromes that contain 4 or more letters that start with the letter B.
23. Find the row number for every month of the year and sort them in chronological order.
24. Create a function that returns the number of words between a low and high letter count.
25. Create a function that counts the number of vowels in a word for words greater than or equal to 3 letters long.
26. Find the anagrams.

Check out [My Questions and Answers](https://github.com/iweld/one_column_sql/blob/main/questions_and_answers.md "My Questions and Answers").

## Dataset used
- <strong>words</strong>: A simple one column table with english words.
- <strong>csv</strong>/<strong>words.csv</strong>: CSV file containing one column of english words

:exclamation: If you found the repository helpful, please consider giving it a :star:. Thanks! :exclamation: