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
  * [Get a single chart via id](#get-a-single-chart-via-id)
  * [Get a single chart via friendly url](#get-a-single-chart-via-friendly-url)
  * [Create a chart](#create-a-chart)
  * [Edit a chart](#edit-a-chart)
  * [Edit data table](#edit-data-table)
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
  * [Edit task status](#edit-task-status)

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

### HTTP Verbs

EagleEye Platform API will try to use appropriate HTTP verbs for each action.

Verb `PATCH` is an uncommon HTTP verb, so use `PUT` instead.

| Verb       | Description                                              |
| ---------- | -------------------------------------------------------- |
| GET        | Used for retrieving resources.                           |
| POST       | Used for creating resources.                             |
| PUT        | Used for updating or replacing resources or collections. |
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
| sort  | string | The sort field. One of `createdAt`, `updatedAt` or `chartType`. Default: `createdAt`               |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |

#### Response

```text
HTTP/1.1 200 OK

[{
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
    }]
  },
  "type": "chart",
  "createdAt": "2016-06-06T08:00:00.000Z",
  "updatedAt": "2016-06-06T08:00:00.000Z",
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/57837029c66dc1a4570962b6",
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
  "browserDownloadUrl": {
    "excel": "http://<hostname>:<port>/api/v1/download/excels/57837029c66dc1a4570962b6",
    "image": null
  }
}
```

### Edit a chart

```text
PUT /api/v1/charts/:_id
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

### Edit data table

```text
PUT /api/v1/charts/:_id/datatable
```

#### Input

| Name           | Type   | Description                                              |
| -------------- | ------ | -------------------------------------------------------- |
| datatable      | array  | 2D array of chart data table.                            |

#### Request payload

```json
{
  "datatable": [
    ["city", "2010 Population", "2000 Population"],
    ["NY", 8175000, 8008000],
    ["CA", 3792000, 3694000]
  ]
}
```

#### Response

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
DELETE /api/v1/charts/:_id
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
PUT /api/v1/chart-sets/:_id
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
DELETE /api/v1/chart-sets/:_id
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
    "friendlyUrl": "s-test-remove"
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
  "createdAt": "2016-10-08T00:01:00.000Z",
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
  "createdAt": "2016-10-08T00:01:00.000Z",
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
  "createdAt": "2016-10-08T00:01:00.000Z",
  "startedAt": "2016-10-08T00:01:00.000Z",
  "finishedAt": null,
  "state": null
}
```

### Edit task status

```text
PUT /api/v1/tasks/:_id
```

#### Input

| Name     | Type   | Description                                                                  |
| -------- | ------ | ---------------------------------------------------------------------------- |
| status   | string | The status of this task, available values are: running, success, failure.    |

#### Response

```text
HTTP/1.1 200 OK

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
  "createdAt": "2016-10-08T00:01:00.000Z",
  "startedAt": "2016-10-08T00:01:00.000Z",
  "finishedAt": "2016-10-08T00:01:12.666Z",
  "state": "success"
}
```
