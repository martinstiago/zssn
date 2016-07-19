ZSSN (Zombie Survival Social Network)
================

Created to solve [this](https://gist.github.com/akitaonrails/711b5553533d1a14364907bbcdbee677#file-backend-md) challenge.

## How to install

Before the installation, make sure to have the Ruby 2.3.1 installed. You can find how to do it [here](https://gorails.com/setup/ubuntu/14.04#ruby).
After that, for the application install, download it and run the following commands:

```
gem install bundle
bundle install
rails db:create
rails db:migrate
```

Then, run `rails s`, and it will be available at http://localhost:3000

-------------------------------------------------------------------------

## API Documentation

### POST /survivors

```
POST /survivors
Content-Type: "application/json"

{
  "name": 'Negan',
  "age": 47,
  "gender": 'M',
  "latitude": 38.8951100,
  "longitude": -77.0363700,
  "resources": [
    {
      "type": 'Water',
      "amount": 3
    },
    {
      "type": 'Food',
      "amount": 5
    },
    {
      "type": 'Medication',
      "amount": 2
    },
    {
      "type": 'Ammunition',
      "amount": 66
    }
  ]
}
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode


##### Returns:

```
201 Created
Content-Type: "application/json"

{
  "id": 1234
  "name": 'Negan',
  "age": 47,
  "gender": 'M',
  "latitude": 38.8951100,
  "longitude": -77.0363700,
  "resources": [
    {
      "type": 'Water',
      "amount": 3
    },
    {
      "type": 'Food',
      "amount": 5
    },
    {
      "type": 'Medication',
      "amount": 2
    },
    {
      "type": 'Ammunition',
      "amount": 66
    }
  ]
}
```

##### Errors:

Error | Description
----- | ------------
422   | The request was sent with invalid params


### GET /survivor/:id

```
GET /:survivor/:id
Content-Type: "application/json"
```

Attribute | Description
----------| -----------
**id**    | Survivor id

#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "id": 1234
  "name": 'Negan',
  "age": 47,
  "gender": 'M',
  "latitude": 38.8951100,
  "longitude": -77.0363700,
  "resources": [
    {
      "type": 'Water',
      "amount": 3
    },
    {
      "type": 'Food',
      "amount": 5
    },
    {
      "type": 'Medication',
      "amount": 2
    },
    {
      "type": 'Ammunition',
      "amount": 66
    }
  ]
}
```

##### Errors

Error | Description
----- | ------------
404   | The Survivor cannot be found in the system


### PUT /survivor/:id

```
PUT /:survivor/:id
Content-Type: "application/json"
```
Attribute | Description
----------| -----------
**id**    | Survivor id

#### Returns

```
200 Ok
Content-Type: "application/json"
```

##### Errors

Error | Description
----- | ------------
404   | The Survivor cannot be found in the system

### POST /survivor/:id/report_infection

```
POST /:survivor/:id/report_infection
Content-Type: "application/json"
```
Attribute | Description
----------| -----------
**id**    | Survivor id

#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "message": "Survivor reported as infected (n < 3) times"
}
```

```
200 Ok
Content-Type: "application/json"

{
  "message": "Infected survivor!!! Reported as infected (n >= 3) times. Kill him!!!!"
}
```

##### Errors

Error | Description
----- | ------------
404   | The Survivor cannot be found in the system

### POST /trade

```
POST /trade
Content-Type: "application/json"

{
  "trade": {
    "survivor_1": {
      "id": 1234,
      "resources": [
        {
          "type": 'Water',
          "amount": 1
        },
        {
          "type": 'Food',
          "amount": 2
        }
      ]
    },
    "survivor_2": {
      "id": 4321,
      "resources": [
        {
          "type": 'Medication',
          "amount": 2
        },
        {
          "type": 'Ammunition',
          "amount": 6
        }
      ]
    }
  }
}
```
#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "message": "Resources where traded successfully"
}
```

##### Errors

Error | Description
----- | ------------
404   | One of the Survivor ids cannot be found in the system
409   | One of the Survivor is infected
422   | Invalid resources for a given Survivor
422   | Invalid amount of points between both trade parts

### GET /reports/infected
Percentage of infected survivors.

```
GET /reports/infected
Content-Type: "application/json"
```

#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "percentage": "35%"
}
```

### GET /reports/non-infected
Percentage of non-infected survivors.

```
GET /reports/not-infected
Content-Type: "application/json"
```

#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "percentage": "65%"
}
```

### GET /reports/resources
Average amount of each kind of resource by survivor.

```
GET /reports/resources
Content-Type: "application/json"
```

#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "water": 2.6,
  "food": 4.2,
  "medication": 3.0,
  "ammunition": 8.9
}
```

### GET /reports/points
Points lost because of infected survivor.

```
GET /reports/points
Content-Type: "application/json"
```

#### Returns

```
200 Ok
Content-Type: "application/json"

{
  "lostPoints": 27
}
```
