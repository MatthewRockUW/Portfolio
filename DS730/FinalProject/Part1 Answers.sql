use ds700
/*
In Oshkosh, which is more common: days where the temperature was really cold (-10 or lower) at any point 
during the day or days where the temperature was hot (95 or higher) 
at any point during the day?

*/
select weather, count(*) from (
select distinct year, month, day, 'hot' as weather  from oshkoshweather
where temperaturef >= 95 and TemperatureF != -9999
union all
select distinct year, month, day, 'cold' as weather from oshkoshweather
where temperaturef <= -10 and TemperatureF != -9999) answer
group by weather;
;

/*
When I moved from Wisconsin to Iowa for school, the summers and winters seemed similar but the spring and autumn seemed much more tolerable. 
For this problem, we will be using meteorological seasons:
Winter - Dec, Jan, Feb
Spring - Mar, Apr, May
Summer - Jun, Jul, Aug
Fall - Sep, Oct, Nov
Compute the average temperature (sum all temperatures in the time period and divide by the number of readings) for each 
season for Oshkosh and Iowa City. What is the difference in average temperatures for each season for Oshkosh vs Iowa City?
*/

select *, AvgOshkoshTemp - AvgIowaCityTemp as 'OshkoshTemp-IowaCityTemp' from
(
select city, season,  avg(temperaturef) as AvgOshkoshTemp from (
select temperaturef, 'Oshkosh' as City,
CASE WHEN [month] in (12, 1, 2) THEN 'Winter'
WHEN [month] in (3, 4, 5) THEN 'Spring'
WHEN [month] in (6, 7, 8) THEN 'Summer'
ELSE 'Fall' END as Season from oshkoshweather
where TemperatureF != -9999) oshkoshseasons
group by city, season) osh
join 
(
select city, season, avg(temperaturef) as AvgIowaCityTemp from (
select temperaturef, 'IowaCity' as City,
CASE WHEN [month] in (12, 1, 2) THEN 'Winter'
WHEN [month] in (3, 4, 5) THEN 'Spring'
WHEN [month] in (6, 7, 8) THEN 'Summer'
ELSE 'Fall' END as Season from IowaCityWeather
where TemperatureF != -9999) iowacityseasons
group by city, season) iowa on osh.season = iowa.season


/*
For Oshkosh, what 7 day period was the hottest? By hottest I mean, the average temperature of 
all readings from 12:00:00am on day K to 11:59:59pm on day K+6. For example, April 30th, 2006 to May 
6th, 2006 is a 7 day period. December 29, 2005 to January 4, 2006 is a 7 day period. Look at all 7 day 
periods and determine which one is the hottest.
*/

select top 1 startday, dateadd(wk, 1, startday) as LastDayofPeriod, avg(TemperatureF) as AvgTemp from (
select DATEFROMPARTS([year], [month], [day]) as startday, myrange.* from oshkoshweather base
join (

select DATEFROMPARTS([year], [month], [day]) as mydatetime, TemperatureF from oshkoshweather
where TemperatureF != -9999) myrange

on myrange.mydatetime between DATEFROMPARTS([year], [month], [day]) 
and dateadd(dd, 6, DATEFROMPARTS([year], [month], [day]))
) answer
group by startday
order by 3 desc



/*
Solve this problem for Oshkosh only. For each day in the input file (e.g. 
February 1, 2004, May 11, 2010, January 29, 2007), determine the coldest time for 
that day. The coldest time for any given day is defined as the hour(s) that has/have the coldest 
average. For example, a day may have had two readings during the 4am hour, one at 4:15am and one at 4:45am. 
The temperatures may have been 10.5 and 15.3. The average for 4am is 12.9. The 5am hour for that day may have had two readings at 
5:14am and 5:35am and those readings were 11.3 and 11.5. The average for 5am is 11.4. 5am is thus considered colder. 
If multiple hours have the same coldest average temperature on any given day, then those hours that have the coldest average 
are all considered the coldest for that day. Once you have determined the coldest hour for each day, return the hour that has the 
highest frequency. This is not a windowing problem. You only need to consider the 24 “hours” of the day, i.e. 12am, 1am, 2am, etc.
*/

select *  from
(select [year], [month], [day], TheHour, AvgTempInHour, ROW_NUMBER() OVER(ORDER BY AvgTempInHour) as therank
from 
(select [year], [month], [day], DATEPART(hh, timeCST) as [TheHour], avg(TemperatureF) as AvgTempInHour from oshkoshweather
where TemperatureF != -9999
group by [year], [month], [day], DATEPART(hh, timeCST)
) avghours) answer
where therank < 5
order by 5 


