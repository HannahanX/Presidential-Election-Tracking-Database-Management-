ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY';

DROP TABLE DateOfPoll CASCADE CONSTRAINT;
DROP TABLE PollsResult CASCADE CONSTRAINT;
DROP TABLE PollInstitute CASCADE CONSTRAINT;
DROP TABLE PlaceResult CASCADE CONSTRAINT;
DROP TABLE Place CASCADE CONSTRAINT;
DROP TABLE PresidentialNominee CASCADE CONSTRAINT;
DROP TABLE ResponseRecord CASCADE CONSTRAINT;
DROP TABLE City CASCADE CONSTRAINT;
DROP TABLE State_t CASCADE CONSTRAINT;
DROP TABLE County CASCADE CONSTRAINT;
DROP TABLE Respondent CASCADE CONSTRAINT;
DROP TABLE Age CASCADE CONSTRAINT;
DROP TABLE Education CASCADE CONSTRAINT;
DROP TABLE IncomeRange CASCADE CONSTRAINT;
DROP TABLE Gender CASCADE CONSTRAINT;
DROP TABLE ChoiceOfElection CASCADE CONSTRAINT;
DROP TABLE Citizen CASCADE CONSTRAINT;

--1. Create table DateOfPoll
CREATE TABLE DateOfPoll
(
DateOfPoll DATE,
Event VARCHAR(50),
CONSTRAINT DateOfPol_PK PRIMARY KEY(DateOfPoll)
);

--2. Create table PollInstitute
CREATE TABLE PollInstitute
(
PollInstituteCode INT,
InstituteName VARCHAR(50),
TypeOfInstitute VARCHAR(50),
CONSTRAINT PollInstitute_PK PRIMARY KEY(PollInstituteCode)
);

--3. Create table Place
CREATE TABLE Place
(
PlaceCode VARCHAR(50),
PlaceName VARCHAR(50),
PartyLead VARCHAR(50),
PopulationMillion Number(9,2),
CONSTRAINT Place_PK PRIMARY KEY(PlaceCode)
);

--4. Create table PresidentialNominee
CREATE TABLE PresidentialNominee
(
NomineeCode VARCHAR(50),
Name VARCHAR(50),
Party VARCHAR(50),
Age INT,
BirthPlace VARCHAR(50),
PoliticalExperience VARCHAR(50),
Education VARCHAR(50),
CONSTRAINT PresidentialNominee_PK PRIMARY KEY(NomineeCode)
);

--5. Create table Age
CREATE TABLE Age
(
AgeCode VARCHAR(50), 
AgeSelection VARCHAR(50),--how to store range?
CONSTRAINT Age_PK PRIMARY KEY(AgeCode)
);

--6. Create table Education
CREATE TABLE Education
(
EducationCode VARCHAR(50),
EducationSelection VARCHAR(50),
CONSTRAINT Education_PK PRIMARY KEY(EducationCode)
);

--7. Create table IncomeRange
CREATE TABLE IncomeRange
(
IncomeCode VARCHAR(50),
IncomeSelection VARCHAR(50),
CONSTRAINT IncomeRange_PK PRIMARY KEY(IncomeCode)
);

--8. Create table Gender
CREATE TABLE Gender
(
GenderCode VARCHAR(50),
GenderSelection VARCHAR(50),
CONSTRAINT Gender_PK PRIMARY KEY(GenderCode)
);

--9. Create table ChoiceOfElection
CREATE TABLE ChoiceOfElection
(
NomineeCode VARCHAR(50),
PresidentSelection VARCHAR(50),
CONSTRAINT ChoiceOfElection_PK PRIMARY KEY(NomineeCode),
CONSTRAINT ChoiceOfElection_FK FOREIGN KEY(NomineeCode) REFERENCES PresidentialNominee(NomineeCode)
);

--10. Create table Citizen 
CREATE TABLE Citizen 
(
CitizenID INT,
Name VARCHAR(50),
CONSTRAINT Citizen_PK PRIMARY KEY(CitizenID)
);

