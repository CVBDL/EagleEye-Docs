# EagleEye REST APIs


## Charts


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
  cols: [
    { type: "string", label: "Category" },
    { type: "number", label: "Apple" },
    { type: "number", label: "Orange" }
  ],
  rows: [
    { c: [{ v: "Apple" }, { v: 5 }, { v: 9 }] },
    { c: [{ v: "Orange" }, { v: 7 }, { v: 3 }] },
    { c: [{ v: "Peach" }, { v: 9 }, { v: 13 }] }
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
  cols: [
    { type: "string", label: "Category" },
    { type: "number", label: "Apple" },
    { type: "number", label: "Orange" }
  ],
  rows: [
    { c: [{ v: "Apple" }, { v: 5 }, { v: 9 }] },
    { c: [{ v: "Orange" }, { v: 7 }, { v: 3 }] },
    { c: [{ v: "Peach" }, { v: 9 }, { v: 13 }] }
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
  title: "Fruits Overview",
  hAxis: {
    title: "Category"
  },
  vAxis: {
    title: "Inventory"
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
  title: "Fruits Overview",
  hAxis: {
    title: "Category"
  },
  vAxis: {
    title: "Inventory"
  }
}
```
