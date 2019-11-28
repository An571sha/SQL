CREATE TABLE test 
( testnr integer,
  testName VARCHAR(20),
  testBoo  VARCHAR(20),
  CONSTRAINT pk_testnr PRIMARY KEY(testnr));
  
INSERT INTO test
(testnr, testName, testBoo) 
VALUES(100,"ere","ere");
