# Azure Cognitive Services (Azure 認知服務)

[Azure 認知服務是什麼？](https://docs.microsoft.com/zh-tw/azure/cognitive-services/what-are-cognitive-services)

## 認知服務的類別

認知服務的目錄可提供認知理解，分為五個主要支柱：

- 視覺
- 語音
- 語言
- 決策
- 搜尋

可使用`Azure CLI`列出所有有效的類型

```bash
$ az cognitiveservices account list-kinds
```

outputs
```bash
[
  "AnomalyDetector",
  "Bing.CustomSearch",
  "Bing.Search.v7",
  "CognitiveServices",
  "ComputerVision",
  "ContentModerator",
  "CustomVision.Prediction",
  "CustomVision.Training",
  "Face",
  "FormRecognizer",
  "ImmersiveReader",
  "Internal.AllInOne",
  "LUIS",
  "LUIS.Authoring",
  "MetricsAdvisor",
  "Personalizer",
  "QnAMaker",
  "QnAMaker.v2",
  "SpeechServices",
  "TextAnalytics",
  "TextTranslation"
]
```

## 使用ARM建立新的資源

`修改Template中resources底下的kind`即可建立不同類型的認知服務，
下面為建立一個用於訓練的自訂視覺服務

```bash
  "resources": [
    {
      "type": "Microsoft.CognitiveServices/accounts",
      "apiVersion": "2017-04-18",
      "kind": "CustomVision.Training",
    }
  ]
```
