# Active911 API Gem

[Active911 Developer API](https://active911.atlassian.net/wiki/spaces/AED/pages/240123959/Advanced+Features) 
allows developers to access agency's alerts, response, and map data. 
Documentation for the [Active 911 API is available](https://active911.atlassian.net/wiki/spaces/AED/pages/1866825767/Accessing+the+API).

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Installation](#installation)
  - [Usage](#usage)
    - [Environmental Variables](#environmental-variables)
    - [Returned Data Format](#returned-data-format)
  - [API Resources](#api-resources)
    - [Agency](#agency)
    - [Alerts](#alerts)
    - [Alert](#alert)
    - [Map Locations](#map-locations)
    - [Map Location](#map-location)
    - [Map Resources](#map-resources)
  - [Limitations](#limitations)
  - [Development](#development)
  - [Tests](#tests)
  - [License](#license)
  - [Security](#security)
  - [Versions](#versions)
  - [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Installation

To use A911 in the Rails application or in a gem, add this line to your 
application's Gemfile:

```
gem "active911_api", github: "https://github.com/rocky-mountain-rescue/active911_api"
```

Afterwards update your Gemfile by executing:

```
$ bundle
```

You can also manually install it yourself via:

```
$ gem install active911_api
```

## Usage

To access the Active911 API, you'll need to create/instantiate an 
`Active911::API::Client` passing in the `api_refresh_key` your refresh API key.

```ruby
client = Active911::API::Client.new(api_refresh_key: ENV.fetch("ACTIVE911_API_REFRESH_KEY"))
```

The refresh key can then exchanged for the access keys using the 
`api_key_from_refesh_key` method call:

```ruby
client.api_key_from_refresh_key
```

The client then gives you access to each of the resources:

* agency
* alert(s)
* device
* location
* resource for location

### Environmental Variables

Active911::API::Client can read the following environmental variables:

```bash
ACTIVE911_BASE_URL=https://access.active911.com/interface/open_api/api/
```

In addition, the constructor for the client requires `api_refresh_key` 
argument, which, as a convention, can be read from the environment from a 
defined variable of `ACTIVE911_API_REFRESH_KEY`. 

### Returned Data Format

Note that the message returned by the API is of the following format:

```json
{
 "result": "(success|error)",
 "message": "(error message|returned object)"
}

```

The object returned from the Active911 API is recursively encoded via 
OpenStruct. The original json encoding is also available via `#to_json` 
method call.

For example, a successful call to agency: `client.agency.show` will results an 
object:

```ruby
client = Active911::API::Client.new(api_refresh_key: ENV.fetch("ACTIVE911_API_REFRESH_KEY"))
# => #<Active911::API::Client api_refresh_key="abcdef123456789...
client.api_key_from_refresh_key
agency_result = client.agency.show
# => #<Active911::API::Models::Agency result="success", message=#<OpenStruct agency=#<OpenStruct id="123", name="Rescue Group"...
agency_result.result
# => "success"
agency_result.message
# => #<OpenStruct agency=#<OpenStruct id="123", name="Rescue Group"
agency_result.message.agency.name
# => "Rescue Group" 
agency_result.message.agency.address
# => "123 Main St" 
```

The original JSON object is available via `#to_json` method call on the result

```ruby
jj agency_result.to_json
#{
#"result": "success",
#  "message": {
#    "agency": {
#      "id": "123",
#      "name": "Rescue Group",
#      "address": "123 Main St",
#      "city": "Boulder",
#      "state": "US-CO",
#      "zip": "80301",
#      "latitude": "40",
#      "longitude": "-105",
#      "devices": [
#        {
#          "id": "123",
#          "uri": "https://access.active911.com/interface/open_api/api/devices/123"
```

Some implementation considerations:

* Please note that ids returned in the API calls are strings, not
  integers.

* Active911 gem attempts to hide the idiosyncratic nature of the Active911
  API, where the data returned is HTML-encoded instead of JSON, despite the
  client sending `Accept: application/json` header.

## API Resources

### Agency

To obtain information about all the agency normally available via the
Active 911 API URL `https://access.active911.com/interface/open_api/api/`,
issue the following call:

```ruby
client.agency.show
```

Resulting data is an OpenStruct and JSON coded object corresponding to the 
returned API object describing the agency and agency associated devices.

```json
{
 "agency" : {
  "id": "(Agency id number)",
  "name": "(Name of the agency)",
  "address": "(Street address of the agency)",
  "city": "(City agency is located in)",
  "state": "(State agency is location in)",
  "latitude": "(Latitude of agency's location)",
  "longitude": "(Longitude of agency's location)",
  "devices": 
  [
    {
      "id": "(Device id number)",
      "uri": "(API URI to access the device data)"
    }
  ]
 }
}
```

### Alerts

To obtain information about all the agency locations normally available via the
Active 911 API URL `https://access.active911.com/interface/open_api/api/alerts`,
issue the following call:

```ruby
client.alerts.index
```

By default, 10 days of last alerts will be returned. Specify either 
`alert_days` or `alert_minutes` to show specific date. Specifying 
`alert_minutes` will supersede `alert_days`. Maximum of `30` days of alerts 
can be shown, e.g.:

```ruby
client.alerts.index(alert_days: 30)
#
client.alerts.index(alert_minutes: 15)
```

Resulting data is an OpenStruct and JSON coded object corresponding to the
returned API object describing the alerts and urls to retrieve them.

The API returns a JSON object that is formatted as follows:

```json
{
  "alerts": [
    {
      "id": "(Active911 Alert id number)",
      "uri": "(API URI to access the alert data)"
    }
  ]
}
```

### Alert 

To obtain information about all the agency locations normally available via the
Active 911 API URL `https://access.active911.com/interface/open_api/api/alerts/:id`, 
issue the following client method call: 

```ruby
client.alerts.show(alert_id: alert_id)
```

You will need to specify the `alert_id`.

Resulting data is an OpenStruct and JSON coded object corresponding to the
returned API object describing the alert containing information about 
the alert's location, pagegroups, and responses. 

The API returns a JSON object that is formatted as follows:

```json
{
   "id": "(Active911 Alert id number)", 
   "agency": {
     "id": "(Agency id number)", 
     "uri": "(API URI to access the agency data)"
   }, 
   "place": "(Common name for the place ie Joe's Tavern)",
   "address": "(Street address for the alert)", 
   "unit": "(Subunit ie Apt G)", 
   "city": "(City alert is located in)", 
   "state": "(State alert is located in)", 
   "latitude": "(Latitude of the alert)", 
   "longitude": "(Longitude of the alert)", 
   "source": "(Source of the alert ie Battalion Chief 10)", 
   "units": "(Dispatched Units ie Truck1)", 
   "cad_code": "(Identifier Code given by CAD Software)", 
   "priority": "(Priority from CAD system)", 
   "details": "(Additional Notes)", 
   "sent": "(Time the alert was sent from our servers to Active911 devices)", 
   "description": "(Short description of the alert)", 
   "pagegroups": [
     {
       "title": "(Name of the pagegroup)",
       "prefix": "(Pagegroup prefix)"
     }
   ], 
   "map_code": "(Map Code for the alert)", 
   "received": "(Time the alert was received by our servers)", 
   "cross_street": "(Cross street of where the alert is located)", 
   "responses": [
    {
      "device": {
       "id": "(Device id of responder)", 
       "uri": "(API URI to access the device data)"
      }, 
      "timestamp": "(Timestamp of when the device responded with this response)", 
      "response": "(Name of the response action taken)"
    } 
   ]
}
```

### Map Locations

To obtain information about all the agency locations normally available via the 
Active 911 API URL `https://access.active911.com/interface/open_api/api/locations`, 
issue the following client method call:

```ruby
client.locations.index
```

Resulting data is an OpenStruct and JSON coded object corresponding to the
returned API object describing all the locations configured for the agency 
and their respective URLs.

The API returns a JSON object that is formatted as follows:

```json
{
 "locations": [{
      "id": "(Active911 Location id number)", 
      "uri": "(API URI to access the location data)"
    }]
     
}
```

### Map Location

To obtain information about a specific location normally available via the
Active 911 API URL 
`https://access.active911.com/interface/open_api/api/locations/:id`, issue 
the following client method call:

```ruby
client.locations.show(location_id: location_id)
```
You will need to specify the `location_id`.

Resulting data is an OpenStruct and JSON coded object corresponding to the
returned API object describing the specific location information.

The API returns a JSON object that is formatted as follows:

```json
{
  "locations": {
    "id": "(Active911 id for this map data point)",
    "name": "(Name of this map data point)",
    "description": "(Short description of this map data point)",
    "icon_id": "(Active911 id of the icon used for this map data point)",
    "icon_color": "(Color of this map data point)",
    "latitude": "(Latitude of this map data point)",
    "longitude": "(Longitude of this map data point)",
    "location_type": "(The type of map data point)",
    "resources": [
      {
        "id": "(Resource id of responder)",
        "uri": "(API URI to access the resource data)"
      }
    ]
  }
}
```

### Map Resources

To obtain information about map resource normally available via the Active 911 
API URL `https://access.active911.com/interface/open_api/api/resources/:id`, 
issue the following client method call:

```ruby
client.resource.show(resource_id: resource_id)
```

The API returns a JSON object that is formatted as follows:
```json
{
  "resource": {
    "id": "(Active911 id for this resource)",
    "title": "(Name of the title)",
    "filename": "(Filename)",
    "extension": "(File extension)",
    "size": "(File size in bytes)",
    "details": "(Details about the file)",
    "agency": {
      "id": "(Agency id number)",
      "uri": "(API URI to access the agency data)"
    },
    "location": {
      "id": "(Location id number)",
      "uri": "(API URI to access the location data)"
    }
  }
}
```

## Limitations

* `locations` interface does not support creation (POST) yet.

## Development

To set up your development environment, run:

``` bash
git clone 
cd active911_api
bin/setup
```

You can also use the IRB console for direct access to all objects:

``` bash
bin/console
```

## Tests

To test, run:

``` bash
bin/rake
```

## [License](https://mit-license.org/)

## [Security](https://github.com/rocky-mountain-rescue/active911_api/issues)

## [Versions](https://github.com/rocky-mountain-rescue/active911_api/Versions.md)

## Credits

- Built with [Gemsmith](https://www.alchemists.io/projects/gemsmith).
- Engineered by [Pawel Osiczko](https://github.com/posiczko).
