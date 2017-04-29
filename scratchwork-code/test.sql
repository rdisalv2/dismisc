

-- some sqlite manipulation code, to be executed using dbExecute
-- just trying out a way to do these things...
SELECT name FROM sqlite_master WHERE type='table';

SELECT * FROM iris LIMIT 10;

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






