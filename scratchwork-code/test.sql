

-- some sqlite manipulation code, to be executed using dbExecute
-- just trying out a way to do these things...
SELECT name FROM sqlite_master WHERE type='table';

SELECT * FROM iris2melt;

SELECT * FROM iris LIMIT 10;

DROP TABLE IF EXISTS iris2;
CREATE TABLE iris2
  AS SELECT [Sepal.Length] as slength, [Sepal.Width] as swidth, Species, rowid
  FROM iris;

SELECT * from iris2 LIMIT 3;

SELECT * FROM iris2 LIMIT 0;

-- 'melt' in sqlite:
CREATE TABLE temp1 AS
  SELECT rowid, 'slength' AS variable, CAST(slength AS TEXT) AS value
  FROM iris2;
CREATE TABLE temp2 AS
  SELECT rowid, 'swidth' AS variable, CAST(swidth AS TEXT) AS value
  FROM iris2;
CREATE TABLE temp3 AS
  SELECT rowid, 'Species' AS variable, CAST(Species AS TEXT) AS value
  FROM iris2;

INSERT INTO temp1
  SELECT * FROM temp2;
INSERT INTO temp1
  SELECT * FROM temp3;

SELECT * FROM temp1;

-- dear god, in order to "melt" the data you need to do some serious legwork!
-- constructing these statements can be automated in R and passed to dbExecute() however!


-- here's how we might "dcast" the data

SELECT * FROM iris2melt LIMIT 10;

-- follows http://stackoverflow.com/questions/2444708/sqlite-long-to-wide-formats


SELECT DISTINCT variable FROM iris2melt;

DROP TABLE IF EXISTS iris3;
CREATE TABLE iris3
  AS SELECT rowid,
            MAX(CASE WHEN (variable = 'slength') THEN value ELSE NULL END) as slength,
            MAX(CASE WHEN (variable = 'swidth') THEN value ELSE NULL END) as swidth,
            MAX(CASE WHEN (variable = 'Species') THEN value ELSE NULL END) as Species
  FROM iris2melt
  GROUP BY rowid;

SELECT * FROM iris3;

  GROUP BY variable;

SELECT * FROM iris2cast;



/*
SELECT [VAR1], [VAR2], [VarName] = 'Score1', [Value] = [Score1]
FROM [dbo].[UnknownMe]
UNION ALL
SELECT [VAR1], [VAR2], [VarName] = 'Score2', [Value] = [Score2]
FROM [dbo].[UnknownMe]
UNION ALL
SELECT [VAR1], [VAR2], [VarName] = 'Score3', [Value] = [Score3]
FROM [dbo].[UnknownMe]
*/


SELECT * FROM iris3;


-- (CASE WHEN Species = 'setosa' THEN slength ELSE NULL END) AS setosa
/*
SELECT      Country,
            MAX(CASE WHEN Key = 'President' THEN Value ELSE NULL END) President,
            MAX(CASE WHEN Key = 'Currency' THEN Value ELSE NULL END) Currency
FROM        Long
GROUP BY    Country
ORDER BY    Country;
*/

-- get average Sepal.Length by species

DROP TABLE IF EXISTS meansBySpecies;

CREATE TABLE meansBySpecies
          AS SELECT Species, AVG([Sepal.Length]) as avgLength, AVG([Sepal.Width]) as avgWidth
          FROM iris
          GROUP BY Species;

SELECT * FROM meansBySpecies;

SELECT * FROM iris LIMIT 10;

-- convoluted way to get the first Sepal.Length by species:
DROP TABLE IF EXISTS firstSepalLengthBySpecies;
CREATE TABLE firstSepalLengthBySpecies
  AS SELECT Species, MIN(rowid) as minrowid
  FROM iris
  GROUP BY Species;

SELECT * FROM firstSepalLengthBySpecies;

DROP TABLE IF EXISTS step2;
CREATE TABLE step2
  AS SELECT iris.Species, firstSepalLengthBySpecies.minrowid, iris.[Sepal.Length] as FirstSepalLength, iris.rowid
  FROM iris
  INNER JOIN firstSepalLengthBySpecies
  ON iris.Species = firstSepalLengthBySpecies.Species
  AND iris.rowid = firstSepalLengthBySpecies.minrowid;

SELECT * FROM step2;






