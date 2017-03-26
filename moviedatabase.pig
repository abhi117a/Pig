movie = load '/ml-110k/u.data' AS (userID:int, movieID:int, ratings:int, ratingTime:int);

metadata = load '/ml-110k/u.item' using PigStorage('|') AS (movieID:int, movieTitle:chararray, releaseDate:chararray, imdbLink:chararray);

movieLookup = FOREACH metadata GENERATE movieID,movieTitle;

movieGroup = group movie by ratings;

value  = FOREACH movieGroup generate group as ratings, COUNT(movie.ratings) as countRates;

finResult = order value by countRates DESC;

dump finResult;