--11. Create table PollsResult
CREATE TABLE PollsResult
(
PollsResultCode INT,
PollInstituteCode INT,
NomineeCode VARCHAR(50),
DateOfPoll DATE,
SampleSize INT,
ApprovalRate NUMBER(3),
CONSTRAINT PollsResult_PK PRIMARY KEY(PollsResultCode),
CONSTRAINT PollsResult_FK FOREIGN KEY(PollInstituteCode) REFERENCES PollInstitute(PollInstituteCode),
CONSTRAINT PollsResult_FK1 FOREIGN KEY(NomineeCode) REFERENCES PresidentialNominee(NomineeCode),
CONSTRAINT PollsResult_FK2 FOREIGN KEY(DateOfPoll) REFERENCES DateOfPoll (DateOfPoll)
);

--12. Create table PlaceResult
CREATE TABLE PlaceResult
(
PollsResultCode INT,
PlaceCode VARCHAR(50),
PollInstituteCode INT,
CONSTRAINT PlaceResult_PK PRIMARY KEY(PollsResultCode, PlaceCode, PollInstituteCode),
CONSTRAINT PlaceResult_FK FOREIGN KEY(PollsResultCode) REFERENCES PollsResult(PollsResultCode),
CONSTRAINT PlaceResult_FK1 FOREIGN KEY(PlaceCode) REFERENCES Place (PlaceCode),
CONSTRAINT PlaceResult_FK2 FOREIGN KEY(PollInstituteCode) REFERENCES PollInstitute(PollInstituteCode)
);

--13. Create table State
CREATE TABLE State_t 
(
StateCode VARCHAR(50),
StateName VARCHAR(50),
HistoricalPreference VARCHAR(50),
SwingStateOrNot VARCHAR(50),
GovernorName VARCHAR(50),
GDP NUMBER(9,2),
CONSTRAINT State_PK PRIMARY KEY(StateCode),
CONSTRAINT State_FK FOREIGN KEY(StateCode) REFERENCES Place(PlaceCode)
);

--14. Create table County
CREATE TABLE County
(
CountyCode VARCHAR(50),
StateCode VARCHAR(50),
CountyName VARCHAR(50),
CONSTRAINT County_PK PRIMARY KEY (CountyCode),
CONSTRAINT County_FK FOREIGN KEY (CountyCode) REFERENCES Place(PlaceCode),
CONSTRAINT County_FK2 FOREIGN KEY (StateCode) REFERENCES State_t(StateCode)
);

--15. Create table City
CREATE TABLE City 
(
CityCode VARCHAR(50),
CountyCode VARCHAR(50),
CityName VARCHAR(50),
CONSTRAINT City_PK PRIMARY KEY(CityCode),
CONSTRAINT City_FK FOREIGN KEY(CityCode) REFERENCES Place(PlaceCode),
CONSTRAINT CITY_FK2 FOREIGN KEY(CountyCode) REFERENCES County(CountyCode)
);

--16. Create table Respondent
CREATE TABLE Respondent
(
RespondentID INT,
CitizenID INT,
CityCode VARCHAR(50),
CountyCode VARCHAR(50),
StateCode VARCHAR(50),
AgeCode VARCHAR(50),
GenderCode VARCHAR(50),
EducationCode VARCHAR(50),
IncomeCode VARCHAR(50),
NomineeCode VARCHAR(50),
CONSTRAINT Respondent_PK PRIMARY KEY (RespondentID),
CONSTRAINT Respondent_FK FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID),
CONSTRAINT Respondent_FK2 FOREIGN KEY (CityCode) REFERENCES City(CityCode),
CONSTRAINT Respondent_FK3 FOREIGN KEY (CountyCode) REFERENCES County(CountyCode),
CONSTRAINT Respondent_FK4 FOREIGN KEY (StateCode) REFERENCES  State_t(StateCode),
CONSTRAINT Respondent_FK5 FOREIGN KEY(AgeCode) REFERENCES Age(AgeCode),
CONSTRAINT Respondent_FK6 FOREIGN KEY(GenderCode) REFERENCES Gender(GenderCode),
CONSTRAINT Respondent_FK7 FOREIGN KEY (EducationCode) REFERENCES Education(EducationCode),
CONSTRAINT Respondent_FK8 FOREIGN KEY(IncomeCode) REFERENCES IncomeRange(IncomeCode),
CONSTRAINT Respondent_FK9 FOREIGN KEY(NomineeCode) REFERENCES ChoiceOfElection(NomineeCode)
);

