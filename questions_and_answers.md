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
          1|        26|
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















