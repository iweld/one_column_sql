# One Column SQL
## Questions and Answers
### by jaime.m.shaker@gmail.com

## A. Create a one column table and use that column as the primary key
````sql
COPY WORDS
FROM
'** Path to your **/csv/words.csv'
DELIMITER ',';
````
### Test table by randomly grabbing an awesome word from the table

````sql
SELECT
	WORD AS great_word
FROM
	WORDS
WHERE
	WORD = 'shaker';
````

**Results:**

great_word|
----------|
shaker    |

### How many words are in our table?

````sql
SELECT
	COUNT(*) AS word_count
FROM
	WORDS;
````

**Results:**

word_count|
----------|
370103|

### How many words start with the letter 'j'?

````sql
SELECT
	COUNT(*) AS j_count
FROM
	WORDS
WHERE
	WORD LIKE 'j%';
````

**Results:**

j_count|
-------|
2840|


### How many words are x letters long?

````sql
SELECT
	char_length(word) AS word_length,
	count(*) AS word_count
FROM
	words
WHERE char_length(word) > 1
GROUP BY
	word_length
ORDER BY
	word_length
````

**Results:**

word_length|word_count|
-----------|----------|
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

### How many words contain 'jaime'?

````sql
SELECT
	COUNT(*) as jaime_count
FROM
	WORDS
WHERE
	WORD LIKE '%jaime%';
````

**Results:**

jaime_count|
-----------|
1|

### How many words contain 'shaker'?

````sql
SELECT
	COUNT(*) AS shaker_count
FROM
	WORDS
WHERE
	WORD LIKE '%shaker%';
````

**Results:**

shaker_count|
------------|
13|

### What are those words?

````sql
SELECT
	WORD
FROM
	WORDS
WHERE
	WORD LIKE '%shaker%';
````

**Results:**

word        |
------------|
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

### What is the longest word in this table and how many characters does it contain?

````sql
SELECT 
	WORD AS "Longest Word", 
	length(word) AS "Word Length"
FROM
	WORDS
WHERE
	LENGTH(WORD) =
		(
	SELECT
		MAX(LENGTH(WORD))
	FROM
		WORDS);
````

**Results:**

Longest Word                   |Word Length|
-------------------------------|-----------|
dichlorodiphenyltrichloroethane|         31|

### What is the average length of a word?

````sql
SELECT
	AVG(LENGTH(WORD)) avg_length
FROM
	WORDS;
````

**Results:**

avg_length        |
------------------|
9.4424984396235643|

### That returned a floating point value.  Can you round that number to zero decimal places?

````sql
SELECT
	ROUND(AVG(LENGTH(WORD)))
FROM
	WORDS;
````

**Results:**

rounded_length|
--------------|
9|

### What is the 25th percentile, Median and 90th percentile length?

````sql
SELECT
	PERCENTILE_CONT(0.25) WITHIN GROUP(
	ORDER BY length(word)) AS "25th_percentile",
	PERCENTILE_CONT(0.5) WITHIN GROUP(
	ORDER BY length(word)) AS median_length,
	PERCENTILE_CONT(0.9) WITHIN GROUP(
	ORDER BY length(word)) AS "90th_percentile"
FROM
	words;
````

**Results:**
25th_percentile|median_length|90th_percentile|
---------------|-------------|---------------|
7.0|          9.0|           13.0|


### What is the word count for every letter in the words table? Sort by letter in ascending order.

````sql
SELECT
	SUBSTRING(LOWER(WORD), 1, 1) AS LETTER,
	COUNT(*)
FROM
	WORDS
GROUP BY
	LETTER
ORDER BY
	LETTER;
````

**Results:**
letter|count|
------|-----|
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

### What row number is the word 'shaker' in?

````sql
SELECT
	ROW_NUM AS "Row Number",
	WORD AS "Cool Last Name"
FROM
	(
	SELECT
		WORDS.*,
			ROW_NUMBER() OVER() AS ROW_NUM
	FROM
		WORDS) AS ROW
WHERE
	WORD = 'shaker';
````

**Results:**
Row Number|Cool Last Name|
----------|--------------|
    287206|shaker        |


