--17. Create table ResponseRecord
CREATE TABLE ResponseRecord
(
ResponseCode INT,
PollInstituteCode INT,
RespondentID INT,
CONSTRAINT ResponseRecord_PK PRIMARY KEY(ResponseCode),
CONSTRAINT ResponseRecord_FK FOREIGN KEY(PollInstituteCode) REFERENCES PollInstitute(PollInstituteCode),
CONSTRAINT ResponseRecord_FK2 FOREIGN KEY(RespondentID) REFERENCES Respondent(RespondentID)
);

INSERT INTO PresidentialNominee VALUES
(
'DT',
'Donald Trump',
'Republic',
73,
'New York City, NY',
'Current president',
'Fordham University, University of Pennsylvania'
);

INSERT INTO PresidentialNominee VALUES
(
'JB',
'Joe Biden',
'Democratic',
77,
'Scranton, Pennsylvania',
'The 47th vice president',
'University of Delaware, Syracuse University'
);
INSERT INTO DateOfPoll VALUES('04-09-2020','Sanders announced his withdrawal from the race');
INSERT INTO DateOfPoll VALUES('04-16-2020','Trump announces to suspend U.S.funding of WHO.');
INSERT INTO DateOfPoll VALUES('04-17-2020','Texas announced to be the first state to reopen');
INSERT INTO DateOfPoll VALUES('04-21-2020','Oil prices fell into negative values');
INSERT INTO DateOfPoll VALUES('04-26-2020','Trump signed a $483 billion to rescue business.');
INSERT INTO DateOfPoll VALUES('04-30-2020',NULL);
INSERT INTO DateOfPoll VALUES('05-06-2020',NULL);

INSERT INTO PollInstitute VALUES(74428,'Gallup','Business');
INSERT INTO PollInstitute VALUES(50188,'Elway Research','Public Organization');
INSERT INTO PollInstitute VALUES(60333,'The Harris Poll','Business');
INSERT INTO PollInstitute VALUES(77712,'NORC at the University of Chicago','Personal Organization');
INSERT INTO PollInstitute VALUES(72636,'Public Policy Polling (PPP)','Public Organization');
INSERT INTO PollInstitute VALUES(25554,'Quinnipiac University Poll','Education');
INSERT INTO PollInstitute VALUES(65928,'Rasmussen Reports','Business');
INSERT INTO PollInstitute VALUES(21864,'Research 2000','Business');

INSERT INTO Place VALUES('CA','California','Democrat',39.51);
INSERT INTO Place VALUES('NV','Nevada','Democrat',3.08);
INSERT INTO Place VALUES('TX','Texas','Republic',29);
INSERT INTO Place VALUES('WA','Washington','Democrat',7.615);
INSERT INTO Place VALUES('UT','Utah','Republic',3.206);
INSERT INTO Place VALUES('TN','Tennessee','Republic',6.829);
INSERT INTO Place VALUES('CT','Connecticut','Democrat',3.565);
INSERT INTO Place VALUES('NY','New York','Democrat',19.45);
INSERT INTO Place VALUES('FL','Florida','TBD',21.48);
INSERT INTO Place VALUES('LAC','Los Angeles','Democrat',1.245);
INSERT INTO Place VALUES('CLC','Clark','Democrat',2.267);
INSERT INTO Place VALUES('HAC','Harris','Republic',4.713);
INSERT INTO Place VALUES('KIC','King County','Democrat',2.253);
INSERT INTO Place VALUES('SHC','Shelby', 'Repbulic',0.937);
INSERT INTO Place VALUES('FAC','Fairfield',	'Democrat',0.943);
INSERT INTO Place VALUES('MIC','Miami-Dade','Democrat',2.717);
INSERT INTO Place VALUES('LAVCC','Las Vegas','Democrat',0.662);
INSERT INTO Place VALUES('WADCC','Washington DC','Democrat',0.711);
INSERT INTO Place VALUES('HOUCC','Houston',	'Democrat',0.7);
INSERT INTO Place VALUES('SEACC','Seattle',	'Democrat',0.783);
INSERT INTO Place VALUES('MEMCC','Memphis',	'Republic',0.647);
INSERT INTO Place VALUES('STMCC','Stamford','Democrat',0.131);

