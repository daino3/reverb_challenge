Reverb Technical Challenge with Grape
==========================================================

To set up:
```
$bundle
$rackup -p <desired port>
```

The app responds to the following routes:
```
GET /people/all
GET /people/gender
GET /people/birthdate
GET /people/name
POST /people(.json)
```

You can create a person record which saves to 'data_files/csv.txt' by running a curl command like so:
```
curl -d '{"first_name": "daBrandon", "last_name": "jacobs", "gender": "female", "favorite_color": "green", "date_of_birth": "1985-05-20"}' 'http://localhost:3000/people' -H Content-Type:application/json -v
```