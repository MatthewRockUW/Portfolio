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

select weather, count(*) from (
select distinct year, month, day, 'hot' as weather  from oshkoshweather
where temperaturef >= 95 and TemperatureF != -9999
union all
select distinct year, month, day, 'cold' as weather from oshkoshweather
where temperaturef <= -10 and TemperatureF != -9999) answer
group by weather;