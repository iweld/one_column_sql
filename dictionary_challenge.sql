/*
	Simple PostgreSQL exercises using only one column of English words.
*/

-- Create Schema

CREATE SCHEMA IF NOT EXISTS dictionary_challenge;
SET search_path = dictionary_challenge;


-- Create a one column table and use that column as the primary key

DROP TABLE IF EXISTS dictionary_challenge.word_list;
CREATE TABLE dictionary_challenge.word_list (
	words VARCHAR(50) NOT NULL,
	PRIMARY KEY (words)
);

-- Copy csv into our new table.  Note the delimiter.

COPY dictionary_challenge.word_list
FROM '/var/lib/postgresql/source_data/csv/words.csv'
WITH DELIMITER ',' CSV;

-- If you prefer using DML insert commands you can find the entire table and contents in '/sql/words.sql'

-- Lets test the table to make sure everything is working properly.  

-- 1. How many words are in our table?

SELECT
	COUNT(*) AS word_count
FROM
	dictionary_challenge.word_list;

-- Results:

word_count|
----------+
    370103|

-- 2. Select a random, awesome word from the table.

SELECT
	words AS awesome_word -- We use AS to create an alias or temp name for our word.
FROM
	dictionary_challenge.word_list
WHERE -- We use the WHERE clause to filter the results.
	words = 'shaker';

-- Results:

awesome_word|
------------+
shaker      |

-- 3. How many words start with the letter 'j'?

SELECT
	COUNT(*) AS start_with_j_count
FROM
	dictionary_challenge.word_list
WHERE
	words LIKE 'j%'; -- The LIKE/ILIKE (case insensitive) operator is used to match text values against a pattern using wildcards.

-- Results:

start_with_j_count|
------------------+
              2840|
   
-- 4. How many words end with the letter 'j'?
   
SELECT
	COUNT(*) AS end_with_j_count
FROM
	dictionary_challenge.word_list
WHERE
	words LIKE '%j'; -- The LIKE/ILIKE (case insensitive) operator is used to match text values against a pattern using wildcards.

-- Results:

end_with_j_count|
----------------+
              30|
   
-- 5. How many words are x letters long and what is the percentage of the total number of words of that length?

-- Create a CTE (Common Table Expression) to get Word Count for X length words.
WITH get_word_length_count AS (         
	SELECT
		CHAR_LENGTH(words) AS word_length, -- char_length functions returns the numbers of characters in a word.
		COUNT(*) AS word_count
	FROM
		dictionary_challenge.word_list
	WHERE CHAR_LENGTH(words) > 1 -- Filter for words that contain 2 or characters.
	GROUP BY
		word_length  -- Results MUST be grouped when using Aggregate functions (count())
	ORDER BY -- Order the results in ascending order (default.)
		word_length
)
SELECT
	word_length,
	word_count,
	ROUND(100 * word_count / (SELECT SUM(word_count) 
		FROM get_word_length_count), 4) AS count_percentage -- Round the results to the 4th decimal place.
FROM
	get_word_length_count -- Select from the results of the CTE above.
GROUP BY 
	word_length,
	word_count
ORDER BY 
	word_length;

-- Results:

word_length|word_count|count_percentage|
-----------+----------+----------------+
          2|       427|          0.1154|
          3|      2130|          0.5756|
          4|      7186|          1.9418|
          5|     15918|          4.3013|
          6|     29874|          8.0724|
          7|     41998|         11.3484|
          8|     51627|         13.9503|
          9|     53402|         14.4300|
         10|     45872|         12.3953|
         11|     37539|         10.1436|
         12|     29125|          7.8700|
         13|     20944|          5.6594|
         14|     14149|          3.8233|
         15|      8846|          2.3903|
         16|      5182|          1.4002|
         17|      2967|          0.8017|
         18|      1471|          0.3975|
         19|       760|          0.2054|
         20|       359|          0.0970|
         21|       168|          0.0454|
         22|        74|          0.0200|
         23|        31|          0.0084|
         24|        12|          0.0032|
         25|         8|          0.0022|
         27|         3|          0.0008|
         28|         2|          0.0005|
         29|         2|          0.0005|
         31|         1|          0.0003|
         

-- 6. How many words contain 'jaime'?

SELECT
	COUNT(*) AS jaime_count
FROM
	dictionary_challenge.word_list
