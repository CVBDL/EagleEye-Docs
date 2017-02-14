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
  * [Edit data table](#edit-data-table)
  * [Upload a chart asset](#upload-a-chart-asset)
  * [Delete a chart](#delete-a-chart)
  * [Delete all charts](#delete-all-charts)
* [Chart Sets](#chart-sets)
  * [List chart sets](#list-chart-sets)
  * [Get a single chart set](#get-a-single-chart-set)
  * [Create a chart set](#create-a-chart-set)
  * [Edit a chart set](#edit-a-chart-set)
  * [Delete a chart set](#delete-a-chart-set)
  * [Delete all chart sets](#delete-all-chart-sets)
* [Search](#search)
  * [Search both charts and chart sets](#search-both-charts-and-chart-sets)
  * [Search charts](#search-charts)
  * [Search chart sets](#search-chart-sets)
* [Jobs](#jobs)
  * [List jobs](#list-jobs)
  * [Get a single job](#get-a-single-job)
  * [Create a job](#create-a-job)
  * [Edit a job](#edit-a-job)
  * [Delete a job](#delete-a-job)
  * [Restart a job](#restart-a-job)
* [Tasks](#tasks)
  * [List tasks](#list-tasks)
  * [Get a single task](#get-a-single-task)
  * [Create a task](#create-a-task)
  * [Edit task state](#edit-task-state)

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
  "browserDownloadUrl": {
    "image": null
  },
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
  "browserDownloadUrl": {
    "image": null
  },
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
  "browserDownloadUrl": {
    "image": null
  },
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
  "browserDownloadUrl": {
    "image": null
  },
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

### Edit data table

```text
PUT /api/v1/charts/:_id/datatable
```

#### Example

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
  "browserDownloadUrl": {
    "image": null
  },
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}
```

### Upload a chart asset

We could upload an `.xlsx` file to update a chart's data table.

We also could upload an image (png or jpeg) for a chart of `ImageChart` type.

```text
POST /api/v1/charts/:_id/assets
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
  "browserDownloadUrl": {
    "image": null
  },
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

### Delete all charts

```text
DELETE /api/v1/charts
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
      "browserDownloadUrl": {
        "image": null
      },
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

### Delete all chart sets

```text
DELETE /api/v1/chart-sets
```

#### Response

```text
HTTP/1.1 204 No Content
```

## Search

The search API provides up to **100** results for each search.

### Search both charts and chart sets

```text
GET /api/v1/search
```

#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| q     | string | The search keywords.                                                                               |
| sort  | string | The sort field. One of `createdAt`, `updatedAt` or `chartType`. Default: `createdAt`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "total_count": 2,
  "items": [{
    "_id": "57ccd2fa4db6dc9c45d3164c",
    "title": "This is a chart set",
    "description": "This is a chart set",
    "charts": ["57a93f748fff77fc4789c063", "5791774271bc66244f964908"],
    "type": "chartset",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z"
  }, {
    "_id": "577f3582dbb89f2c47fc93c0",
    "title": "The first chart set",
    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "charts": ["577f7cdc25df25803c723068", "577f7d8825df25803c723069", "577f7a8d25df25803c723066", "577f7c1425df25803c723067", "5779fe9dec794f5c416f9480", "57837029c66dc1a4570962b6"],
    "type": "chartset",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z"
  }]
}
```

### Search charts

```text
GET /api/v1/search/charts
```

#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| q     | string | The search keywords.                                                                               |
| sort  | string | The sort field. One of `createdAt`, `updatedAt` or `chartType`. Default: `createdAt`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "total_count": 2,
  "items": [{
    "_id": "57997784e24561202bc7190e",
    "description": "",
    "chartType": "ImageChart",
    "options": {
      "title": "Image Test 1",
      "hAxis": {},
      "vAxis": {},
      "isStacked": false
    },
    "datatable": {},
    "type": "ImageChart",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z",
    "browserDownloadUrl": {
      "image": "http://<hostname>:<port>/upload/IC_604587LwFSXflR2yqjdVPL3VPXi2Ad.png"
    }
  }, {
    "_id": "5799641be24561202bc7190d",
    "description": "Upload an image as a chart",
    "chartType": "ImageChart",
    "options": {
      "title": "Image Chart",
      "hAxis": {},
      "vAxis": {},
      "isStacked": false
    },
    "datatable": {},
    "type": "ImageChart",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z",
    "browserDownloadUrl": {
      "excel": null,
      "image": "http://<hostname>:<port>/upload/IC_6691380Xl7Rn-XOMqYaD9-6fCk2PlH.png"
    }
  }]
}
```

### Search chart sets

```text
GET /api/v1/search/chart-sets
```

#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| q     | string | The search keywords.                                                                               |
| sort  | string | The sort field. One of `createdAt`, `updatedAt` or `chartType`. Default: `createdAt`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "total_count": 1,
  "items": [{
    "_id": "57859a3061c767d81713a163",
    "title": "Test chart remove",
    "description": "Test chart remove",
    "charts": ["5799641be24561202bc7190d"],
    "type": "chartset",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z"
  }]
}
```

## Jobs

A job in EagleEye Platform means a cron job.
Cron job is a time-based job scheduler.
A job is mainly used to update charts or chart sets in EagleEye Platform.
But, we also have some system jobs like backup database, etc.

A job **must** have a `name` field, it's the job's name.

A job **must** have an `expression` field.
It's a CRON expression, used to determine when to run the job.

A job **must** have a `command` field.
It's a windows CMD command to execute.

A job **must** have an `enabled` field to indicate whether the job is enabled.

Job example:

```json
{
  "name": "Code Review By Month",
  "expression": "0 0 * * *",
  "command": "/path/to/command/codecollaborator2eagleeye.exe",
  "enabled": true
}
```

### Format of `expression`

```text
*    *    *    *    *    *
┬    ┬    ┬    ┬    ┬    ┬
│    │    │    │    │    |
│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
│    │    │    │    └───── month (1 - 12)
│    │    │    └────────── day of month (1 - 31)
│    │    └─────────────── hour (0 - 23)
│    └──────────────────── minute (0 - 59)
└───────────────────────── second (0 - 59, OPTIONAL)
```

Here're some handy entries:

| Entry   | Description                                                | expression |
| ------- | ---------------------------------------------------------- | ---------- |
| yearly  | Run once a year at midnight of 1 January                   | 0 0 1 1 *  |
| monthly | Run once a month at midnight of the first day of the month | 0 0 1 * *  |
| weekly  | Run once a week at midnight on Sunday morning              | 0 0 * * 0  |
| daily   | Run once a day at midnight                                 | 0 0 * * *  |
| hourly  | Run once an hour at the beginning of the hour              | 0 * * * *  |

### List jobs

```text
GET /api/v1/jobs
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
[{
  "_id": "57fca45d69ea5f081a6b4076",
  "name": "Code Review By Month",
  "expression": "0 0 * * *",
  "command": "/path/to/command/codecollaborator2eagleeye.exe",
  "enabled": true,
  "createdAt": "2016-10-06T11:00:00.000Z",
  "updatedAt": "2016-10-06T11:00:00.000Z",
  "lastState": "success",
  "lastStartedAt": "2016-10-08T11:00:00.000Z",
  "lastFinishedAt": "2016-10-08T11:01:15.000Z"
}]
```

### Get a single job

```text
GET /api/v1/jobs/:_id
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57fca45d69ea5f081a6b4076",
  "name": "Code Review By Month",
  "expression": "0 0 * * *",
  "command": "/path/to/command/codecollaborator2eagleeye.exe",
  "enabled": true,
  "createdAt": "2016-10-06T11:00:00.000Z",
  "updatedAt": "2016-10-06T11:00:00.000Z",
  "lastState": "success",
  "lastStartedAt": "2016-10-08T11:00:00.000Z",
  "lastFinishedAt": "2016-10-08T11:01:15.000Z"
}
```

### Create a job

```text
POST /api/v1/jobs
```

#### Input

| Name       | Type    | Description                                           |
| ---------- | ------- | ----------------------------------------------------- |
| name       | string  | Job name.                                             |
| expression | string  | Cron expression.                                      |
| command    | string  | Command name.                                         |
| enabled    | boolean | Enable the job or not.                                |

#### Example

```json
{
  "name": "Code Review By Month",
  "expression": "0 0 * * *",
  "command": "/path/to/command/codecollaborator2eagleeye.exe",
  "enabled": true
}
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57fca45d69ea5f081a6b4076",
  "name": "Code Review By Month",
  "expression": "0 0 * * *",
  "command": "/path/to/command/codecollaborator2eagleeye.exe",
  "enabled": true,
  "createdAt": "2016-10-06T11:00:00.000Z",
  "updatedAt": "2016-10-06T11:00:00.000Z",
  "lastState": null,
  "lastStartedAt": null,
  "lastFinishedAt": null
}
```

### Edit a job

```text
PUT /api/v1/jobs/:_id
```

#### Input

| Name       | Type    | Description                                           |
| ---------- | ------- | ----------------------------------------------------- |
| name       | string  | Job name.                                             |
| expression | string  | Cron expression.                                      |
| command    | string  | Command name.                                         |
| enabled    | boolean | Enable the job or not.                                |

#### Example

```json
{
  "name": "Code Review By Month",
  "enabled": false
}
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "57fca45d69ea5f081a6b4076",
  "name": "Code Review By Month",
  "expression": "0 0 * * *",
  "command": "/path/to/command/codecollaborator2eagleeye.exe",
  "enabled": false,
  "createdAt": "2016-10-06T11:00:00.000Z",
  "updatedAt": "2016-10-15T11:00:00.000Z",
  "lastState": null,
  "lastStartedAt": null,
  "lastFinishedAt": null
}
```

### Delete a job

```text
DELETE /api/v1/jobs/:_id
```

#### Response

```text
HTTP/1.1 204 No Content
```

### Restart a job

Run the job immediately regardless of the scheduled time.

```text
PUT /api/v1/jobs/:_id/restart
```

#### Response

```text
HTTP/1.1 204 No Content
```

## Tasks

Whenever a job need to run, it will spawn a task to run the command and
recore the process and status.

### List tasks

It will only response the latest 100 logs. The results is sorted by `createAt` 
field in descending order (the latest created the first).

```text
GET /api/v1/tasks
```

#### Parameters

| Name  | Type   | Description                                                 |
| ----- | ------ | ----------------------------------------------------------- |
| jobId | string | The job's id that spawn this task.                          |

#### Response

```text
HTTP/1.1 200 OK
```

```json
[{
  "_id": "25dca45d69ea5f991a6b4076",
  "job": {
    "_id": "57fca45d69ea5f081a6b4076",
    "name": "Code Review By Month",
    "expression": "0 0 * * *",
    "command": "/path/to/command/codecollaborator2eagleeye.exe",
    "enabled": true,
    "createdAt": "2016-10-06T11:00:00.000Z",
    "updatedAt": "2016-10-06T11:00:00.000Z",
    "lastState": "success",
    "lastStartedAt": "2016-10-08T11:00:00.000Z",
    "lastFinishedAt": "2016-10-07T11:00:00.000Z"
  },
  "startedAt": "2016-10-08T00:01:00.000Z",
  "finishedAt": "2016-10-08T00:01:11.111Z",
  "state": "success"
}]
```

### Get a single task

```text
GET /api/v1/tasks/:_id
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "25dca45d69ea5f991a6b4076",
  "job": {
    "_id": "57fca45d69ea5f081a6b4076",
    "name": "Code Review By Month",
    "expression": "0 0 * * *",
    "command": "/path/to/command/codecollaborator2eagleeye.exe",
    "enabled": true,
    "createdAt": "2016-10-06T11:00:00.000Z",
    "updatedAt": "2016-10-06T11:00:00.000Z",
    "lastState": "success",
    "lastStartedAt": "2016-10-08T11:00:00.000Z",
    "lastFinishedAt": "2016-10-07T11:00:00.000Z"
  },
  "startedAt": "2016-10-08T00:01:00.000Z",
  "finishedAt": "2016-10-08T00:01:11.111Z",
  "state": "success"
}
```

### Create a task

```text
POST /api/v1/tasks
```

#### Input

| Name     | Type   | Description                                              |
| -------- | ------ | -------------------------------------------------------- |
| jobId    | string | The id of the job spawn this task.                       |

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "25dca45d69ea5f991a6b4076",
  "job": {
    "_id": "57fca45d69ea5f081a6b4076",
    "name": "Code Review By Month",
    "expression": "0 0 * * *",
    "command": "/path/to/command/codecollaborator2eagleeye.exe",
    "enabled": true,
    "createdAt": "2016-10-06T11:00:00.000Z",
    "updatedAt": "2016-10-06T11:00:00.000Z",
    "lastState": "success",
    "lastStartedAt": "2016-10-08T11:00:00.000Z",
    "lastFinishedAt": "2016-10-08T11:00:30.000Z"
  },
  "startedAt": "2016-10-08T00:01:00.000Z",
  "finishedAt": null,
  "state": null
}
```

### Edit task state

```text
PUT /api/v1/tasks/:_id
```

#### Input

| Name     | Type   | Description                                                                  |
| -------- | ------ | ---------------------------------------------------------------------------- |
| state    | string | The state  of this task, available values are: running, success, failure.    |

#### Example

```json
{
  "state": "success"
}
```

#### Response

```text
HTTP/1.1 200 OK
```

```json
{
  "_id": "25dca45d69ea5f991a6b4076",
  "job": {
    "_id": "57fca45d69ea5f081a6b4076",
    "name": "Code Review By Month",
    "expression": "0 0 * * *",
    "command": "/path/to/command/codecollaborator2eagleeye.exe",
    "enabled": true,
    "createdAt": "2016-10-06T11:00:00.000Z",
    "updatedAt": "2016-10-06T11:00:00.000Z",
    "lastState": "success",
    "lastStartedAt": "2016-10-08T11:00:00.000Z",
    "lastFinishedAt": "2016-10-08T11:00:30.000Z"
  },
  "startedAt": "2016-10-08T00:01:00.000Z",
  "finishedAt": "2016-10-08T00:01:12.666Z",
  "state": "success"
}
```