INSERT INTO Education VALUES('A','Associate degree');
INSERT INTO Education VALUES('B','Bachelor degree');
INSERT INTO Education VALUES('M','Master degree');
INSERT INTO Education VALUES('D','Doctoral degree');

INSERT INTO Age VALUES('Y','19-25');
INSERT INTO Age VALUES('A','26-34');
INSERT INTO Age VALUES('P','35-54');
INSERT INTO Age VALUES('M','55-64');
INSERT INTO Age VALUES('E','65+');

INSERT INTO Gender VALUES('F','Female');
INSERT INTO Gender VALUES('M','Male');

INSERT INTO ChoiceOfElection VALUES('DT','Donald Trump');
INSERT INTO ChoiceOfElection VALUES('JB','Joe Biden');

INSERT INTO IncomeRange VALUES('H','Above $188,000');
INSERT INTO IncomeRange VALUES('UM','$126,000 - $188,000');
INSERT INTO IncomeRange VALUES('M','$42,000 - $126,000');
INSERT INTO IncomeRange VALUES('LM','$31,000 - $42,000');
INSERT INTO IncomeRange VALUES('L','Under $31,000');

INSERT INTO Citizen VALUES(28,'Hannah');
INSERT INTO Citizen VALUES(185,'Gianna');
INSERT INTO Citizen VALUES(180,'Jennie');
INSERT INTO Citizen VALUES(14,'William');
INSERT INTO Citizen VALUES(123,'Nicole');
INSERT INTO Citizen VALUES(131,'Oliver');
INSERT INTO Citizen VALUES(101,'Jessie');
INSERT INTO Citizen VALUES(151,'Luca');
INSERT INTO Citizen VALUES(194,'Adam');
INSERT INTO Citizen VALUES(37,'Thomas');
INSERT INTO Citizen VALUES(23,'Mary');

INSERT INTO PollsResult VALUES(2020820, 74428,'DT','04-09-2020',10000,'34');
INSERT INTO PollsResult VALUES(2020831,	50188,'JB','04-16-2020',30000,'51');
INSERT INTO PollsResult VALUES(2020798,	74428,'DT','04-17-2020',400,'42');
INSERT INTO PollsResult VALUES(2020940,	60333,'JB','04-17-2020',50000,'50');
INSERT INTO PollsResult VALUES(2020639,	74428,'JB','04-21-2020',4000,'70');
INSERT INTO PollsResult VALUES(2020479,	77712,'DT','04-21-2020',50000,'62');
INSERT INTO PollsResult VALUES(2020865,	21864,'DT','04-21-2020',200000,'57');
INSERT INTO PollsResult VALUES(2020387, 72636,'JB','04-26-2020',40000,'52');
INSERT INTO PollsResult VALUES(2020182,	25554,'DT','04-30-2020',2000,'70');
INSERT INTO PollsResult VALUES(2020134,	65928,'JB','05-06-2020',900,'35');

INSERT INTO PlaceResult VALUES(2020820,	'LAC',74428);
INSERT INTO PlaceResult VALUES(2020798,	'STMCC',74428);
INSERT INTO PlaceResult VALUES(2020639,	'WADCC',74428);
INSERT INTO PlaceResult VALUES(2020831,	'LAVCC',50188);
INSERT INTO PlaceResult VALUES(2020940,	'CT',60333);
INSERT INTO PlaceResult VALUES(2020479,	'HOUCC',77712);
INSERT INTO PlaceResult VALUES(2020387,	'SEACC',72636);
INSERT INTO PlaceResult VALUES(2020182,	'UT',25554);
INSERT INTO PlaceResult VALUES(2020134,	'MEMCC',65928);
INSERT INTO PlaceResult VALUES(2020865,	'MIC',21864);

INSERT INTO State_t VALUES('CA','California','Democrat','Gavin Newsom','No',2813.7);
INSERT INTO State_t VALUES('NV','Nevada','Democrat','Steve Sisolak','No',155.53);
INSERT INTO State_t VALUES('TX','Texas','Republic','Greg Abbott','No',1812.11);
INSERT INTO State_t VALUES('WA','Washington','Democrat','Jay Inslee','No',537.64);
INSERT INTO State_t VALUES('UT','Utah','Republic','Gary Herbert','No',166.82);
INSERT INTO State_t VALUES('TN','Tennessee','Republic','Bill Lee','No',333.31);
INSERT INTO State_t VALUES('CT','Connecticut','Democrat','Ned Lamont','No',250.05);
INSERT INTO State_t VALUES('FL','Florida','Democrat','Ron DeSantis','Yes',959.43);

