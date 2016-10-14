# EagleEye REST APIs

## Table of Contents

* [Overview](#overview)
  * [Current Version](#current-version)
  * [Schema](#schema)
  * [Parameters](#parameters)
  * [Root Endpoint](#root-endpoint)
  * [Client Errors](#client-errors)
  * [Cross Origin Resource Sharing](#cross-origin-resource-sharing)
* [Charts](#charts)
  * [List all charts](#list-all-charts)
  * [Get a single chart via id](#get-a-single-chart-via-id)
  * [Get a single chart via friendly url](#get-a-single-chart-via-friendly-url)
  * [Create a chart](#create-a-chart)
  * [Edit a chart](#edit-a-chart)
  * [Delete a chart](#delete-a-chart)
  * [Delete all charts](#delete-all-charts)
* [Chart Sets](#chart-sets)
  * [List all chart sets](#list-all-chart-sets)
  * [Get a single chart set via chart set id](#get-a-single-chart-set-via-chart-set-id)
  * [Get a single chart set via chart set friendly url](#get-a-single-chart-set-via-chart-set-friendly-url)
  * [Create a chart set](#create-a-chart-set)
  * [Edit a chart set](#edit-a-chart-set)
  * [Delete a chart set](#delete-a-chart-set)
  * [Delete all chart sets](#delete-all-chart-sets)
* [Search](#search)
  * [Search both charts and chart sets](#search-both-charts-and-chart-sets)
  * [Search charts](#search-charts)
  * [Search chart sets](#search-chart-sets)

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
      "field": "friendlyUrl",
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

### List all charts

```text
GET /api/v1/charts
```

#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| sort  | string | The sort field. One of `createdAt`, `updatedAt` or `chartType`. Default: `createdAt`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK

[{
  "_id": "5768e6262999167c30946e7c",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "chartType": "LineChart",
  "domainDataType": "string",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-line-chart",
  "options": {
    "title": "Fruits Overview",
    "hAxis": {
      "title": "Category"
    },
    "vAxis": {
      "title": "Inventory"
    }
  },
  "datatables": {
    "cols": [
      { "type": "string", "label": "Category", "p": {} },
      { "type": "number", "label": "Apple", "p": {} },
      { "type": "number", "label": "Orange", "p": {} }
    ],
    "rows": [
      { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
      { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
    ]
  },
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/5768e6262999167c30946e7c",
    "image": null
  }
}, {
  "_id": "5799641be24561202bc7190d",
  "description": "Upload an image as a chart",
  "chartType": "ImageChart",
  "domainDataType": "string",
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
    "image": "http://<hostname>:<port>/uploadChartImages/IC_6691380Xl7Rn-XOMqYaD9-6fCk2PlH.png"
  }
}]
```

### Get a single chart via id

```text
GET /api/v1/charts/:_id
```

#### Response

> GET /api/v1/charts/57837029c66dc1a4570962b6

```text
HTTP/1.1 200 OK

{
  "_id": "57837029c66dc1a4570962b6",
  "description": "A pretty column chart",
  "chartType": "ColumnChart",
  "domainDataType": "string",
  "friendlyUrl": "c-pretty-column-chart",
  "options": {
    "title": "Pretty column chart",
    "hAxis": {
      "title": ""
    },
    "vAxis": {
      "title": ""
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
    }, {
      "c": [{
        "v": "Chicago, IL"
      }, {
        "v": 2695000
      }, {
        "v": 2896000
      }]
    }, {
      "c": [{
        "v": "Houston, TX"
      }, {
        "v": 2099000
      }, {
        "v": 1953000
      }]
    }, {
      "c": [{
        "v": "Philadelphia, PA"
      }, {
        "v": 1526000
      }, {
        "v": 1517000
      }]
    }]
  },
  "type": "chart",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/57837029c66dc1a4570962b6",
    "image": null
  }
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0


```

### Get a single chart via friendly url

```text
GET /api/v1/charts/:friendlyUrl
```

#### Response

> GET /api/v1/charts/c-pretty-column-chart

```text
HTTP/1.1 200 OK

{
  "_id": "57837029c66dc1a4570962b6",
  "description": "A pretty column chart",
  "chartType": "ColumnChart",
  "domainDataType": "string",
  "friendlyUrl": "c-pretty-column-chart",
  "options": {
    "title": "Pretty column chart",
    "hAxis": {
      "title": ""
    },
    "vAxis": {
      "title": ""
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
    }, {
      "c": [{
        "v": "Chicago, IL"
      }, {
        "v": 2695000
      }, {
        "v": 2896000
      }]
    }, {
      "c": [{
        "v": "Houston, TX"
      }, {
        "v": 2099000
      }, {
        "v": 1953000
      }]
    }, {
      "c": [{
        "v": "Philadelphia, PA"
      }, {
        "v": 1526000
      }, {
        "v": 1517000
      }]
    }]
  },
  "type": "chart",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/57837029c66dc1a4570962b6",
    "image": null
  }
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
| domainDataType | string | Can be one of `string`, `number`, `date` and `datetime`. |
| description    | string | Chart description content.                               |
| friendlyUrl    | string | Unique friendly url                                      |
| options        | object | Chart options.                                           |
| datatable      | object | Optional. Chart datatable.                               |

#### Response

```text
HTTP/1.1 200 OK

{
  "_id": "57837029c66dc1a4570962b6",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "chartType": "LineChart",
  "domainDataType": "string",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-line-chart",
  "options": {
    "title": "Fruits Overview",
    "hAxis": {
      "title": "Category"
    },
    "vAxis": {
      "title": "Inventory"
    }
  },
  "datatables": {
    "cols": [
      { "type": "string", "label": "Category", "p": {} },
      { "type": "number", "label": "Apple", "p": {} },
      { "type": "number", "label": "Orange", "p": {} }
    ],
    "rows": [
      { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
      { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
    ]
  },
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/57837029c66dc1a4570962b6",
    "image": null
  }
}
```

### Edit a chart

```text
PUT /api/v1/charts/:id
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| description    | string | Chart description content.                               |
| friendlyUrl    | string | Unique friendly url                                      |
| options        | object | Chart options.                                           |

#### Response

> PUT /api/v1/charts/57837029c66dc1a4570962b6

```text
HTTP/1.1 200

{
  "_id": "57837029c66dc1a4570962b6",
  "description": "New description",
  "chartType": "ColumnChart",
  "domainDataType": "string",
  "friendlyUrl": "c-pretty-column-chart",
  "options": {
    "title": "New title",
    "hAxis": {
      "title": "New hAxis title"
    },
    "vAxis": {
      "title": "New vAxis title"
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
    }, {
      "c": [{
        "v": "Chicago, IL"
      }, {
        "v": 2695000
      }, {
        "v": 2896000
      }]
    }, {
      "c": [{
        "v": "Houston, TX"
      }, {
        "v": 2099000
      }, {
        "v": 1953000
      }]
    }, {
      "c": [{
        "v": "Philadelphia, PA"
      }, {
        "v": 1526000
      }, {
        "v": 1517000
      }]
    }]
  },
  "type": "chart",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/57837029c66dc1a4570962b6",
    "image": null
  }
}
```

### Delete a chart

```text
DELETE /api/v1/charts/:id
```

#### Response

> DELETE /api/v1/charts/5768e6262999167c30946e7c

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

### List all chart sets

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

[{
  "_id": "578c8c493164a7304f72a9f3",
  "title": "Chart set contains 3 charts",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\ntempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
  "charts": ["57837029c66dc1a4570962b6", "577f7d8825df25803c723069", "5791774271bc66244f964908", "577f7cdc25df25803c723068", "577f7c1425df25803c723067"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "friendlyUrl": ""
}, {
  "_id": "57859a3061c767d81713a163",
  "title": "Test chart remove",
  "description": "Test chart remove",
  "charts": ["5799641be24561202bc7190d"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "friendlyUrl": "s-s-test-remove"
}, {
  "_id": "577f3582dbb89f2c47fc93c0",
  "title": "The first chart set",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  "friendlyUrl": "s-set-a",
  "charts": ["577f7cdc25df25803c723068", "577f7d8825df25803c723069", "577f7a8d25df25803c723066", "577f7c1425df25803c723067", "5779fe9dec794f5c416f9480", "57837029c66dc1a4570962b6"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z"
}]
```

### Get a single chart set via chart set id

```text
GET /api/v1/chart-sets/:_id
```

#### Response

> GET /api/v1/chart-sets/57f60f717600621c3e28a855

```text
HTTP/1.1 200 OK

{
  "_id": "57f60f717600621c3e28a855",
  "title": "Column Chart",
  "description": "",
  "friendlyUrl": "s-the-chart-set",
  "charts": [
    {
      "_id": "57eb2dc15d2722401b951c26",
      "description": "column chart",
      "domainDataType": "string",
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
        "cols": [
          {
            "label": "City",
            "type": "string"
          },
          {
            "label": "2010 Population",
            "type": "number"
          },
          {
            "label": "2000 Population",
            "type": "number"
          }
        ],
        "rows": [
          {
            "c": [
              {
                "v": "New York City, NY"
              },
              {
                "v": 8175000
              },
              {
                "v": 8008000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Los Angeles, CA"
              },
              {
                "v": 3792000
              },
              {
                "v": 3694000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Chicago, IL"
              },
              {
                "v": 2695000
              },
              {
                "v": 2896000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Houston, TX"
              },
              {
                "v": 2099000
              },
              {
                "v": 1953000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Philadelphia, PA"
              },
              {
                "v": 1526000
              },
              {
                "v": 1517000
              }
            ]
          }
        ]
      },
      "type": "chart",
      "browserDownloadUrl": {
        "excel": "http://<hostname>:<port>/api/v1/download/excels/57eb2dc15d2722401b951c26",
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

### Get a single chart set via chart set friendly url

```text
GET /api/v1/chart-sets/:friendlyUrl
```

#### Response

> GET /api/v1/chart-sets/s-the-chart-set

```text
HTTP/1.1 200 OK

{
  "_id": "57f60f717600621c3e28a855",
  "title": "Column Chart",
  "description": "",
  "friendlyUrl": "s-the-chart-set",
  "charts": [
    {
      "_id": "57eb2dc15d2722401b951c26",
      "description": "column chart",
      "domainDataType": "string",
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
        "cols": [
          {
            "label": "City",
            "type": "string"
          },
          {
            "label": "2010 Population",
            "type": "number"
          },
          {
            "label": "2000 Population",
            "type": "number"
          }
        ],
        "rows": [
          {
            "c": [
              {
                "v": "New York City, NY"
              },
              {
                "v": 8175000
              },
              {
                "v": 8008000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Los Angeles, CA"
              },
              {
                "v": 3792000
              },
              {
                "v": 3694000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Chicago, IL"
              },
              {
                "v": 2695000
              },
              {
                "v": 2896000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Houston, TX"
              },
              {
                "v": 2099000
              },
              {
                "v": 1953000
              }
            ]
          },
          {
            "c": [
              {
                "v": "Philadelphia, PA"
              },
              {
                "v": 1526000
              },
              {
                "v": 1517000
              }
            ]
          }
        ]
      },
      "type": "chart",
      "browserDownloadUrl": {
        "excel": "http://<hostname>:<port>/api/v1/download/excels/57eb2dc15d2722401b951c26",
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
| friendlyUrl    | string | Unique friendly url, prefix with `s-`.                   |
| charts         | array  | Chart ids.                                               |

#### Response

```text
HTTP/1.1 200 OK

{
  "title": "This is a chart set",
  "description": "This is a chart set",
  "friendlyUrl": "s-the-chart-set",
  "charts": ["57a93f748fff77fc4789c063", "5791774271bc66244f964908"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "_id": "57ccd2fa4db6dc9c45d3164c"
}
```

### Edit a chart set

```text
PUT /api/v1/chart-sets/:id
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| title          | string | Chart set title.                                         |
| description    | string | Chart set description content.                           |
| friendlyUrl    | string | Unique friendly url, prefix with `s-`.                   |
| charts         | array  | Chart ids.                                               |

#### Response

> PUT /api/v1/chart-sets/57e0f76b31fad8dc35aaee35

```text
HTTP/1.1 200 OK

{
  "_id": "57e0f76b31fad8dc35aaee35",
  "title": "New title",
  "description": "New description",
  "charts": ["57df8fd00b53c66839fdfb6b", "57dbabc60b53c66839fdfb66", "57db539c05db66cc1435218f", "57df3fab0b53c66839fdfb69"],
  "type": "chartset",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "friendlyUrl": "s-product-one"
}
```

### Delete a chart set

```text
DELETE /api/v1/chart-sets/:id
```

#### Response

> DELETE /api/v1/chart-sets/57ccd2fa4db6dc9c45d3164c

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

> GET /api/v1/search?q=set

```text
HTTP/1.1 200 OK

{
  "total_count": 2,
  "items": [{
    "_id": "57ccd2fa4db6dc9c45d3164c",
    "title": "This is a chart set",
    "description": "This is a chart set",
    "friendlyUrl": "s-the-chart-set",
    "charts": ["57a93f748fff77fc4789c063", "5791774271bc66244f964908"],
    "type": "chartset",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z"
  }, {
    "_id": "577f3582dbb89f2c47fc93c0",
    "title": "The first chart set",
    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "friendlyUrl": "s-set-a",
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

> GET /api/v1/search/charts?q=image

```text
HTTP/1.1 200 OK

{
  "total_count": 2,
  "items": [{
    "_id": "57997784e24561202bc7190e",
    "description": "",
    "chartType": "ImageChart",
    "domainDataType": "string",
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
      "excel": null,
      "image": "http://<hostname>:<port>/uploadChartImages/IC_604587LwFSXflR2yqjdVPL3VPXi2Ad.png"
    }
  }, {
    "_id": "5799641be24561202bc7190d",
    "description": "Upload an image as a chart",
    "chartType": "ImageChart",
    "domainDataType": "string",
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
      "image": "http://<hostname>:<port>/uploadChartImages/IC_6691380Xl7Rn-XOMqYaD9-6fCk2PlH.png"
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

> GET /api/v1/search/chart-sets?q=remove

```text
HTTP/1.1 200 OK

{
  "total_count": 1,
  "items": [{
    "_id": "57859a3061c767d81713a163",
    "title": "Test chart remove",
    "description": "Test chart remove",
    "charts": ["5799641be24561202bc7190d"],
    "type": "chartset",
    "createdAt": "2016-06-06T08:00:00.000Z",
    "updatedAt": "2016-06-06T08:00:00.000Z",
    "friendlyUrl": "s-s-test-remove"
  }]
}
```
