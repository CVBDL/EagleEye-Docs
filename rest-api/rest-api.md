# EagleEye REST APIs


## Table of Contents

* [Overview](#overview)
  * [Cross Origin Resource Sharing](cross-origin-resource-sharing)
  * [Client Errors](#client-errors)
* [Charts](#charts)
  * [List all charts](#list-all-charts)
  * [Get one chart via chart id](#get-one-chart-via-chart-id)
  * [Get one chart via chart friendly url](#get-one-chart-via-chart-friendly-url)
  * [Create a new chart](#create-a-new-chart)
  * [List one chart's datatable](#list-one-charts-datatable)
  * [Edit one chart's datatable](#edit-one-charts-datatable)
  * [List one chart's options](#list-one-charts-options)
  * [Edit one chart's options](#edit-one-charts-options)
  * [Remove all charts](#remove-all-charts)
* [Chart Sets](#chart-sets)
  * [List all chart sets](#list-all-chart-sets)
  * [Get one chart set via chart set id](#get-one-chart-set-via-chart-set-id)
  * [Get one chart set via chart set friendly url](#get-one-chart-set-via-chart-set-friendly-url)
  * [Create a new chart set](#create-a-new-chart-set)
  * [Remove all chart sets](#remove-all-chart-sets)
* [Search](#search)
  * [Search both charts and chart sets](#search-both-charts-and-chart-sets)
  * [Search charts](#search-charts)
  * [Search chart sets](#search-chart-sets)


## Overview


## Cross Origin Resource Sharing

The API supports Cross Origin Resource Sharing (CORS) for AJAX requests from any origin. You can read the [CORS W3C Recommendation](http://www.w3.org/TR/cors/).

This is an example:

```sh
curl -i https://api/v1/chart-sets/s-not-exist -H "Origin: http://example.com"
HTTP/1.1 404 Not Found
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept
Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS
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


## Charts


### List all charts

```text
GET /api/v1/charts
```


#### Parameters

| Name  | Type   | Description                                                                                        |
| ----- | ------ | -------------------------------------------------------------------------------------------------- |
| sort  | string | The sort field. One of `timestamp`, `lastUpdateTimestamp` or `chartType`. Default: `timestamp`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |


#### Response

```text
HTTP/1.1 200 OK

[{
  "_id": "5768e6262999167c30946e7c",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
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
  }
}, {
  "_id": "576a4d56ae40178426a0feba",
  "chartType": "ColumnChart",
  "domainDataType": "date",
  "friendlyUrl": "c-eagleeye-column-chart",
  "options": {
    "title": "Column Chart",
    "hAxis": {
      "title": "Date"
    },
    "vAxis": {
      "title": "Number"
    }
  },
  "datatable": {
    "cols": [
      { "type": "date", "label": "Date", "p": {} },
      { "type": "number", "label": "Apple", "p": {} },
      { "type": "number", "label": "Orange", "p": {} }
    ],
    "rows": [
      { "c": [{ "v": "2016-06-11T16:00:00.000Z" }, { "v": 5 }, { "v": 9 }] },
      { "c": [{ "v": "2016-06-12T16:00:00.000Z" }, { "v": 7 }, { "v": 3 }] }
    ]
  }
}]
```


### Get one chart via chart id

```text
GET /api/v1/charts/:_id
```

#### Response

```text
HTTP/1.1 200 OK

{
  "_id": "5768e6262999167c30946e7c",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
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
  }
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0
```


### Get one chart via chart friendly url

```text
GET /api/v1/charts/:friendlyUrl
```

#### Response

```text
HTTP/1.1 200 OK

{
  "_id": "5768e6262999167c30946e7c",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
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
  }
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0
```


### Create a new chart

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
  "_id": "8371e6262999167c30946e3f",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891633478,
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
  }
}
```


### List one chart's datatable

```text
GET /api/v1/charts/:_id/datatable
```


#### Parameters

| Name | Type   | Description                                      |
| ---- | ------ | ------------------------------------------------ |
| type | string | Can be one of `json` and `file`. Default: `json` |


#### Response

When `type` is `json`:

```text
HTTP/1.1 200 OK

{
  "cols": [
    { "type": "string", "label": "Category", "p": {} },
    { "type": "number", "label": "Apple", "p": {} },
    { "type": "number", "label": "Orange", "p": {} }
  ],
  "rows": [
    { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
    { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
  ]
}
```

When `type` is `file`:

```text
Content-Disposition: attachment; filename="chart-datatable.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
```


### Edit one chart's datatable

```text
POST /api/v1/charts/:_id/datatable
```


#### Input

| Name | Type           | Description                                      |
| ---- | -------------- | ------------------------------------------------ |
| type | string         | Can be one of `json` and `file`. Default: `json` |
| data | string or file | JSON string or file depends on `type`            |


#### Response

```text
HTTP/1.1 200 OK

{
  "cols": [
    { "type": "string", "label": "Category", "p": {} },
    { "type": "number", "label": "Apple", "p": {} },
    { "type": "number", "label": "Orange", "p": {} }
  ],
  "rows": [
    { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
    { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
  ]
}
```


### List one chart's options

```text
GET /api/v1/charts/:_id/options
```


#### Response

```text
HTTP/1.1 200 OK

{
  "title": "Fruits Overview",
  "hAxis": {
    "title": "Category"
  },
  "vAxis": {
    "title": "Inventory"
  },
  "animation": {
    "duration": 500,
    "easing": "out",
    "startup": true
  },
  "tooltip": {
    "showColorCode": true
  }
}
```


### Edit one chart's options

```text
POST /api/v1/charts/:_id/options
```


#### Input

Chart options JSON string.


#### Response

```text
HTTP/1.1 200 OK

{
  "title": "Fruits Overview",
  "hAxis": {
    "title": "Category"
  },
  "vAxis": {
    "title": "Inventory"
  }
}
```


### Remove all charts

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
| sort  | string | The sort field. One of `timestamp` and `lastUpdateTimestamp`. Default: `timestamp`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |


#### Response

```text
HTTP/1.1 200 OK

[{
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "charts": ["5768e6262999167c30946e7c"]
}, {
  "title": "Chart set sample two",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set-two",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "charts": ["5768e6262999167c30946e7c", "576a4d56ae40178426a0feba"]
}]
```


### Get one chart set via chart set id

```text
GET /api/v1/chart-sets/:_id
```


#### Response

```text
HTTP/1.1 200 OK

{
  "_id": "576a512dae40178426a0febb",
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "charts": ["5768e6262999167c30946e7c"]
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0
```


### Get one chart set via chart set friendly url

```text
GET /api/v1/chart-sets/:friendlyUrl
```


#### Response

```text
HTTP/1.1 200 OK

{
  "_id": "576a512dae40178426a0febb",
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "charts": ["5768e6262999167c30946e7c"]
}
```

If no record found:

```text
HTTP/1.1 404 Not Found
Content-Length: 0
```


### Create a new chart set

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
  "_id": "576a512dae40178426a0febb",
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "charts": ["5768e6262999167c30946e7c"]
}
```


### Remove all chart sets

```text
GET /api/v1/chart-sets/clear
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
| sort  | string | The sort field. One of `timestamp`, `lastUpdateTimestamp` or `chartType`. Default: `timestamp`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |


#### Response

```text
HTTP/1.1 200 OK

{
  "total_count": 666,
  "items": [{
    "_id": "5768e6262999167c30946e7c",
    "type": "chart",
    "timestamp": 1465891633478,
    "lastUpdateTimestamp": 1465891842059,
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
    }
  }, {
    "_id": "576a512dae40178426a0febb",
    "type": "chartset",
    "title": "Chart set sample",
    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
    "friendlyUrl": "s-eagleeye-chart-set",
    "timestamp": 1465891633478,
    "lastUpdateTimestamp": 1465891842059,
    "charts": ["5768e6262999167c30946e7c"]
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
| sort  | string | The sort field. One of `timestamp`, `lastUpdateTimestamp` or `chartType`. Default: `timestamp`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |


#### Response

```text
HTTP/1.1 200 OK

{
  "total_count": 120,
  "items": [{
    "_id": "5768e6262999167c30946e7c",
    "type": "chart",
    "timestamp": 1465891633478,
    "lastUpdateTimestamp": 1465891842059,
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
| sort  | string | The sort field. One of `timestamp`, `lastUpdateTimestamp` or `chartType`. Default: `timestamp`     |
| order | string | The sort order if sort parameter is provided. One of `asc` or `desc`. Default: `desc`              |
| limit | number | The results count field. Mainly for pagination purpose. Zero value means no limitation. Default: 0 |
| start | number | The start index of results. Mainly for pagination purpose. Default: 1                              |


#### Response

```text
HTTP/1.1 200 OK

{
  "total_count": 30,
  "items": [{
    "_id": "576a512dae40178426a0febb",
    "type": "chartset",
    "title": "Chart set sample",
    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
    "friendlyUrl": "s-eagleeye-chart-set",
    "timestamp": 1465891633478,
    "lastUpdateTimestamp": 1465891842059,
    "charts": ["5768e6262999167c30946e7c"]
  }]
}
```
