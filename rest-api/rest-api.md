# EagleEye Platform API v1

## Table of Contents

* [Overview](#overview)
  * [Current Version](#current-version)
  * [Schema](#schema)
  * [Parameters](#parameters)
  * [Root Endpoint](#root-endpoint)
  * [Client Errors](#client-errors)
  * [HTTP Verbs](#http-verbs)
  * [Cross Origin Resource Sharing](#cross-origin-resource-sharing)
* [Charts](#charts)
  * [List charts](#list-charts)
  * [Get a single chart](#get-a-single-chart)
  * [Create a chart](#create-a-chart)
  * [Edit a chart](#edit-a-chart)
  * [Get data table](#get-data-table)
  * [Upload a chart file](#upload-a-chart-file)
  * [Delete a chart](#delete-a-chart)
* [Chart Sets](#chart-sets)
  * [List chart sets](#list-chart-sets)
  * [Get a single chart set](#get-a-single-chart-set)
  * [Create a chart set](#create-a-chart-set)
  * [Edit a chart set](#edit-a-chart-set)
  * [Delete a chart set](#delete-a-chart-set)

## Overview

### Current Version

The current version is `v1`. You must specify it in url `http://hostname:port/api/v1/`.

### Schema

All API access is over HTTP. All data is sent and received as JSON.

Blank fields are included as `null` instead of being omitted.

All timestamps are returned in ISO 8601 format:

```text
YYYY-MM-DDTHH:MM:SSZ
```

### Parameters

Many API methods take optional parameters. For GET requests, any parameters not specified as a segment in the path can be padded as an HTTP query string parameter:

```sh
curl -i http://hostname:port/api/v1/charts?limit=1
```

### Root Endpoint

You can issue a `GET` request to the root endpoint to get all the endpoint categories that the API supports:

```sh
curl http://hostname:port/api/v1
```

### Client Errors

There are three possible types of client errors on API calls that receive request bodies:

1. Sending invalid JSON will result in a `400 Bad Request` response.

```text
HTTP/1.1 400 Bad Request
Content-Length: 35

{ "message": "Problems parsing JSON" }
```

2. Sending the wrong type of JSON values will result in a `400 Bad Request` response.

```text
HTTP/1.1 400 Bad Request
Content-Length: 40

{ "message": "Body should be a JSON object" }
```

3. Sending invalid fields will result in a `422 Unprocessable Entity` response.

```text
HTTP/1.1 422 Unprocessable Entity
Content-Length: 149

{
  "message": "Validation Failed",
  "errors": [
    {
      "resource": "chart",
      "field": "_id",
      "code": "already_exists"
    }
  ]
}
```

All error objects have resource and field properties so that your client can tell what the problem is. There's also an error code to let you know what is wrong with the field. These are the possible validation error codes:

| Error Name     | Description                                      |
| -------------- | ------------------------------------------------ |
| missing        | This means a resource does not exist.            |
| missing_field  | This means a required field on a resource has not been set. |
| invalid        | This means the formatting of a field is invalid. The documentation for that resource should be able to give you more specific information. |
| already_exists | This means another resource has the same value as this field. This can happen in resources that must have some unique key (such as Label names). |

### HTTP Verbs

EagleEye Platform API will try to use appropriate HTTP verbs for each action.

Verb `PATCH` is an uncommon HTTP verb, so use `POST` instead.

| Verb       | Description                                              |
| ---------- | -------------------------------------------------------- |
| GET        | Used for retrieving resources.                           |
| POST       | Used for creating resources or update a resource.        |
| PUT        | Used for replacing resources or collections.             |
| DELETE     | Used for deleting resources.                             |
| GET        | Used for retrieving resources.                           |

### Cross Origin Resource Sharing

The API supports Cross Origin Resource Sharing (CORS) for AJAX requests from any origin. You can read the [CORS W3C Recommendation](http://www.w3.org/TR/cors/).

This is an example:

```sh
curl -i https://api/v1/chart-sets/s-not-exist -H "Origin: http://example.com"
HTTP/1.1 404 Not Found
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept
Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS
```

## Charts

### List charts

```text
GET /api/v1/charts
```

#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| sort  | string | The sort field. Can be one of: `createdAt` and `updatedAt`. Default: `createdAt`                   |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. 0 means no limitation. Default: 0          |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK
```

```json
[{
  "_id": "57837029c66dc1a4570962b6",
  "chartType": "ColumnChart",
  "description": "Sample chart.",
  "datatable": {
    "cols": [{
      "label": "City",
      "type": "string"
    }, {
      "label": "2010 Population",
      "type": "number"
    }, {
      "label": "2000 Population",
      "type": "number"
    }],
    "rows": [{
      "c": [{
        "v": "New York City, NY"
      }, {
        "v": 8175000
      }, {
        "v": 8008000
      }]
    }, {
      "c": [{
        "v": "Los Angeles, CA"
      }, {
        "v": 3792000
      }, {
        "v": 3694000
      }]
    }]
  },
  "options": {
    "title": "Population of Largest U.S. Cities",
    "hAxis": {
      "title": "Total Population"
    },
    "vAxis": {
      "title": "City"
    }
  },
  "imageUrl": null,
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}]
```

### Get a single chart

```text
GET /api/v1/charts/:_id
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57837029c66dc1a4570962b6",
  "chartType": "ColumnChart",
  "description": "Sample chart.",
  "datatable": {
    "cols": [{
      "label": "City",
      "type": "string"
    }, {
      "label": "2010 Population",
      "type": "number"
    }, {
      "label": "2000 Population",
      "type": "number"
    }],
    "rows": [{
      "c": [{
        "v": "New York City, NY"
      }, {
        "v": 8175000
      }, {
        "v": 8008000
      }]
    }, {
      "c": [{
        "v": "Los Angeles, CA"
      }, {
        "v": 3792000
      }, {
        "v": 3694000
      }]
    }]
  },
  "options": {
    "title": "Population of Largest U.S. Cities",
    "hAxis": {
      "title": "Total Population"
    },
    "vAxis": {
      "title": "City"
    }
  },
  "imageUrl": null,
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0
```

### Create a chart

```text
POST /api/v1/charts
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| chartType      | string | Can be one of `LineChart`, `ColumnChart` and `BarChart`. |
| description    | string | Chart description content.                               |
| options        | object | Chart options.                                           |
| datatable      | object | Optional. Chart datatable.                               |

#### Example

```json
{
  "description": "Sample chart.",
  "chartType": "ColumnChart",
  "options": {
    "title": "Population of Largest U.S. Cities",
    "hAxis": {
      "title": "Total Population"
    },
    "vAxis": {
      "title": "City"
    }
  },
  "datatable": {
    "cols": [{
      "label": "City",
      "type": "string"
    }, {
      "label": "2010 Population",
      "type": "number"
    }, {
      "label": "2000 Population",
      "type": "number"
    }],
    "rows": [{
      "c": [{
        "v": "New York City, NY"
      }, {
        "v": 8175000
      }, {
        "v": 8008000
      }]
    }, {
      "c": [{
        "v": "Los Angeles, CA"
      }, {
        "v": 3792000
      }, {
        "v": 3694000
      }]
    }]
  },
}
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57837029c66dc1a4570962b6",
  "description": "Sample chart.",
  "chartType": "ColumnChart",
  "datatable": {
    "cols": [{
      "label": "City",
      "type": "string"
    }, {
      "label": "2010 Population",
      "type": "number"
    }, {
      "label": "2000 Population",
      "type": "number"
    }],
    "rows": [{
      "c": [{
        "v": "New York City, NY"
      }, {
        "v": 8175000
      }, {
        "v": 8008000
      }]
    }, {
      "c": [{
        "v": "Los Angeles, CA"
      }, {
        "v": 3792000
      }, {
        "v": 3694000
      }]
    }]
  },
  "options": {
    "title": "Population of Largest U.S. Cities",
    "hAxis": {
      "title": "Total Population"
    },
    "vAxis": {
      "title": "City"
    }
  },
  "imageUrl": null,
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}
```

### Edit a chart

```text
POST /api/v1/charts/:_id
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| description    | string | Chart description content.                               |
| options        | object | Chart options.                                           |
| datatable      | object | Chart data table.                                        |

#### Example

```json
{
  "description": "Year 2016",
  "options": {
    "title": "Population of Largest U.S. Cities in 2016"
  },
  "datatable": null
}
```

#### Response

```text
HTTP/1.1 200
```

```json
{
  "_id": "57837029c66dc1a4570962b6",
  "chartType": "ColumnChart",
  "description": "Year 2016",
  "datatable": null,
  "options": {
    "title": "Population of Largest U.S. Cities in 2016",
    "hAxis": {
      "title": "Total Population"
    },
    "vAxis": {
      "title": "City"
    }
  },
  "imageUrl": null,
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}
```

### Get data table

```text
GET /api/v1/charts/:_id/datatable
```

#### Parameters

| Name   | Type   | Description                                                                                        |
| ------ | ------ | -------------------------------------------------------------------------------------------------- |
| format | string | *Required.* Data table format field. One of `json` and `xlsx`. If specify `xlsx`, response will be an attachment. When in a browser, it will start to download the .xlsx file. |

#### Response

```text
HTTP/1.1 200
```

```json
{
  "cols": [{
    "label": "City",
    "type": "string"
  }, {
    "label": "2010 Population",
    "type": "number"
  }, {
    "label": "2000 Population",
    "type": "number"
  }],
  "rows": [{
    "c": [{
      "v": "Houston, TX"
    }, {
      "v": 2099000
    }, {
      "v": 2019000
    }]
  }]
}
```

### Upload a chart file

We could upload an `.xlsx` file to update a chart's data table.

We also could upload an image (png or jpeg) for a chart of `ImageChart` type.

```text
POST /api/v1/charts/:_id/files
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| Content-Type   | string | *Required.* The content type of the asset. This should be set in the Header. Example: "image/png". |
| file           | file   | Uploaded file.                                           |

#### Available media types

* `image/png`
* `image/jpeg`
* `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`

#### Response

```text
HTTP/1.1 200
```

```json
{
  "_id": "57837029c66dc1a4570962b6",
  "chartType": "ColumnChart",
  "description": "Sample chart.",
  "datatable": {
    "cols": [{
      "label": "City",
      "type": "string"
    }, {
      "label": "2010 Population",
      "type": "number"
    }, {
      "label": "2000 Population",
      "type": "number"
    }],
    "rows": [{
      "c": [{
        "v": "Houston, TX"
      }, {
        "v": 2099000
      }, {
        "v": 2019000
      }]
    }]
  },
  "options": {
    "title": "Population of Largest U.S. Cities",
    "hAxis": {
      "title": "Total Population"
    },
    "vAxis": {
      "title": "City"
    }
  },
  "imageUrl": null,
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}
```

### Delete a chart

```text
DELETE /api/v1/charts/:_id
```

#### Response

```text
HTTP/1.1 204 No Content
```

## Chart Sets

### List chart sets

```text
GET /api/v1/chart-sets
```

#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| sort  | string | The sort field. One of `createdAt` and `updatedAt`. Default: `createdAt`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK
```

```json
[{
  "_id": "578c8c493164a7304f72a9f3",
  "title": "Sample chart set.",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "charts": ["57837029c66dc1a4570962b6", "577f7d8825df25803c723069", "5791774271bc66244f964908", "577f7cdc25df25803c723068", "577f7c1425df25803c723067"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}]
```

### Get a single chart set

```text
GET /api/v1/chart-sets/:_id
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57f60f717600621c3e28a855",
  "title": "Column Chart",
  "description": "",
  "charts": [
    {
      "_id": "57eb2dc15d2722401b951c26",
      "description": "column chart",
      "options": {
        "title": "Column",
        "hAxis": {
          "title": "",
          "format": ""
        },
        "vAxis": {
          "title": "",
          "format": ""
        },
        "combolines": "",
        "isStacked": true,
        "chartArea": {}
      },
      "chartType": "ColumnChart",
      "datatable": {
        "cols": [{
          "label": "City",
          "type": "string"
        }, {
          "label": "2010 Population",
          "type": "number"
        }, {
          "label": "2000 Population",
          "type": "number"
        }],
        "rows": [{
          "c": [{
            "v": "New York City, NY"
          }, {
            "v": 8175000
          }, {
            "v": 8008000
          }]
        }, {
          "c": [{
            "v": "Los Angeles, CA"
          }, {
            "v": 3792000
          }, {
            "v": 3694000
          }]
        }]
      },
      "type": "chart",
      "imageUrl": null,
      "createdAt": "2016-09-28T02:41:05.949Z",
      "updatedAt": "2016-09-28T02:49:54.768Z"
    }
  ],
  "type": "chartset",
  "updatedAt": "2016-10-06T08:46:41.135Z",
  "createdAt": "2016-10-06T08:46:41.135Z"
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0
```

### Create a chart set

```text
POST /api/v1/chart-sets
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| title          | string | Chart set title.                                         |
| description    | string | Chart set description content.                           |
| charts         | array  | Chart ids.                                               |

#### Example

```json
{
  "title": "New chart set",
  "description": "This is a new chart set.",
  "charts": ["57a93f748fff77fc4789c063", "5791774271bc66244f964908"]
}
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "title": "New chart set",
  "description": "This is a new chart set.",
  "charts": ["57a93f748fff77fc4789c063", "5791774271bc66244f964908"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "_id": "57ccd2fa4db6dc9c45d3164c"
}
```

### Edit a chart set

```text
POST /api/v1/chart-sets/:_id
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| title          | string | Chart set title.                                         |
| description    | string | Chart set description content.                           |
| charts         | array  | Chart ids.                                               |

#### Example

```json
{
  "title": "New chart set",
  "description": "This is a new chart set.",
  "charts": ["57a93f748fff77fc4789c063"]
}
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57e0f76b31fad8dc35aaee35",
  "title": "New chart set",
  "description": "This is a new chart set.",
  "charts": ["57a93f748fff77fc4789c063"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T09:11:00.000Z"
}
```

### Delete a chart set

```text
DELETE /api/v1/chart-sets/:_id
```

#### Response

```text
HTTP/1.1 204 No Content
```
