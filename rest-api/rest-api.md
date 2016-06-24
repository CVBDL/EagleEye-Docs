# EagleEye REST APIs


## Table of Contents

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


## Charts


### List all charts

```text
GET /api/v1/charts
```


#### Response

```json
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

```json
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


### Get one chart via chart friendly url

```text
GET /api/v1/charts/:friendlyUrl
```

#### Response

```json
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
| options        | object | Optional. Chart options.                                 |
| datatable      | object | Optional. Chart datatable.                               |


#### Response

```json
"8371e6262999167c30946e3f"
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

```json
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

```json
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

```json
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

```json
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
GET /api/v1/charts/clear
```


#### Response

```json
"success"
```


## Chart Sets


### List all chart sets


```text
GET /api/v1/chart-sets
```


#### Response

```json
[{
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "charts": ["5768e6262999167c30946e7c"]
}, {
  "title": "Chart set sample two",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set-two",
  "charts": ["5768e6262999167c30946e7c", "576a4d56ae40178426a0feba"]
}]
```


### Get one chart set via chart set id

```text
GET /api/v1/chart-sets/:_id
```


#### Response

```json
{
  "_id": "576a512dae40178426a0febb",
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "charts": ["5768e6262999167c30946e7c"]
}
```


### Get one chart set via chart set friendly url

```text
GET /api/v1/chart-sets/:friendlyUrl
```


#### Response

```json
{
  "_id": "576a512dae40178426a0febb",
  "title": "Chart set sample",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
  "friendlyUrl": "s-eagleeye-chart-set",
  "charts": ["5768e6262999167c30946e7c"]
}
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

```json
"576a512dae40178426a0febb"
```


### Remove all chart sets

```text
GET /api/v1/chart-sets/clear
```


#### Response

```json
"success"
```
