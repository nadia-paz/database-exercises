USE albums_db;
# 3a. How many rows are in the albums table?
SELECT *
FROM albums;
# 31 rows
/*
SELECT COUNT(id)
FROM albums;
*/

# 3b. How many unique artist names are in the albums table?
SELECT DISTINCT artist
FROM albums;
# 23 artists

# 3c. c. What is the primary key for the albums table?
# id is the PK

# 3d. d. What is the oldest release date for any album in the albums table? 
# What is the most recent release date?
SELECT MIN(release_date) AS OldestDate
FROM albums;
#The oldest release date is 1967

SELECT MAX(release_date) AS OldestDate
FROM albums;
# The newest release date is 2011

SELECT *
FROM albums
WHERE release_date < 1970 OR release_date > 2010;

# 4. Write queries to find the following information:
# a. The name of all albums by Pink Floyd

SELECT name
FROM albums
WHERE artist = 'Pink Floyd';

# b. The year Sgt. Pepper's Lonely Hearts Club Band was released
SELECT release_date
FROM albums
WHERE name='Sgt. Pepper\'s Lonely Hearts Club Band';

# c. The genre for the album Nevermind
SELECT genre
FROM albums
WHERE name = 'Nevermind';

# d. Which albums were released in the 1990s
SELECT name 
FROM albums
WHERE release_date = 1990;

# e. Which albums had less than 20 million certified sales
SELECT name 
FROM albums 
WHERE sales < 20.0;

# f. All the albums with a genre of "Rock". 
# Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?

SELECT name 
FROM albums 
WHERE genre = 'Rock';

# The results don't include "Hard rock" etc because WHERE genre = 'Rock' looks for the exact match
# to include other rock genres we use the following code
SELECT name, genre
FROM albums 
WHERE genre = 'Rock' OR genre LIKE '%rock';