INSERT INTO County VALUES('LAC','CA','Los Angeles');
INSERT INTO County VALUES('CLC','NV','Clark');
INSERT INTO County VALUES('HAC','TX','Harris');
INSERT INTO County VALUES('KIC','WA','King County');
INSERT INTO County VALUES('SHC','TN','Shelby');
INSERT INTO County VALUES('FAC','CT','Fairfield');
INSERT INTO County VALUES('MIC','FL','Miami-Dade');

INSERT INTO City VALUES('LAVCC','CLC','Las Vegas');
INSERT INTO City VALUES('WADCC',NULL,'Washington DC');
INSERT INTO City VALUES('HOUCC','HAC','Houston');
INSERT INTO City VALUES('SEACC','KIC','Seattle');
INSERT INTO City VALUES('MEMCC','SHC','Memphis');
INSERT INTO City VALUES('STMCC','FAC','Stamford');

INSERT INTO Respondent VALUES(10000,28,	NULL,'LAC', NULL,'M','F','M','H','DT');
INSERT INTO Respondent VALUES(10001,185,'LAVCC', NULL, NULL,'P','F','D','UM','DT');
INSERT INTO Respondent VALUES(10002,180,'WADCC', NULL, NULL,'Y','F','M','M','JB');
INSERT INTO Respondent VALUES(10003,14,	'HOUCC', NULL, NULL,'M','M','A','H','JB');
INSERT INTO Respondent VALUES(10004,123,'SEACC', NULL, NULL,'Y','F','A','UM','JB');
INSERT INTO Respondent VALUES(10005,131, NULL, NULL,'UT','A','M','B','LM','DT');
INSERT INTO Respondent VALUES(10006,101,'MEMCC', NULL,NULL,'P','F','B','LM','JB');
INSERT INTO Respondent VALUES(10007,151,'STMCC', NULL,NULL,'E','M','D','L','DT');
INSERT INTO Respondent VALUES(10008,194,'HOUCC', NULL,NULL,'A','M','D','UM','DT');
INSERT INTO Respondent VALUES(10009,37,	NULL,'MIC',NULL,'Y','M','A','H','DT');
INSERT INTO Respondent VALUES(10010,23,'LAVCC', NULL, NULL,'E','F','M',	'L','DT');
INSERT INTO Respondent VALUES(10011,151, NULL, NULL,'CT','E','M','D','L','DT');

INSERT INTO ResponseRecord VALUES(1,74428,	10000 );
INSERT INTO ResponseRecord VALUES(2,50188,	10001 );
INSERT INTO ResponseRecord VALUES(3,74428,	10002 );
INSERT INTO ResponseRecord VALUES(4,77712,	10003 );
INSERT INTO ResponseRecord VALUES(5,72636,	10004 );
INSERT INTO ResponseRecord VALUES(6,25554,	10005 );
INSERT INTO ResponseRecord VALUES(7,65928,	10006 );
INSERT INTO ResponseRecord VALUES(8,74428,	10007 );
INSERT INTO ResponseRecord VALUES(9,77712,	10008 );
INSERT INTO ResponseRecord VALUES(10,21864,	10009 );
INSERT INTO ResponseRecord VALUES(11,50188,	10010 );
INSERT INTO ResponseRecord VALUES(12,60333,	10011 );


--Single table
--1. People of which education level vote most? (single)
SELECT COUNT(citizenID),EducationCode
FROM respondent
GROUP BY EducationCode
ORDER BY COUNT(citizenID) DESC;

--2. How many unique respondent we have?(single) 
SELECT COUNT(DISTINCT CitizenID) FROM Respondent;

--3. Define each income level (single)
 SELECT IncomeCode, IncomeSelection,
 (CASE IncomeSelection 
   WHEN 'Above $188,000' THEN 'High Paid'
   WHEN '$126,000 - $188,000' THEN 'Upper Medium Paid'
   WHEN '$42,000 - $126,000' THEN 'Medium Paid'
   WHEN '$31,000 - $42,000' THEN 'Lower Medium Paid'
   WHEN 'Under $31,000' THEN 'Low Paid'
   END) "IncomeGrade"
