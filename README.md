# NMMR: 鼻黏膜菌群孟德尔随机化分析工具包

## 简介
**NMMR** 是一个专为鼻黏膜菌群 MR 分析设计的一站式 R 包。它集成了数据标准化、批量 MR 分析（基于内置鼻黏膜菌群暴露数据）以及结果 Meta 分析功能，旨在简化繁琐的分析流程，让研究者能专注于生物学意义的挖掘。

**作者**: 沧溟  
**邮箱**: 20220123072@bucm.edu.cn

---

## 核心功能

### 1. 智能数据标准化 (`standardize_gwas`)
一键将来源各异的 GWAS 概括统计数据（Summary Statistics）转换为 MR 分析所需的标准格式。
- **支持格式**: 
    - IEU OpenGWAS VCF (`.vcf`, `.vcf.gz`)
    - 常见表格文件 (`.csv`, `.tsv`, `.txt`, `.gz`)
- **智能特性**:
    - 自动识别并映射列名（如自动识别 `beta`, `OR`, `logOR` 等）。
    - 自动转换 `OR` 为 `beta`。
    - 自动识别并修复 `-log10(P)` 格式的 P 值。
    - 自动清洗无效数据。

### 2. 自动化 MR 分析 (`run_nasal_mr`)
利用**内置的鼻黏膜菌群暴露数据**，对一个或多个结局数据进行批量 MR 分析。
- **流程**:
    - 自动读取内置暴露数据。
    - 自动与用户提供的结局数据进行 Harmonize（对齐）。
    - 执行多种 MR 方法（IVW, MR-Egger, Weighted Median 等）。
    - 进行敏感性分析（异质性、多效性、Steiger 检验、Radial MR）。
    - **自动绘图**: 散点图、森林图、漏斗图、留一法图。
- **灵活性**: 支持处理单个文件或自动扫描目录下所有 CSV 文件。

### 3. MR 结果 Meta 分析 (`run_mr_meta`)
对多个队列（如不同国家或人群）的 MR 结果进行 Meta 分析。
- **模型**: 根据异质性自动选择固定效应 (Fixed Effect) 或随机效应 (Random Effect) 模型。
- **输出**: 生成汇总 CSV 表格及高质量森林图（PDF）。

---

## 安装说明

由于这是一个本地包，请使用以下方式安装：

```r
install.packages("NMMR", repos = NULL, type = "source")
```

*(注：请确保您的 R 环境已安装 `TwoSampleMR`, `data.table`, `dplyr`, `readr`, `RadialMR`, `forestploter` 等依赖包)*

---

## 快速上手教程

### 场景一：处理单个原始 GWAS 数据并进行 MR 分析

```r
library(NMMR)

# 1. 数据标准化
# 假设您有一个原始文件 "raw_data.txt.gz"，想转换为标准格式 "outcome_std.csv"
standardize_gwas(
  input_file = "raw_data.txt.gz", 
  output_file = "outcome_std.csv", 
  outcome_name = "Rhinitis"
)

# 2. 运行 MR 分析
# 使用内置的鼻黏膜菌群暴露数据，对刚刚生成的结局数据进行分析
# 结果将保存在当前目录下的 "outcome_std" 文件夹中
run_nasal_mr(outcome_files = "outcome_std.csv")
```

### 场景二：批量处理目录下所有结局文件

```r
library(NMMR)

# 1. 假设当前目录下有多个已标准化的 CSV 文件 (outcome_A.csv, outcome_B.csv ...)
# 直接运行函数，自动扫描并分析所有 CSV
run_nasal_mr() 
```

### 场景三：多队列 Meta 分析

```r
library(NMMR)

# 假设您已经分别跑完了中国、日本、韩国队列的 MR，并得到了对应的 OR 结果文件
files <- c(
  "China/outcome_china_MR_OR_results.csv",
  "Japan/outcome_japan_MR_OR_results.csv",
  "Korea/outcome_korea_MR_OR_results.csv"
)

cohorts <- c("China", "Japan", "Korea")

# 运行 Meta 分析
# 结果将生成 "mr_meta_summary.csv" 和森林图 PDF
run_mr_meta(input_files = files, cohort_names = cohorts)
```
