ratings = LOAD '/ml-110k/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);

metadata = LOAD '/ml-110k/u.item' USING PigStorage('|')
AS (movieID:int, movieTitle:chararray, releaseDate:chararray, videoRelease:chararray, imdbLink:chararray);

nameLookup = FOREACH metadata GENERATE movieID, movieTitle, ToUnixTime(ToDate(releaseDate,'dd-MMM-yyyy')) AS releaseTime;

ratingsByMovie = GROUP ratings by movieID;

avgRatingsAndCount = FOREACH ratingsByMovie GENERATE group AS movieID, AVG(ratings.rating) AS avgRatings,
COUNT(ratings.rating) AS ratingCount;

badMovies = FILTER avgRatingsAndCount by avgRatings < 2;

badMoviesName = JOIN badMovies BY movieID, nameLookup BY movieID;

finResult = FOREACH badMoviesName GENERATE nameLookup::movieTitle AS movieName , badMovies::avgRatings As avgRatings, badMovies::ratingCount as ratingCount;

resultSort = ORDER finResult BY ratingCount DESC;

dump resultSort;