FROM IncomeRange;

--4. comparing high income vs low income (single)
DESCRIBE respondent;
SELECT t.NOMINEECODE, t.HIGHLOW, count(t.citizenID)
FROM 
(SELECT citizenID, INCOMECODE, NOMINEECODE,
(CASE WHEN INCOMECODE = 'H' THEN 'HIGH'
WHEN INCOMECODE = 'UM' THEN 'HIGH'
WHEN INCOMECODE = 'M' THEN 'HIGH'
WHEN INCOMECODE = 'LM' THEN 'LOW'
WHEN INCOMECODE = 'L' THEN 'LOW'END)"HIGHLOW"
FROM respondent) t
GROUP BY t.NOMINEECODE, t.HIGHLOW;

--Multiple table
--1. Which city has a highest approval rate of Trump and how much?(multiple join)
SELECT X.NomineeCode, X.MaxApproval,w.PlaceCode
FROM(
SELECT t.NOMINEECODE,MAX(t.APPROVALRATE) AS MaxApproval
FROM 
((SELECT pr.PollsResultCode,pr.placecode,polr.NomineeCode,polr.approvalrate
FROM PlaceResult pr LEFT OUTER JOIN POLLSRESULT polr
ON pr.POLLSRESULTCODE = Polr.POLLSRESULTCODE)t RIGHT OUTER JOIN City c
ON t.placecode = c.citycode)
GROUP BY t.NOMINEECODE
HAVING NomineeCode='DT')X LEFT OUTER JOIN 
(SELECT pr.PollsResultCode,pr.placecode,polr.NomineeCode,polr.approvalrate
FROM PlaceResult pr LEFT OUTER JOIN POLLSRESULT polr
ON pr.POLLSRESULTCODE = Polr.POLLSRESULTCODE)w
ON X.MaxApproval = w.approvalrate;

--2. Order the poll institutes with their max sample size from largest to smallest and show their max sample sizes. (multiple join)
SELECT pls.institutename,o.maxsample
FROM
(SELECT c.institutename,MAX(c.samplesize) as maxsample
FROM
(SELECT*
FROM pollinstitute pls RIGHT OUTER JOIN pollsresult polr
ON pls.POLLINSTITUTECODE = polr.POLLINSTITUTECODE)c 
GROUP BY c.institutename
order BY maxsample DESC)o RIGHT OUTER JOIN pollinstitute pls
ON o.institutename = pls.INSTITUTENAME;

--3. How are the GDP of the states that have the a higher approval rate(>50%) of Trump? (multiple join)
SELECT t.nomineecode,t.approvalrate, st.statename,st.GDP
FROM
(SELECT pr.PollsResultCode,pr.placecode,polr.NomineeCode,polr.approvalrate
FROM PlaceResult pr LEFT OUTER JOIN POLLSRESULT polr
ON pr.POLLSRESULTCODE = Polr.POLLSRESULTCODE
WHERE polr.NOMINEECODE ='DT')t INNER JOIN State_t st
ON t.placecode = st.statecode;

--4. Which presidential Nominee gain a higher approval rate in Washington.DC?(multiple)
Select pr.PollsResultCode, pr.NomineeCode, pr.ApprovalRate
FROM 
    ( SELECT c.CityCode, c.CityName,pr.PollsResultCode
      FROM City c LEFT OUTER JOIN PlaceResult pr
      ON pr.PlaceCode = c.CityCode) a 
     LEFT OUTER JOIN PollsResult pr
ON pr.PollsResultCode = a.pollsresultcode
WHERE a.cityname ='Washington DC';

--5. How many respondents are from connecticut?(multiple)
SELECT
(SELECT COUNT (RespondentID) -- count the city poll in CT
FROM(
     SELECT r.RespondentID,d.statename
     FROM Respondent r LEFT JOIN 
       (SELECT s.StateCode, s.StateName,b.countycode,b.citycode
        FROM State_t s LEFT OUTER JOIN
          (SELECT c.CityCode,c.CityName,cy.CountyCode,cy.CountyName,cy.statecode
           FROM County cy LEFT OUTER JOIN City c
           ON c.countycode=cy.countycode) b 
        ON s.statecode=b.statecode) d
   ON r.citycode=d.citycode
WHERE d.statename = 'Connecticut'))
+
(SELECT COUNT?RespondentID) --count the CT poll
FROM(
     SELECT r.RespondentID, r.StateCode,s.StateName
     FROM Respondent r LEFT OUTER JOIN State_t s
     ON r.StateCode=s.StateCode)
