/*
	Simple PostgreSQL exercises using one column of English words.
*/


-- Create a one column table and use that column as the primary key
DROP TABLE IF EXISTS WORDS;
CREATE TABLE WORDS (
	WORD VARCHAR(50),
	PRIMARY KEY (WORD)
);

-- Import csv from wheverever you have it stored.  Note the delimiter.

COPY WORDS
FROM
'** Path to your **/csv/words.csv'
DELIMITER ',';

-- 1. Test table by randomly grabbing an awesome word from the table

SELECT
	WORD AS awesome_word
FROM
	WORDS
WHERE
	WORD = 'shaker';

-- Results:

awesome_word|
------------+
shaker      |

-- 2. How many words are in our table?

SELECT
	COUNT(*) AS word_count
FROM
	WORDS;

-- Results:

count |
------+
370103|

-- 3. How many words start with the letter 'j'?

SELECT
	COUNT(*) AS j_count
FROM
	WORDS
WHERE
	WORD LIKE 'j%';

-- Results:

j_count|
-------+
   2840|
   
-- 4. How many words are x letters long? (Excluding single letters)
   
SELECT
	char_length(word) AS word_length,
	count(*) AS word_count
FROM
	words
WHERE char_length(word) > 1
GROUP BY
	word_length
ORDER BY
	word_length;

-- Results:

word_length|word_count|
-----------+----------+
          2|       427|
          3|      2130|
          4|      7186|
          5|     15918|
          6|     29874|
          7|     41998|
          8|     51627|
          9|     53402|
         10|     45872|
         11|     37539|
         12|     29125|
         13|     20944|
         14|     14149|
         15|      8846|
         16|      5182|
         17|      2967|
         18|      1471|
         19|       760|
         20|       359|
         21|       168|
         22|        74|
         23|        31|
         24|        12|
         25|         8|
         27|         3|
         28|         2|
         29|         2|
         31|         1|
         

-- 5. How many words contain 'jaime'?

SELECT
	COUNT(*) AS jaime_count
FROM
	WORDS
WHERE
	WORD LIKE '%jaime%';

-- Results:

count|
-----+
    1|

-- 6. There's only one and only.  How many words contain 'shaker'?

SELECT
	COUNT(*) AS shaker_count
FROM
	WORDS
WHERE
	WORD LIKE '%shaker%';

-- Results:

count|
-----+
   13|

-- 7. 13? Must be a lucky word.  What are those words?

SELECT
	WORD
FROM
	WORDS
WHERE
	WORD LIKE '%shaker%';

-- Results:

word        |
------------+
boneshaker  |
earthshaker |
hallanshaker|
handshaker  |
headshaker  |
saltshaker  |
shaker      |
shakerag    |
shakerdom   |
shakeress   |
shakerism   |
shakerlike  |
shakers     |

