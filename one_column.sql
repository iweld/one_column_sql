/*
	Simple PostgreSQL exercises using one column of English words.
*/

-- Just like it says, drop the table if it exists

DROP TABLE IF EXISTS WORDS;

-- Create a one column table and use that column as the primary key

CREATE TABLE WORDS (
	WORD VARCHAR(50),
	PRIMARY KEY (WORD)
);

-- Import csv from wheverever you have it stored.  Note the delimiter.

COPY WORDS
FROM '** Path to your **/csv/words.csv'
DELIMITER ',';

-- Test table by randomly grabbing an awesome word from the record

SELECT WORD AS great_word
FROM WORDS
WHERE WORD = 'shaker';

-- Results:

great_word|
----------+
shaker    |

-- How many words are we starting with?

SELECT COUNT(*)
FROM WORDS;

-- Results:

count |
------+
370103|

-- How many words start with the letter 'j'?

SELECT COUNT(*) AS j_count
FROM WORDS
WHERE WORD like 'j%';

-- Results:

j_count|
-------+
   2840|

-- How many words contain 'jaime'?

SELECT COUNT(*)
FROM WORDS
WHERE WORD like '%jaime%';

-- Results:

count|
-----+
    1|

-- There's only one and only.  How many words contain 'shaker'?

SELECT COUNT(*)
FROM WORDS
WHERE WORD like '%shaker%';

-- Results:

count|
-----+
   13|

-- 13? Must be a lucky word.  What are those words?

SELECT WORD
FROM WORDS
WHERE WORD like '%shaker%';

-- Speaking of 13.  How many words are 13 letters long?

SELECT COUNT(*)
FROM WORDS
WHERE LENGTH(WORD) = 13;

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

-- What is the longest word in this table and how many characters does it contain?

SELECT WORD as "Longest Word", length(word) as "Word Length" 
FROM WORDS
WHERE LENGTH(WORD) =
		(SELECT MAX(LENGTH(WORD))
			FROM WORDS);
		
-- Results:
		
Longest Word                   |Word Length|
-------------------------------+-----------+
dichlorodiphenyltrichloroethane|         31|

-- What is the Average word length?

SELECT AVG(LENGTH(WORD)) avg_length
FROM WORDS;

-- Results:

avg_length        |
------------------+
9.4424984396235643|

-- That returned a floating point value.  Can you round that number to two decimal places?

SELECT ROUND(AVG(LENGTH(WORD)), 2)
FROM WORDS;

-- Results:

round|
-----+
 9.44|

-- What is the Median length?

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY length(word)) AS median_length
FROM words;

-- Results:

median_length|
-------------+
          9.0|

-- What is the 90th percentile length?

SELECT PERCENTILE_CONT(0.9) WITHIN GROUP(ORDER BY length(word)) AS "90th_percentile"
FROM words;

-- Results:

90th_percentile|
---------------+
           13.0|

-- What is the 25th percentile length?

SELECT PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY length(word)) AS "25th_percentile" 
FROM words;

-- Results:

25th_percentile|
---------------+
            7.0|

-- What is the word count for every letter in the words table?
-- Sort by letter.

SELECT SUBSTRING(LOWER(WORD),1,1) AS LETTER,
	COUNT(*)
FROM WORDS
GROUP BY LETTER
ORDER BY LETTER;

-- Results:

letter|count|
------+-----+
a     |25416|
b     |18413|
c     |32107|
d     |18733|
e     |14197|
f     |11893|
g     |10953|
h     |13743|
i     |13199|
j     | 2840|
k     | 3952|
l     |10002|
m     |19805|
n     |13458|
o     |12681|
p     |34860|
q     | 1793|
r     |16783|
s     |38764|
t     |18819|
u     |22767|
v     | 5329|
w     | 6559|
x     |  507|
y     | 1143|
z     | 1387|

-- What row number is the word 'shaker' in?  

SELECT ROW_NUM AS "Row Number",
	WORD AS "Cool Last Name"
FROM
	(SELECT WORDS.*,
			ROW_NUMBER() OVER() AS ROW_NUM
		FROM WORDS) AS ROW
WHERE WORD = 'shaker';

-- Results:

Row Number|Cool Last Name|
----------+--------------+
    287206|shaker        |

-- Find the count of all the palindromes (Excluding single and two letter words)

SELECT COUNT(*) AS n_palindromes
FROM WORDS
WHERE WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3;

-- Results:

n_palindromes|
-------------+
          193|

-- Give me the first 10 of all the palindromes (Excluding single and two letter words)

SELECT WORD AS palindromes
FROM WORDS
WHERE WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3
ORDER BY WORD 
LIMIT 10;

-- Results:

palindromes|
-----------+
aaa        |
aba        |
abba       |
acca       |
ada        |
adda       |
addda      |
adinida    |
affa       |
aga        |

-- Give me the 15th palindrome (Excluding single and double letter words) 
-- of words that start with the letter 's'

SELECT WORD
FROM WORDS
WHERE WORD = REVERSE(WORD)
	AND LENGTH(WORD) >= 3
	and word like 's%'
ORDER BY WORD 
LIMIT 1 
OFFSET 14;

-- Results:

word   |
-------+
sooloos|

-- Find the row number for every month of the year and
-- sort them in chronological order

SELECT ROW_NUM AS "Row Number",
	WORD AS "Month"
FROM
	(SELECT WORDS.*,
			ROW_NUMBER() OVER() AS ROW_NUM
		FROM WORDS) AS ROW
WHERE WORD in (
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
ORDER BY TO_DATE(WORD,'Month');

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
