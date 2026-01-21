# NMMR: 鼻黏膜菌群孟德尔随机化分析工具包

## 简介
**NMMR** 是一个专为鼻黏膜菌群 MR 分析设计的一站式 R 包。它集成了数据标准化、批量 MR 分析以及结果 Meta 分析功能，旨在简化繁琐的分析流程，让研究者能专注于生物学意义的挖掘。

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
- **数据安全**: 核心暴露数据经过 AES 加密，需使用激活码解锁分析功能。
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

本包为保护核心算法，仅提供编译后的二进制安装包。

### 1. 下载安装包
请前往 GitHub 仓库的文件列表或 Releases 页面下载对应系统的安装包：
- **仓库地址**: https://github.com/CangmingDing/NMMR-release
- **Windows 用户**: 下载 `NMMR-binary-windows-latest.zip`
- **Mac 用户**: 下载 `NMMR-binary-macos-latest.zip` (或 .tgz)

> **注意**: 请直接下载文件，解压后安装NMMR_0.1.0.zip/NMMR_0.1.0.tgz！

### 2. 本地安装
下载完成后，在 R 中运行以下命令进行安装（请替换为实际文件路径）：

```r
# Windows 用户
install.packages("C:/Downloads/NMMR_0.1.0.zip", repos = NULL, type = "binary")

# Mac 用户
install.packages("~/Downloads/NMMR_0.1.0.tgz", repos = NULL, type = "binary")
```

*(注：安装前请确保已安装 remotes 包以处理依赖，建议先运行 `install.packages("remotes")`)*

---

## 激活与使用

**本包的核心功能受到保护，初次使用需要激活。**

### 1. 获取机器码

安装包后，在 R 中运行以下命令获取您的唯一机器码：

```r
library(NMMR)
get_machine_code()
```

将输出的字符串发送给作者，以获取激活码。

### 2. 永久激活（推荐）

只需运行一次激活函数，后续使用所有功能**无需再输入激活码**。

```r
# 假设作者提供的激活码为 "abcdef123456..."
activate_nmmr("abcdef123456...")
```

### 3. 临时使用（可选）

如果不希望永久激活，也可以在每次调用函数时手动传入 `activation_code` 参数。

```r
run_nasal_mr(activation_code = "abcdef123456...")
```

---

## 快速上手教程

*(注：以下教程假设您已运行 `activate_nmmr` 完成了永久激活)*

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
