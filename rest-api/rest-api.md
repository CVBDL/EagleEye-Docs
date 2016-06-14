# EagleEye REST APIs


## Table of Contents

* [Charts](#charts)
  * [List all charts](#list-all-charts)
  * [Get one chart](#get-one-chart)
  * [Create a new chart](#create-a-new-chart)
  * [List one chart's datatable](#list-one-charts-datatable)
  * [Edit one chart's datatable](#edit-one-charts-datatable)
  * [List one chart's options](#list-one-charts-options)
  * [Edit one chart's options](#edit-one-charts-options)


## Charts


### List all charts

```text
GET /api/v1/charts
```


#### Response

```json
[{
  "id": 1,
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "chartType": "LineChart",
  "domainDataType": "string",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
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
      { "type": "string", "label": "Category" },
      { "type": "number", "label": "Apple" },
      { "type": "number", "label": "Orange" }
    ],
    "rows": [
      { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
      { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
    ]
  }
}]
```


### Get one chart

```text
GET /api/v1/charts/:id
```

#### Response

```json
{
  "id": 1,
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "chartType": "LineChart",
  "domainDataType": "string",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
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
      { "type": "string", "label": "Category" },
      { "type": "number", "label": "Apple" },
      { "type": "number", "label": "Orange" }
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
| options        | object | Optional. Chart options.                                 |
| datatables     | object | Optional. Chart datatables.                              |


#### Response

```json
[{
  "id": 2,
  "timestamp": 1465891633478,
  "lastUpdateTimestamp": 1465891842059,
  "chartType": "LineChart",
  "domainDataType": "string",
  "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
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
      { "type": "string", "label": "Category" },
      { "type": "number", "label": "Apple" },
      { "type": "number", "label": "Orange" }
    ],
    "rows": [
      { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
      { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
    ]
  }
}]
```


### List one chart's datatable

```text
GET /api/v1/charts/:id/datatables
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
    { "type": "string", "label": "Category" },
    { "type": "number", "label": "Apple" },
    { "type": "number", "label": "Orange" }
  ],
  "rows": [
    { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
    { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
  ]
}
```

When `type` is `file`:

```text
Content-Disposition: attachment; filename="chart-datatables.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
```


### Edit one chart's datatable

```text
POST /api/v1/charts/:id/datatables
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
    { "type": "string", "label": "Category" },
    { "type": "number", "label": "Apple" },
    { "type": "number", "label": "Orange" }
  ],
  "rows": [
    { "c": [{ "v": "Apple" }, { "v": 5 }, { "v": 9 }] },
    { "c": [{ "v": "Orange" }, { "v": 7 }, { "v": 3 }] }
  ]
}
```


### List one chart's options

```text
GET /api/v1/charts/:id/options
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
  }
}
```


### Edit one chart's options

```text
POST /api/v1/charts/:id/options
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