WHERE StateName = 'Connecticut')
+
(SELECT COUNT(RespondentID) --counr the county poll in CT
FROM(
  SELECT r.RespondentID?r.CountyCode,r.StateCode,e.StateName
  FROM Respondent r LEFT OUTER JOIN 
     (SELECT s.StateCode, s.StateName,b.countycode,b.citycode
      FROM State_t s LEFT OUTER JOIN
       (SELECT c.CityCode,c.CityName,cy.CountyCode,cy.CountyName,cy.statecode
        FROM County cy LEFT OUTER JOIN City c
        ON c.countycode=cy.countycode) b 
      ON s.statecode=b.statecode) e
  ON e.countycode=r.countycode
  WHERE e.statecode='Connecticut'))
AS CT_Respondent
FROM dual;

--6. Which state does Huston poll result belong to?(multiple)
SELECT s.StateName,b.cityname
     FROM State_t s LEFT OUTER JOIN
       (SELECT c.CityCode,c.CityName,cy.CountyCode,cy.CountyName,cy.statecode
        FROM County cy LEFT OUTER JOIN City c
        ON c.countycode=cy.countycode) b 
ON s.statecode=b.statecode
WHERE CityName = 'Houston';

--7. comparing Young VS OLD generation (multiple join)
SELECT  t.NOMINEECODE, t.GENERATION, COUNT(t.citizenID)
FROM
(SELECT citizenID, NOMINEECODE, AGESELECTION, 
(CASE WHEN AGESELECTION = '19-25' THEN 'YOUNG'
WHEN AGESELECTION = '26-34' THEN 'YOUNG'
WHEN AGESELECTION = '35-54' THEN 'OLD'
WHEN AGESELECTION = '55-64' THEN 'OLD'
WHEN AGESELECTION = '65+' THEN 'OLD'END) "GENERATION"
FROM respondent r 
LEFT OUTER JOIN Age a
ON r.AGECODE = a.AGECODE) t
GROUP BY t.GENERATION, t.NOMINEECODE;

--8. Calculate the sample size * rate and get real number of Nominee (multiple join)
SELECT T.NOMINEECODE, SUM(T.TOTALSIZE)
FROM
(SELECT INSTITUTENAME, SAMPLESIZE, APPROVALRATE, NOMINEECODE, SAMPLESIZE*APPROVALRATE/100 as totalsize
FROM PollsResult p
LEFT OUTER JOIN PollInstitute pi
ON p.POLLINSTITUTECODE = pi.POLLINSTITUTECODE) T
GROUP BY T.NOMINEECODE;

--9. Create the table that respondent choose the nominee depends on the date (multiple join)
SELECT RESPONDENTID, NOMINEECODE, DATEOFPOLL
FROM PollsResult P
LEFT OUTER JOIN ResponseRecord rr
ON P.POLLINSTITUTECODE = rr.POLLINSTITUTECODE
ORDER BY RESPONDENTID, DATEOFPOLL;

--10. How many times did each respondent vote for the presidential nominees?
SELECT Respondent.RespondentID, Respondent.CitizenID, ChoiceOfElection.NomineeCode, ChoiceOfElection.PresidentSelection,
CASE
    WHEN CitizenID IN (SELECT CitizenID
                        FROM Respondent
                        GROUP BY (CitizenID)
                        HAVING COUNT(CitizenID) >= 2)
        THEN 'This respondent has voted multiple times.'
    ELSE 'This respondent has voted once.'
END
FROM Respondent JOIN ChoiceOfElection
ON Respondent.NomineeCode = ChoiceOfElection.NomineeCode;

--11. How many votes did both presidential nominees receive in the state of Utah?
SELECT ChoiceOfElection.NomineeCode, ChoiceOfElection.PresidentSelection, 
       State_t.StateName, COUNT(Respondent.RespondentID)
