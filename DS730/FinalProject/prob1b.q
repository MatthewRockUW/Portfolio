CREATE EXTERNAL TABLE IF NOT EXISTS OshkoshWeather(Year INT, Month INT, Day INT, TimeCST TIMESTAMP,
TemperatureF INT, DewPointF INT, Humidity INT, SeaLevelPressure float, VisibilityMPH float, WindDirection string, 
windSpeedMPH float, gustspeedmph float, precipitationIn string, events string, conditions string, winddirdegrees int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LOCATION '/user/maria_dev/final/oshkosh/' tblproperties ("skip.header.line.count"="1");

CREATE EXTERNAL TABLE IF NOT EXISTS IowaCityWeather(Year INT, Month INT, Day INT, TimeCST TIMESTAMP,
TemperatureF INT, DewPointF INT, Humidity INT, SeaLevelPressure float, VisibilityMPH float, WindDirection string, 
windSpeedMPH float, gustspeedmph float, precipitationIn string, events string, conditions string, winddirdegrees int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LOCATION '/user/maria_dev/final/IowaCity/' tblproperties ("skip.header.line.count"="1");

select *, (AvgOshkoshTemp - AvgIowaCityTemp) from
(
select city, season,  avg(temperaturef) as AvgOshkoshTemp from (
select temperaturef, 'Oshkosh' as City,
CASE WHEN month in (12, 1, 2) THEN 'Winter'
WHEN month in (3, 4, 5) THEN 'Spring'
WHEN month in (6, 7, 8) THEN 'Summer'
ELSE 'Fall' END as Season from oshkoshweather
where TemperatureF != -9999) oshkoshseasons
group by city, season) osh
join 
(
select city, season, avg(temperaturef) as AvgIowaCityTemp from (
select temperaturef, 'IowaCity' as City,
CASE WHEN month in (12, 1, 2) THEN 'Winter'
WHEN month in (3, 4, 5) THEN 'Spring'
WHEN month in (6, 7, 8) THEN 'Summer'
ELSE 'Fall' END as Season from IowaCityWeather
where TemperatureF != -9999) iowacityseasons
group by city, season) iowa on osh.season = iowa.season;