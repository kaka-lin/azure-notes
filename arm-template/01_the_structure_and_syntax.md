# The structure and syntax of ARM templates

[Understand the structure and syntax of ARM templates](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/template-syntax)

## Table of Contents

- [The structure and syntax of ARM templates](#the-structure-and-syntax-of-arm-templates)
  - [Table of Contents](#table-of-contents)
  - [1. 範本格式](#1-範本格式)
  - [2. 參數](#2-參數)
  - [3. 變數](#3-變數)
  - [4. 函式](#4-函式)
  - [5. 資源](#5-資源)
  - [6. 輸出](#6-輸出)
  - [7. Deployment modes](#7-deployment-modes)

## 1. 範本格式

最簡單的結構中，範本具有下列元素:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "",
  "apiProfile": "",
  "parameters": {  },
  "variables": {  },
  "functions": [  ],
  "resources": [  ],
  "outputs": {  }
}
```

- `$schema`：`指定JSON結構描述檔案的位置`。

  結構描述檔案會描述範本中可用的屬性。 例如，結構描述會將resources定義為範本的其中一個有效屬性。

  - 如果使用 Visual Studio Code 搭配 Azure Resource Manager 工具擴充功能，請使用最新版本進行資源群組部署:

    `https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#`


  - 其他編輯器 (包括 Visual Studio) 可能無法處理此架構。 針對這些編輯器，請使用：

    `https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#`

  - 針對訂用帳戶部署，使用：

    `https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#`

  - 針對管理群組部署，請使用：

    `https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#`

  - 針對租使用者部署，請使用：

    `https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json#`

- `contentVersion`：`指定範本版本 (例如 1.0.0.0)。`

   您可以為此元素提供任何值。 使用此值在範本中記載重大變更。 使用範本部署資源時，這個值可用來確定使用的是正確的範本。

- `resources`：包含您想要部署或更新的資源。

## 2. 參數

在`parameters`範本的區段中，您可以指定部署資源時可輸入的值。 一個範本的`限制為256個參數`。 可以使用包含多個屬性的物件來減少參數數目。

```json
"parameters": {
  "<parameter-name>" : {
    "type" : "<type-of-parameter-value>",
    "defaultValue": "<default-value-of-parameter>",
    "allowedValues": [ "<array-of-allowed-values>" ],
    "minValue": <minimum-value-for-int>,
    "maxValue": <maximum-value-for-int>,
    "minLength": <minimum-length-for-string-or-array>,
    "maxLength": <maximum-length-for-string-or-array-parameters>,
    "metadata": {
      "description": "<description-of-the parameter>"
    }
  }
}
```

- `type`: 參數值類型。

  允許的類型和值為 `string、securestring、int、bool、object、secureObject，以及 array`。 請參閱 [ARM 範本中的資料類型](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/data-types?tabs=json)。

- `allowedValues`: 參數的允許值陣列，確保提供正確的值

## 3. 變數

在`variables`區段中，您會建立可在整個範本中使用的值。 您不需要定義變數，但它們通常會經由減少複雜運算式來簡化您的範本。 每個變數的格式都符合其中一個[資料類型](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/data-types?tabs=json)。

```json
"variables": {
  "<variable-name>": "<variable-value>",
  "<variable-name>": {
    <variable-complex-type-value>
  },
  "<variable-object-name>": {
    "copy": [
      {
        "name": "<name-of-array-property>",
        "count": <number-of-iterations>,
        "input": <object-or-value-to-repeat>
      }
    ]
  },
  "copy": [
    {
      "name": "<variable-array-name>",
      "count": <number-of-iterations>,
      "input": <object-or-value-to-repeat>
    }
  ]
}
```

如需使用`copy`為變數建立數個值的詳細資訊，請參閱[變數反復](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/copy-variables)專案。

## 4. 函式

在您的範本內，您可以建立自己的函式。 這些函式可供您在範本中使用。

從範本中支援的運算式和[函式](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/template-functions)建立使用者定義的函式。

在定義使用者函式時，有一些限制：

- 此函式無法存取變數。
- 此函式只能使用函式中定義的參數。 當您在使用者自訂函數中使用- `parameters`函式時，您會被限制為該函數的參數。
- 此函式無法呼叫其他的使用者定義函式。
- 此函式不能使用[參考函式](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/template-functions-resource?tabs=json#reference)。
- 函式的參數不能有預設值。

```json
"functions": [
  {
    "namespace": "<namespace-for-functions>",
    "members": {
      "<function-name>": {
        "parameters": [
          {
            "name": "<parameter-name>",
            "type": "<type-of-parameter-value>"
          }
        ],
        "output": {
          "type": "<type-of-output-value>",
          "value": "<function-return-value>"
        }
      }
    }
  }
],
```

- `namespace-for-functions`: 自訂函式的命名空間。 使用以避免與範本函式發生名稱衝突。
- `function-name`: 自訂函數的名稱。

    `呼叫函式時，請將函數名稱與命名空間合併`。例如，若要在命名空間 contoso 中呼叫名為的函式 uniqueName，請使用 `"[contoso.uniqueName()]"`。

## 5. 資源

在`resources`區段中，您會定義要部署或更新的資源。

您會定義結構如下的資源：

```json
"resources": [
  {
      "condition": "<true-to-deploy-this-resource>",
      "type": "<resource-provider-namespace/resource-type-name>",
      "apiVersion": "<api-version-of-resource>",
      "name": "<name-of-the-resource>",
      "comments": "<your-reference-notes>",
      "location": "<location-of-resource>",
      "dependsOn": [
          "<array-of-related-resource-names>"
      ],
      "tags": {
          "<tag-name1>": "<tag-value1>",
          "<tag-name2>": "<tag-value2>"
      },
      "sku": {
          "name": "<sku-name>",
          "tier": "<sku-tier>",
          "size": "<sku-size>",
          "family": "<sku-family>",
          "capacity": <sku-capacity>
      },
      "kind": "<type-of-resource>",
      "copy": {
          "name": "<name-of-copy-loop>",
          "count": <number-of-iterations>,
          "mode": "<serial-or-parallel>",
          "batchSize": <number-to-deploy-serially>
      },
      "plan": {
          "name": "<plan-name>",
          "promotionCode": "<plan-promotion-code>",
          "publisher": "<plan-publisher>",
          "product": "<plan-product>",
          "version": "<plan-version>"
      },
      "properties": {
          "<settings-for-the-resource>",
          "copy": [
              {
                  "name": ,
                  "count": ,
                  "input": {}
              }
          ]
      },
      "resources": [
          "<array-of-child-resources>"
      ]
  }
]
```

- `type`: 資源類型。 此值是資源提供者的命名空間與資源類型 (的組合，例如 Microsoft.Storage/storageAccounts) 。
- `location`: 參閱[設定資源位置](https://docs.microsoft.com/zh-tw/azure/azure-resource-manager/templates/resource-location?tabs=azure-powershell)
- `sku`: 某些資源允許以值定義要部署的 SKU。 例如，您可以指定儲存體帳戶的備援類型。
- `properties`: 資源特定的組態設定。 屬性的值和您在 REST API 作業 (PUT 方法) 要求主體中提供來建立資源的值是一樣的。 您也可以指定複本陣列，以建立屬性的數個執行個體。 若要判斷可用的值，請參閱 範本參考。

## 6. 輸出

在 outputs 區段中，您會指定從部署傳回的值。 通常，您會從已部署的資源傳回值。

下列範例顯示輸出定義的結構：

```json
"outputs": {
  "<output-name>": {
    "condition": "<boolean-value-whether-to-output-value>",
    "type": "<type-of-output-value>",
    "value": "<output-value-expression>",
    "copy": {
      "count": <number-of-iterations>,
      "input": <values-for-the-variable>
    }
  }
}
```

## 7. Deployment modes

- Incremental (default)
  - `保留`resource group中Template裡面沒有定義的resources
  - 新增Template中有但是resource group不存在的resource
    - 新增硬碟
  - 不會重新設定已經存在resource group中的resource(除非template異動)
    - 改static IP

- Complete
  - `刪除`resource group中Template裡面沒有定義的resources
    - 移除硬碟
    - 移除多的網卡
  - 新增Template中有但是resource group不存在的resource
  - 不會重新設定已經存在resource group中的resource(除非template異動)
  - CLI: `$: az gropu deployment create --mode Complete...`