FROM Respondent
    JOIN State_t ON Respondent.StateCode = State_t.StateCode
    JOIN ChoiceOfElection ON Respondent.NomineeCode = ChoiceOfElection.NomineeCode
WHERE State_t.StateName = 'Utah'
GROUP BY ChoiceOfElection.NomineeCode, ChoiceOfElection.PresidentSelection, State_t.StateName;

--12. Did more females vote for Joe Biden or Donald Trump?
SELECT ChoiceOfElection.PresidentSelection, Gender.GenderCode, Gender.GenderSelection, COUNT(Gender.GenderSelection)
FROM Respondent
    JOIN ChoiceOfElection ON Respondent.NomineeCode = ChoiceOfElection.NomineeCode
    JOIN Gender ON Respondent.GenderCode = Gender.GenderCode
WHERE Gender.GenderSelection = 'Female'
GROUP BY ChoiceOfElection.PresidentSelection, Gender.GenderCode, Gender.GenderSelection;

--13. What percentage of votes came out of Connecticut compared to the entire country?
SELECT State_t.StateCode, State_t.StateName, 
       count(Respondent.RespondentID) AS NumberOfRespondent, 
       100*COUNT(Respondent.RespondentID)/(SELECT COUNT(*) FROM Respondent) AS PercentageOfVote
FROM State_t
    JOIN Respondent ON State_t.StateCode = Respondent.StateCode
WHERE State_t.StateName = 'Connecticut'
GROUP BY State_t.StateCode, State_t.StateName;

--PL/SQL
--1. After the day when Sanders announced to quit the election, how does the poll result look like? (PL/SQL)
SET SERVEROUTPUT ON;
DECLARE
CURSOR c1 IS SELECT p.NOMINEECODE
FROM POLLSRESULT p, DATEOFPOLL d
WHERE p.DATEOFPOLL = d.DATEOFPOLL
AND d.EVENT LIKE '%Sanders%';
nom POLLSRESULT.NOMINEECODE%type;
BEGIN
OPEN c1;
LOOP
FETCH c1 INTO nom;
EXIT WHEN c1%NOTFOUND;
dbms_output.put_line(nom);
END LOOP;
CLOSE c1;
END;

--2. What is the sample size of pollsresult 2020940? (PL/SQL) 
DECLARE
prcode POLLSRESULT.POLLSRESULTCODE%TYPE;
samsz POLLSRESULT.SAMPLESIZE%TYPE;
BEGIN
SELECT pollsresultcode,samplesize
INTO prcode, samsz
FROM POLLSRESULT
WHERE POLLSRESULTCODE = 2020940;
DBMS_OUTPUT.PUT_LINE ('The sample size of the polling reult '||prcode|| ' is '
||samsz||'.' );
END;

--3. PL/SQL A new poll institute 'CNN' starts to conduct polls, 
--please add this in the PollInstitute entity.
DECLARE
pollinstitutec pollinstitute%ROWTYPE;
BEGIN
pollinstitutec.pollinstitutecode := 74498;
pollinstitutec.institutename := 'CNN';
pollinstitutec.typeofinstitute := 'Media';
INSERT INTO PollInstitute VALUES pollinstitutec;
END;
SELECT * FROM PollInstitute;

--4. PL/SQL print out the name of respondent who vote Trump.
DESCRIBE Citizen;
DESCRIBE respondent;
DECLARE
    CURSOR DT IS SELECT NAME
    FROM Citizen c, respondent r
    WHERE c.CITIZENID = r.CITIZENID 
    AND NOMINEECODE = 'DT';
    fname Citizen.NAME%type;
BEGIN
    OPEN DT;
    LOOP
      FETCH DT INTO fname;
      EXIT WHEN DT%NOTFOUND;
      dbms_output.put_line(fname || ' ' || 'votes Donald Trump.');
    END LOOP;
    CLOSE DT;
END;

--5. Can you print out the historical preference of Connecticut?
DECLARE
sn state_t.statename%TYPE;
hp state_t.historicalpreference%TYPE;
BEGIN
   SELECT statename,historicalpreference
   INTO sn,hp
   FROM state_t
   WHERE statename='Connecticut';
   DBMS_OUTPUT.PUT_LINE(sn || ' prefers ' ||hp);
END;