WHERE
	words LIKE '%jaime%';

-- Results:

jaime_count|
-----------+
          1|

-- There's only one and only.  

-- 7. How many words contain the word 'shaker'?

SELECT
	COUNT(*) AS shaker_count
FROM
	dictionary_challenge.word_list
WHERE
	words LIKE '%shaker%';

-- Results:

shaker_count|
------------+
          13|

-- 13? Must be a lucky word.  

-- 8. What are those words?

SELECT
	words AS words_containing_shaker
FROM
	dictionary_challenge.word_list
WHERE
	words LIKE '%shaker%';

-- Results:

words_containing_shaker|
-----------------------+
boneshaker             |
earthshaker            |
hallanshaker           |
handshaker             |
headshaker             |
saltshaker             |
shaker                 |
shakerag               |
shakerdom              |
shakeress              |
shakerism              |
shakerlike             |

-- 9. Convert the words that contain 'shaker' to uppercase and concatnate their length (#)
     
SELECT
	-- The upper() function convers letters to uppercase. lower() to lowercase and initcap() to capitalize the first letter of a string.
	UPPER(words) || ' (' || LENGTH(words) || ')' AS uppercase_and_length -- In Postgres we could use the concat() function OR || TO concatnate strings
FROM
	dictionary_challenge.word_list
WHERE
	words LIKE '%shaker%';
	
-- Results:

uppercase_and_length|
--------------------+
BONESHAKER (10)     |
EARTHSHAKER (11)    |
HALLANSHAKER (12)   |
HANDSHAKER (10)     |
HEADSHAKER (10)     |
SALTSHAKER (10)     |
SHAKER (6)          |
SHAKERAG (8)        |
SHAKERDOM (9)       |
SHAKERESS (9)       |
SHAKERISM (9)       |
SHAKERLIKE (10)     |
SHAKERS (7)         |

-- 10. Use two different methods to find the words that come before and after 'shaker'.

-- Use a WINDOW function to give each word a unique row number.
WITH get_row_number AS (
	SELECT	
		words,
		ROW_NUMBER() OVER () AS rn
	FROM
		dictionary_challenge.word_list
),
get_shaker_row AS ( -- Get the row numbers for shaker and +- 1. 
	SELECT
		rn, 
		rn - 1 AS before_rn,
		rn + 1 AS after_rn
	FROM 
		get_row_number
	WHERE
		words = 'shaker'
)
SELECT
	(SELECT words FROM get_row_number WHERE rn = before_rn) AS before_shaker, -- Use a sub-guery to select shaker row number -1 from CTE
	(SELECT words FROM get_row_number WHERE rn = after_rn) AS after_shaker -- Use a sub-guery to select shaker row number +1 from CTE
FROM 
	get_shaker_row;
	
-- Results:

before_shaker|after_shaker|
-------------+------------+
shakeproof   |shakerag    |

-- Use a CTE with the LEAD/LAG WINDOW functions to get the same results!
WITH get_lag_lead AS (
	SELECT
		words,
		LAG(words) OVER () AS prev_word,
		LEAD(words) OVER () AS next_word
	FROM 
		dictionary_challenge.word_list
)
SELECT
	prev_word AS before_shaker,
	next_word AS after_shaker
FROM
	get_lag_lead
WHERE 
	words = 'shaker';

-- Results:

before_shaker|after_shaker|
-------------+------------+
shakeproof   |shakerag    |

-- 11. What word comes 5 words before and 10 words after 'shaker'?  Using the LAG()/LEAD() function.

-- Use CTE with LEAD/LAG WINDOW functions to get values.
WITH get_lag_lead AS (
	SELECT
		words,
		-- LEAD/LAG functions can accept a second parameter that will move X amount of rows.
		LAG(words, 5) OVER () AS prev_word,
		LEAD(words, 10) OVER () AS next_word
	FROM 
		dictionary_challenge.word_list
)
SELECT
	prev_word AS five_before_shaker,
	next_word AS ten_after_shaker
FROM
	get_lag_lead
WHERE 
	words = 'shaker';

-- Results:

five_before_shaker|ten_after_shaker|
------------------+----------------+
shaken            |shakespearean   |


-- 12. Use two different methods to find the longest word in this table and how many characters it contains.

-- Using Limit

SELECT
	words AS longest_word,
	LENGTH(words) AS word_length
FROM
	dictionary_challenge.word_list
ORDER BY 
	word_length DESC -- Order in descending order (longest to shortest)
LIMIT 1; -- Limit to only one row (the first row)

longest_word                   |word_length|
-------------------------------+-----------+
dichlorodiphenyltrichloroethane|         31|


-- Using the DENSE_RANK() function within a CTE
WITH get_word_length_rank AS (
	SELECT 
		words AS each_word, 
		LENGTH(words) AS word_length,
		DENSE_RANK() OVER (
			ORDER BY LENGTH(words) DESC) AS rnk -- This function will rank words by their length.  We order by descending order.
	FROM
		dictionary_challenge.word_list
)
SELECT
	each_word AS longest_word,
	word_length
FROM 
	get_word_length_rank -- Select from the CTE above.
WHERE 
	rnk = 1; -- Only select the highest rank (longest length)
		
-- Results:
		
longest_word                   |word_length|
-------------------------------+-----------+
dichlorodiphenyltrichloroethane|         31|

-- 13. What are the top 3 longest words (including ties) in this table and how many characters do they contain?

-- Use a CTE to get the length of words and rank them in descending order (longest to shortest)
WITH get_word_length_rank AS (
	SELECT 
		words AS each_word, 
		LENGTH(words) AS word_length,
		DENSE_RANK() OVER (
			ORDER BY LENGTH(words) DESC) AS rnk
	FROM
		dictionary_challenge.word_list
)
SELECT
	rnk AS rank_number,
	each_word AS top_three_longest_words,
	word_length
FROM 
	get_word_length_rank
WHERE 
	rnk <= 3; -- Filter words that are ranked #3 or less.
		
-- Results:
		
rank_number|top_three_longest_words        |word_length|
-----------+-------------------------------+-----------+
          1|dichlorodiphenyltrichloroethane|         31|
          2|cyclotrimethylenetrinitramine  |         29|
          2|trinitrophenylmethylnitramine  |         29|
          3|antidisestablishmentarianism   |         28|
          3|hydroxydehydrocorticosterone   |         28|

-- 14. What is the average length of a word?

SELECT
	AVG(LENGTH(words)) avg_length
FROM
	dictionary_challenge.word_list;

-- Results:

avg_length        |
------------------+
9.4424984396235643|

-- 15. The previous answer returned a large floating point value.  Can you round that number to 2 decimal places?

SELECT
	ROUND(AVG(LENGTH(words)), 2) rounded_length
FROM
	dictionary_challenge.word_list;

-- Results:

rounded_length|
--------------+
          9.44|

-- 16. What is the 25th percentile, Median and 90th percentile length?

-- For this question we can use the PERCENTILE_CONT function.
-- The PERCENTILE_CONT function returns the value that corresponds to the specified percentile given a sort specification.          
SELECT
	PERCENTILE_CONT(0.25) WITHIN GROUP(
		ORDER BY LENGTH(words)) AS "25th_percentile",
	PERCENTILE_CONT(0.5) WITHIN GROUP(
		ORDER BY LENGTH(words)) AS median_length,
	PERCENTILE_CONT(0.9) WITHIN GROUP(
		ORDER BY LENGTH(words)) AS "90th_percentile"
FROM
	dictionary_challenge.word_list;

-- Results:

25th_percentile|median_length|90th_percentile|
---------------+-------------+---------------+
            7.0|          9.0|           13.0|


-- 17. What is the word count for every letter in the words table and what is the percentage of the total?
-- Sort by letter.

-- Use a CTE to extract the first letter and count of every word using the SUBSTRING() & COUNT() function.            
WITH get_letter_count AS (
	SELECT
		SUBSTRING(LOWER(words), 1, 1) AS letter,
		COUNT(*) AS word_count
	FROM
		dictionary_challenge.word_list
	GROUP BY
		letter
)
SELECT 
	letter,
	word_count,
	-- Find the percentage from the total count of words.  You must cast to numeric to be able to round.
	ROUND((word_count::FLOAT / (SELECT COUNT(*) FROM dictionary_challenge.word_list)*100)::NUMERIC, 2) AS total_percentage
FROM
	get_letter_count
GROUP BY 
	letter,
	word_count
ORDER BY
	letter;

-- Results:

letter|word_count|total_percentage|
------+----------+----------------+
a     |     25416|            6.87|
b     |     18413|            4.98|
c     |     32107|            8.68|
d     |     18733|            5.06|
e     |     14197|            3.84|
f     |     11893|            3.21|
g     |     10953|            2.96|
h     |     13743|            3.71|
i     |     13199|            3.57|
j     |      2840|            0.77|
k     |      3952|            1.07|
l     |     10002|            2.70|
m     |     19805|            5.35|
n     |     13458|            3.64|
o     |     12681|            3.43|
p     |     34860|            9.42|
q     |      1793|            0.48|
r     |     16783|            4.53|
s     |     38764|           10.47|
t     |     18819|            5.08|
u     |     22767|            6.15|
v     |      5329|            1.44|
w     |      6559|            1.77|
x     |       507|            0.14|
y     |      1143|            0.31|
z     |      1387|            0.37|

-- 18. What row number is the word 'shaker' in?  

-- Use CTE and use ROW_NUMBER WINDOW funtion to give a unique row number to every word.
WITH get_word_row_number AS (
	SELECT
		words,
		ROW_NUMBER() OVER() AS row_num
	FROM
		dictionary_challenge.word_list
)
SELECT
	row_num AS "Row Number",
	words AS "Cool Last Name"
FROM
	get_word_row_number
WHERE
	words = 'shaker'; -- Filter by the cool last name 'shaker'

-- Results:

Row Number|Cool Last Name|
----------+--------------+
    287206|shaker        |

-- 19. Find the count of all the palindromes (Excluding single and two letter words)

SELECT
	COUNT(*) AS palindrome_count
FROM
	dictionary_challenge.word_list
WHERE
	-- REVERSE() Function reverses the order of the string (jaime = emiaj)
	words = REVERSE(words) -- Filter words that are spelled the same in reverse order (palindrome).
AND -- AND OPERATOR gives another condition query MUST follow.
	LENGTH(words) >= 3; -- Filter words whose character length is 3 or greater.

-- Results:

palindrome_count|
----------------+
             193|

-- 20. Find the first 10 of all the palindromes that begin with the letter 'r' (Excluding single and two letter words)

SELECT
	words AS r_palindromes
FROM
	dictionary_challenge.word_list
WHERE
	words = REVERSE(words) -- Filter words that are spelled the same in reverse order (palindrome).
AND 
	LENGTH(words) >= 3 -- Filter words whose character length is 3 or greater.
AND 
	words LIKE 'r%' -- Filter words that begin with the letter 'r'.
ORDER BY
	words
LIMIT 10; -- LIMIT the first 10 records.

-- Results:

r_palindromes|
-------------+
radar        |
redder       |
refer        |
reifier      |
renner       |
repaper      |
retter       |
rever        |
reviver      |
rotator      |

-- 21. Return the 15th palindrome (Excluding single and double letter words) 
-- of words that start with the letter 's'

-- Using LIMIT/OFFSET

SELECT
	words AS "15th_s_palindrome"
FROM
	dictionary_challenge.word_list
WHERE
	words = REVERSE(words)
AND 
	LENGTH(words) >= 3
AND 
	words LIKE 's%'
ORDER BY
	words
LIMIT 1 -- LIMIT the TOP result
OFFSET 14; -- The OFFSET clause allow to begin at a specific record and omit the rest that come before.

-- USING ROW_NUMBER() function.

WITH get_nth_palindrome as (
	SELECT
		words,
		ROW_NUMBER() OVER () AS rn
	FROM
		dictionary_challenge.word_list
	WHERE
		words = REVERSE(words)
	AND 
		LENGTH(words) >= 3
	AND 
		words LIKE 's%'
	ORDER BY
		words
)
SELECT
	words AS "15th_s_palindrome"
FROM
	get_nth_palindrome
WHERE 
	rn = 15; -- FILTER the 15th row number given to the word in the cte above.

-- Results:

15th_s_palindrome|
-----------------+
sooloos          |

-- 22. Write a query that returns the first 10 anadromes that contain 4 or more letters that start with the letter B.

-- An Anadrome is a word which forms a different word when spelled backwards.

SELECT
	words,
	REVERSE(words) AS anadrome
FROM
	dictionary_challenge.word_list
WHERE 
	REVERSE(words) IN (SELECT words FROM dictionary_challenge.word_list) -- FILTER if the word in reverse exists in the table.
AND 
	words <> REVERSE(words) -- FILTER out palindromes
AND 
	LENGTH(words) >= 4 -- FILTER words with 4 or more characters.
AND 
	words LIKE 'b%'
LIMIT 
	10; -- Display the top 10 ONLY.

-- Results:

word  |anadrome|
------+--------+
bakra |arkab   |
bals  |slab    |
bank  |knab    |
bans  |snab    |
bara  |arab    |
barb  |brab    |
bard  |drab    |
bares |serab   |
barf  |frab    |
barger|regrab  |

-- 23. Find the row number for every month of the year and
-- sort them in chronological order and convert the first letter 
-- of every word to uppercase.

-- Use a CTE to give every word a unique row number
WITH get_month_row_number AS (
	SELECT
		words,
		ROW_NUMBER() OVER() AS row_num
	FROM
		dictionary_challenge.word_list
)
SELECT
	row_num AS "Row Number", -- SELECT a row number
	INITCAP(words) AS "Month" -- Use the INITCAP() function to capitalize the first letter.
FROM
	get_month_row_number
WHERE
	words IN ( -- Use the IN operator to filter only words IN list.
	'january',
	'february',
	'march',
	'april',
	'may',
	'june',
	'july',
	'august',
	'september',
	'october',
	'november',
	'december')
ORDER BY
	-- TO_DATE() function converts a string TO a date which can be sorted chronologicaly.
	TO_DATE(words, 'Month');

-- Results:

Row Number|Month    |
----------+---------+
    160354|January  |
    110744|February |
    179890|March    |
     18070|April    |
    177740|May      |
    162341|June     |
    162225|July     |
     23405|August   |
    285651|September|
    211041|October  |
    209161|November |
     78174|December |
     
/*
 NOTE!
 
 The following code uses PL/pgSQL which is an SQL Procedural Language.  PL/pgSQL is a loadable procedural language for the PostgreSQL database system. 
 The design goals of PL/pgSQL were to create a loadable procedural language that
	- can be used to create functions, procedures, and triggers,
	- adds control structures to the SQL language,
	- can perform complex computations,
	- inherits all user-defined types, functions, procedures, and operators

	https://www.postgresql.org/docs/current/plpgsql-overview.html

 */     
     
-- 24. Create a function that returns the number of words between an upper and lower letter count.
-- Return the number or words with character lengths between 4 and 7 characters.
 
--DROP FUNCTION get_word_count;     

-- Create a new function that takes to integers. A lower limit and higher limit.     
CREATE FUNCTION get_word_count(l_from INT, l_to INT)
-- This function returns an integer.
RETURNS INT
-- Define the language
LANGUAGE plpgsql
AS
$$
	-- Declare variables
	DECLARE
		word_count INT;
	-- Begin the query
	BEGIN
		SELECT
			COUNT(*)
		-- Insert the selected value into our declared variable.
		INTO 
			word_count
		FROM 
			dictionary_challenge.word_list
		WHERE 
			-- Use the BETWEEN operator to select words with lengths BETWEEN our upper and lower limit
			LENGTH(words) BETWEEN l_from AND l_to;
	-- Return the value of the variable
	RETURN word_count;
	-- End the function
	END;
$$;

-- Call the function and give an upper and lower integer range.
SELECT get_word_count(4, 7);

-- Results:

get_word_count|
--------------+
         94976|


-- 25. Create a function that counts the number of vowels in a word for words greater than or equal to 3 letters long.

-- Create a function that counts the numer of vowels in a word.                  
DROP FUNCTION count_the_vowels;
CREATE FUNCTION count_the_consonants(current_word TEXT)
-- Function returns an integer
RETURNS INT
LANGUAGE plpgsql
AS
$$
	-- Declare variables
	DECLARE 
		consonant_count INT;
	BEGIN
		SELECT
			-- Replace vowels with '' then subtract the length of the word with the removed vowels word length.
			-- So we are subtracting the original length against the length where vowels are removed to get the difference.
			LENGTH(current_word) - LENGTH(REGEXP_REPLACE(LOWER(current_word), '[aeiou]', '', 'gi'))
			INTO consonant_count;
		RETURN consonant_count;
	END;
$$;

-- Create a temp table for word metrics.

DROP TABLE IF EXISTS word_metrics;
CREATE TEMP TABLE word_metrics AS (
	SELECT 
		words,
		LENGTH(words) AS letter_count,
		count_the_consonants(words) AS vowel_count,
		LENGTH(words) - count_the_consonants(words) AS consonants_count,
		ROUND(100 * count_the_consonants(words) / LENGTH(words)::NUMERIC, 2) AS consonants_percentage,
		100 - ROUND(100 * count_the_consonants(words) / LENGTH(words)::NUMERIC, 2) AS vowel_percentage
	FROM
		dictionary_challenge.word_list
	WHERE LENGTH(words) >= 3
);

SELECT 
	* 
FROM word_metrics
-- We use the RANDOM function to generate a random number to OFFSET.  
OFFSET FLOOR(RANDOM() * 370103) LIMIT 10;

-- Results:

words           |letter_count|vowel_count|consonants_count|consonants_percentage|vowel_percentage|
----------------+------------+-----------+----------------+---------------------+----------------+
nonfundamentally|          16|          5|              11|                31.25|           68.75|
nonfunded       |           9|          3|               6|                33.33|           66.67|
nonfungible     |          11|          4|               7|                36.36|           63.64|
nonfuroid       |           9|          4|               5|                44.44|           55.56|
nonfused        |           8|          3|               5|                37.50|           62.50|
nonfusibility   |          13|          5|               8|                38.46|           61.54|
nonfusible      |          10|          4|               6|                40.00|           60.00|
nonfusion       |           9|          4|               5|                44.44|           55.56|
nonfutile       |           9|          4|               5|                44.44|           55.56|
nonfuturistic   |          13|          5|               8|                38.46|           61.54|


-- 26. Find the anagrams.

-- This query can take a long time to execute. To shorten execution time, we will 
-- only look for words that start with the letter 'R' and are only 4 or 5 characters in length.
-- We will also limit the results to the first 10.

-- Create a function that sorts word into alphabetical order

DROP FUNCTION sort_word;
CREATE FUNCTION sort_word (my_word TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS
$$
	DECLARE sorted_word TEXT;
	BEGIN
		-- 2. Aggregate sorted array back into a string
		SELECT STRING_AGG(tmp.split_word, '') AS sorted_str
		FROM
			-- 1. Split the word into an array and sort array after unnesting
			(SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(my_word, '')) AS split_word ORDER BY split_word) AS tmp
		INTO sorted_word;
	RETURN sorted_word;
	END;
$$;

DROP TABLE IF EXISTS sorted_words;

-- Create a temp table with sorted words and add a row number as an id.
CREATE TEMP TABLE sorted_words AS (
	SELECT
		ROW_NUMBER() OVER () AS rn,
		words,
		sort_word(words) AS sorted
	FROM
		dictionary_challenge.word_list
);

-- Test the new temp table
SELECT * FROM sorted_words;

-- Using a CTE, check for Anagrams
WITH get_anagram AS (
	SELECT 
		s1.words AS word,
		CASE
			-- Only check words of the same length.
			WHEN LENGTH(s1.sorted) = LENGTH(s2.sorted) THEN
				CASE
					-- If sorted words are the same, they contain the same letters and are anagrams
					WHEN s1.sorted = s2.sorted THEN s2.words
					ELSE NULL
				END
		END AS anagram
	FROM sorted_words AS s1
	JOIN sorted_words AS s2
	ON s1.rn <> s2.rn
)
SELECT
	word,
	-- Aggregate anagrams into the same row and seperate with a comma
	STRING_AGG(anagram, ', ') AS anagrams
FROM
	get_anagram
WHERE 
	anagram IS NOT NULL
AND 
	LENGTH(word) > 3
AND 
	LENGTH(word) <= 5
AND 
	word LIKE 'r%'
GROUP BY 
	word
ORDER BY 
	word
LIMIT 10;
	
-- Results:

word |anagrams                    |
-----+----------------------------+
raad |adar, arad, rada            |
raash|asarh, haars, haras, sarah  |
rabal|labra                       |
rabat|barat                       |
rabi |abir, abri, bari            |
rabic|baric, carib                |
rabid|barid, bidar, braid         |
rabin|abrin, bairn, brain, brian  |
rabot|abort, boart, tabor         |
race |acer, acre, care, cera, crea|









	

	
	
	
	
	
	
	