-- 8. Convert words that contain 'shaker' to uppercase and concatnate their length (#)
     
SELECT
	upper(WORD) || ' (' || length(word) || ')' AS upper_case
FROM
	WORDS
WHERE
	WORD LIKE '%shaker%';
	
-- Results:

upper_case       |
-----------------+
BONESHAKER (10)  |
EARTHSHAKER (11) |
HALLANSHAKER (12)|
HANDSHAKER (10)  |
HEADSHAKER (10)  |
SALTSHAKER (10)  |
SHAKER (6)       |
SHAKERAG (8)     |
SHAKERDOM (9)    |
SHAKERESS (9)    |
SHAKERISM (9)    |
SHAKERLIKE (10)  |
SHAKERS (7)      |

-- 9. What word comes before and after 'shaker'?  Using the LAG()/LEAD() function.

WITH get_lag_lead AS (
	SELECT
		word,
		LAG(word) OVER () AS prev_word,
		LEAD(word) OVER () AS next_word
	FROM words
)
SELECT
	prev_word AS before_shaker,
	next_word AS after_shaker
from
	get_lag_lead
WHERE word = 'shaker';

-- Results:

before_shaker|after_shaker|
-------------+------------+
shakeproof   |shakerag    |

-- 10. What word comes 5 words before and 10 words after 'shaker'?  Using the LAG()/LEAD() function.

WITH get_lag_lead AS (
	SELECT
		word,
		LAG(word, 5) OVER () AS prev_word,
		LEAD(word, 10) OVER () AS next_word
	FROM words
)
SELECT
	prev_word AS five_before_shaker,
	next_word AS ten_after_shaker
from
	get_lag_lead
WHERE word = 'shaker';

-- Results:

five_before_shaker|ten_after_shaker|
------------------+----------------+
shaken            |shakespearean   |


-- 11. What is the longest word in this table and how many characters does it contain?
-- Use the DENSE_RANK() function

WITH get_word_length_rank AS (
	SELECT 
		WORD AS each_word, 
		length(word) AS w_length,
		DENSE_RANK() OVER (ORDER BY length(word) DESC) AS rnk
	FROM
		WORDS
)
SELECT
	each_word AS longest_word,
	w_length AS word_length
FROM 
	get_word_length_rank
WHERE 
	rnk = 1;
		
-- Results:
		
Longest Word                   |Word Length|
-------------------------------+-----------+
dichlorodiphenyltrichloroethane|         31|

-- 12. What are the top 3 longest words in this table and how many characters do they contain?
-- Use DENSE_RANK() function and include ties.

WITH get_word_length_rank AS (
	SELECT 
		WORD AS each_word, 
		length(word) AS w_length,
		DENSE_RANK() OVER (ORDER BY length(word) DESC) AS rnk
	FROM
		WORDS
)
SELECT
	rnk AS rank_number,
	each_word AS top_three_longest_words,
	w_length AS word_length
FROM 
	get_word_length_rank
WHERE 
	rnk <= 3;
		
-- Results:
		
rank_number|top_three_longest_words        |word_length|
-----------+-------------------------------+-----------+
          1|dichlorodiphenyltrichloroethane|         31|
          2|cyclotrimethylenetrinitramine  |         29|
          2|trinitrophenylmethylnitramine  |         29|
          3|antidisestablishmentarianism   |         28|
          3|hydroxydehydrocorticosterone   |         28|

-- 13a. What is the average length of a word?

SELECT
	AVG(LENGTH(WORD)) avg_length
FROM
	WORDS;

-- Results:

avg_length        |
------------------+
9.4424984396235643|

-- 13b. That returned a floating point value.  Can you round that number to 2 decimal places?

SELECT
	ROUND(AVG(LENGTH(WORD)), 2) AS rounded_length
FROM
	WORDS;

-- Results:

rounded_length|
--------------+
          9.44|

-- 14. What is the 25th percentile, Median and 90th percentile length?

SELECT
	PERCENTILE_CONT(0.25) WITHIN GROUP(
	ORDER BY length(word)) AS "25th_percentile",
	PERCENTILE_CONT(0.5) WITHIN GROUP(
	ORDER BY length(word)) AS median_length,
	PERCENTILE_CONT(0.9) WITHIN GROUP(
	ORDER BY length(word)) AS "90th_percentile"
FROM
	words;

-- Results:

25th_percentile|median_length|90th_percentile|
---------------+-------------+---------------+
            7.0|          9.0|           13.0|


-- 15. What is the word count for every letter in the words table and what is the percentage of the total?
-- Sort by letter.

WITH get_letter_count AS (
	SELECT
		SUBSTRING(LOWER(word), 1, 1) AS letter,
		COUNT(*) AS word_count
	FROM
		words
	GROUP BY
		letter
)
SELECT 
	letter,
	word_count,
	round((word_count::float / (SELECT count(*) FROM words)*100)::NUMERIC, 2) AS total_percentage
from
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

-- 16. What row number is the word 'shaker' in?  

WITH get_word_row_number AS (
	SELECT
		WORDS.*,
		ROW_NUMBER() OVER() AS ROW_NUM
	FROM
		WORDS
)
SELECT
	ROW_NUM AS "Row Number",
	WORD AS "Cool Last Name"
FROM
	get_word_row_number
WHERE
	WORD = 'shaker';

-- Results:

Row Number|Cool Last Name|
----------+--------------+
    287206|shaker        |

-- 17. Find the count of all the palindromes (Excluding single and two letter words)

SELECT
	COUNT(*) AS n_palindromes
FROM
	WORDS
WHERE
	WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3;

-- Results:

n_palindromes|
-------------+
          193|

-- 18. Find the first 10 of all the palindromes that begin with the letter 'r' (Excluding single and two letter words)

SELECT
	WORD AS r_palindromes
FROM
	WORDS
WHERE
	WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3
	AND word LIKE 'r%'
ORDER BY
	WORD
LIMIT 10;

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

-- 19a. Give me the 15th palindrome (Excluding single and double letter words) 
-- of words that start with the letter 's'

SELECT
	WORD AS "15th_s_palindrome"
FROM
	WORDS
WHERE
	WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3
	AND word LIKE 's%'
ORDER BY
	WORD
LIMIT 1 
OFFSET 14;

-- 19b. Or use the ROW_NUMBER() window function.

WITH get_nth_palindrome as (
	SELECT
		WORD,
		ROW_NUMBER() OVER () AS rn
	FROM
		WORDS
	WHERE
		WORD = REVERSE(WORD)
		AND LENGTH(WORD) >= 3
		AND word LIKE 's%'
	ORDER BY
		WORD
)
SELECT
	word AS "15th_s_palindrome"
FROM
	get_nth_palindrome
WHERE rn = 15;

-- Results:

15th_s_palindrome|
-----------------+
sooloos          |

-- 20. Write a query that returns the first 10 anadromes that contain 4 or more letters that start with the letter B.

SELECT
	word,
	reverse(word) AS anadrome
FROM
	words
WHERE reverse(word) IN (SELECT word FROM words)
AND word <> reverse(word)
AND length(word) >= 4
AND word LIKE 'b%'
LIMIT 10;

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

-- 21. Find the row number for every month of the year and
-- sort them in chronological order

WITH get_month_row_number AS (
	SELECT
		WORDS.*,
		ROW_NUMBER() OVER() AS ROW_NUM
	FROM
		WORDS
)
SELECT
	ROW_NUM AS "Row Number",
	WORD AS "Month"
FROM
	get_month_row_number
WHERE
	WORD IN (
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
	TO_DATE(WORD, 'Month');

-- Results:

Row Number|Month    |
----------+---------+
    160354|january  |
    110743|february |
    179890|march    |
     18069|april    |
    177740|may      |
    162341|june     |
    162225|july     |
     23405|august   |
    285651|september|
    211036|october  |
    209152|november |
     78173|december |
     
-- 22. Create a function that returns the number of words between a low and high letter count.
 
DROP FUNCTION get_word_count;     

CREATE FUNCTION get_word_count(l_from int, l_to int)
RETURNS int
LANGUAGE plpgsql
AS
$$
	DECLARE
		word_count int;
	BEGIN
		SELECT
			count(*)
		INTO word_count
		FROM words
		WHERE length(word) BETWEEN l_from AND l_to;
	
	RETURN word_count;
	END;
$$;


SELECT get_word_count(4, 7);

-- Results:

get_word_count|
--------------+
         94976|


-- 23. Create a function that counts the number of vowels in a word for words greater than or equal to 3 letters long.
         
DROP FUNCTION count_the_vowels;

CREATE FUNCTION count_the_vowels(current_word text)
RETURNS int
LANGUAGE plpgsql
AS
$$
	DECLARE 
		vowel_count int;
	BEGIN
		SELECT
			-- Replace vowels with '' then subtract the length of the word with the removed vowels word length.
			length(current_word) - length(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(lower(current_word), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')
								)
			INTO vowel_count;
		RETURN vowel_count;
	END;
$$;

-- Create a temp table for word metrics.

DROP TABLE IF EXISTS word_metrics;
CREATE TEMP TABLE word_metrics AS (
	SELECT 
		word,
		length(word) AS letter_count,
		count_the_vowels(word) AS vowel_count,
		length(word) - count_the_vowels(word) AS difference,
		round(100 * count_the_vowels(word) / length(word)::NUMERIC, 2) AS vowel_percentage,
		100 - round(100 * count_the_vowels(word) / length(word)::NUMERIC, 2) AS consonant_percentage
	FROM
		words
	WHERE length(word) >= 3
);

SELECT 
	* 
FROM word_metrics
LIMIT 10;

-- Results:

word  |letter_count|vowel_count|difference|vowel_percentage|consonant_percentage|
------+------------+-----------+----------+----------------+--------------------+
aaa   |           3|          3|         0|          100.00|                0.00|
aah   |           3|          2|         1|           66.67|               33.33|
aahed |           5|          3|         2|           60.00|               40.00|
aahing|           6|          3|         3|           50.00|               50.00|
aahs  |           4|          2|         2|           50.00|               50.00|
aal   |           3|          2|         1|           66.67|               33.33|
aalii |           5|          4|         1|           80.00|               20.00|
aaliis|           6|          4|         2|           66.67|               33.33|
aals  |           4|          2|         2|           50.00|               50.00|
aam   |           3|          2|         1|           66.67|               33.33|


-- 24. Find the anagrams.

-- This query can take a long time to execute. To shorten execution time, we will 
-- only look for words that start with the letter 'R' and are only 4 or 5 characters in length.
-- We will also limit the results to the first 10.

-- Create a function that sorts word into alphabetical order
DROP FUNCTION sort_word;

CREATE FUNCTION sort_word (my_word text)
RETURNS TEXT
LANGUAGE plpgsql
AS
$$
	DECLARE sorted_word TEXT;
	BEGIN
		-- 2. Aggregate sorted array back into a string
		SELECT string_agg(tmp.split_word, '') AS sorted_str
		FROM
			-- 1. Split the word into an array and sort array after unnesting
			(SELECT UNNEST(regexp_split_to_array(my_word, '')) AS split_word ORDER BY split_word) AS tmp
		INTO sorted_word;
	RETURN sorted_word;
	END;
$$;

DROP TABLE IF EXISTS sorted_words;

-- Create a temp table with sorted words and add a row number as an id.
CREATE TEMP TABLE sorted_words AS (
	SELECT
		ROW_NUMBER() OVER () AS rn,
		word,
		sort_word(word) AS sorted
	FROM
		words
);

-- Test the new temp table
SELECT * FROM sorted_words;

WITH get_anagram AS (
	SELECT 
		s1.word AS word,
		CASE
			-- Only check words of the same length
			WHEN length(s1.sorted) = length(s2.sorted) THEN
				CASE
					-- If sorted words are the same, they contain the same letters and are anagrams
					WHEN s1.sorted = s2.sorted THEN s2.word
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
	string_agg(anagram, ', ') AS anagrams
FROM
	get_anagram
WHERE anagram IS NOT NULL
AND length(word) > 3
AND length(word) <= 5
AND word LIKE 'r%'
GROUP BY word
ORDER BY word
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










	

	
	
	
	
	
	
	
