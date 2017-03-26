ratings = LOAD '/ml-110k/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);

metadata = LOAD '/ml-110k/u.item' USING PigStorage('|')
AS (movieID:int, movieTitle:chararray, releaseDate:chararray, videoRelease:chararray, imdbLink:chararray);

nameLookup = FOREACH metadata GENERATE movieID, movieTitle, ToUnixTime(ToDate(releaseDate, 'DD-MMM-YYYY')) AS releaseTime;

ratingsByMovie = GROUP ratings BY movieID;

avgRatings = FOREACH ratingsByMovie GENERATE group AS movieID, AVG(ratings.rating) AS avgRating;

fiveStarMovies = FILTER avgRatings BY avgRating > 4.0;

fiveStarData = JOIN fiveStarMovies BY movieID, nameLookup  by movieID;

oldFIveStarMovies = ORDER fiveStarData by nameLookup::releaseTime;

DUMP oldFIveStarMovies;