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

**Results**

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

**Results**

word_count|
----------|
370103|















