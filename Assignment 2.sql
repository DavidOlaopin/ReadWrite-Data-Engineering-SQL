1
SELECT id, name, MAX(number_of_ratings) AS max_ratings
FROM brewies
GROUP BY 1,2
ORDER BY max_ratings DESC;

2
SELECT AVG(rating) AS average, brewery_type
FROM brewies
GROUP BY 2;

3
SELECT MAX(rating) AS Answer, name, state
FROM brewies
GROUP BY 2,3;

4
SELECT id, name, longitude, latitude,
    ( 3959 * acos( cos( radians(44.0575649) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(-121.3288021) ) + sin( radians(44.0575649) ) * sin( radians( latitude ) ) ) ) AS distance
FROM brewies
ORDER BY distance
LIMIT 1;