/*
Which city had a time period of 24 hours or less that saw the largest temperature difference? Report the city, the 
temperature difference and the minimum amount of time it took to obtain that difference. Do not only consider whole days for this 
problem. The largest temperature difference may have been from 3pm on a Tuesday to 3pm on a Wednesday. The largest temperature difference 
could have been from 11:07am on a Tuesday to 4:03am on a Wednesday. Or the largest difference could have been from 3:06pm on a Wednesday to 7:56pm on 
that same Wednesday. For a concrete example, consider Iowa City on January 1, 2000 at 2:53pm through January 2, 2000 at 2:53pm. The maximum temperature 
in that 24 hour span was 54 and the minimum temperature in that 24 hour span was 36. Therefore, in that 24 hour span, the largest temperature difference was
18 degrees. If this were the final answer, you would output “Iowa City”, “18 degrees” and January 2, 2000 3:53am to January 2, 2000 10:53am.
*/

select 'Oshkosh' as city, DATETIMEFROMPARTS(oshstart.[year], oshstart.[month], oshstart.[day], DATEPART(hh, oshstart.timeCST), DATEPART(mi, oshstart.timeCST), 0, 0) oshstarttime, 
DATETIMEFROMPARTS(oshend.[year], oshend.[month], oshend.[day], DATEPART(hh, oshend.timeCST), DATEPART(mi, oshend.timeCST), 0, 0) oshendtime,

oshstart.TemperatureF, oshend.TemperatureF, ABS(oshstart.TemperatureF - oshend.TemperatureF) as TempShift  from oshkoshweather oshstart
join oshkoshweather oshend on 
DATETIMEFROMPARTS(oshend.[year], oshend.[month], oshend.[day], DATEPART(hh, oshend.timeCST), DATEPART(mi, oshend.timeCST), 0, 0) between
DATETIMEFROMPARTS(oshstart.[year], oshstart.[month], oshstart.[day], DATEPART(hh, oshstart.timeCST), DATEPART(mi, oshstart.timeCST), 0, 0) and
DATEADD(dd, 1, DATETIMEFROMPARTS(oshstart.[year], oshstart.[month], oshstart.[day], DATEPART(hh, oshstart.timeCST), DATEPART(mi, oshstart.timeCST), 0, 0))
where oshstart.temperatureF != -9999 and oshend.temperatureF != -9999 and  oshstart.temperatureF != oshend.temperatureF 

union all

select 'IowaCity' as city, DATETIMEFROMPARTS(iowastart.[year], iowastart.[month], iowastart.[day], DATEPART(hh, iowastart.timeCST), DATEPART(mi, iowastart.timeCST), 0, 0) iowastarttime, 
DATETIMEFROMPARTS(iowaend.[year], iowaend.[month], iowaend.[day], DATEPART(hh, iowaend.timeCST), DATEPART(mi, iowaend.timeCST), 0, 0) iowaendtime,
iowastart.TemperatureF, iowaend.TemperatureF, ABS(iowastart.TemperatureF - iowaend.TemperatureF) as TempShift  from iowacityweather iowastart
join iowacityweather iowaend on 
DATETIMEFROMPARTS(iowaend.[year], iowaend.[month], iowaend.[day], DATEPART(hh, iowaend.timeCST), DATEPART(mi, iowaend.timeCST), 0, 0) between
DATETIMEFROMPARTS(iowastart.[year], iowastart.[month], iowastart.[day], DATEPART(hh, iowastart.timeCST), DATEPART(mi, iowastart.timeCST), 0, 0) and
DATEADD(dd, 1, DATETIMEFROMPARTS(iowastart.[year], iowastart.[month], iowastart.[day], DATEPART(hh, iowastart.timeCST), DATEPART(mi, iowastart.timeCST), 0, 0))
where iowastart.temperatureF != -9999 and iowaend.temperatureF != -9999 and  iowastart.temperatureF != iowaend.temperatureF and iowastart.TimeCST != 'No daily or hourly history data available'
and iowaend.timeCST != 'No daily or hourly history data available'
order by 6 desc


/*
As a runner, I want to know when is the best time and place to run. For each month, provide the hour (e.g. 7am, 5pm, etc) 
and city that is the best time to run. The best time and place to run will be defined as the time where the temperature is as close to 
50 as possible. For each month, you are averaging all temperatures with the same city and same hour and checking how far that average is from 50 degrees. 
If there is a tie, a tiebreaker will be the least windy hour (i.e. the windspeed column) on average. If there is still a tie, both hours and cities are reported.
*/


