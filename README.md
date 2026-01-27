# NMMR (v0.1.1): 鼻黏膜菌群孟德尔随机化分析工具包

## 简介
**NMMR** (Nasal Microbiome Mendelian Randomization) 是一个专为鼻黏膜菌群 MR 分析设计的一站式 R 包。它集成了数据标准化、批量 MR 分析、结果 Meta 分析以及 SNP 注释映射功能，旨在简化繁琐的分析流程，让研究者能专注于生物学意义的挖掘。

**当前版本**: v0.1.1  
**作者**: 沧溟  
**邮箱**: 20220123072@bucm.edu.cn  
**版权声明**: 本项目为闭源私有软件。版权所有 (C) 2026 沧溟。严禁未经授权的复制与分发。

---

## v0.1.1 更新日志 (2026-01-27)

- **[新增] SNP 注释与映射功能** (`run_snp_annotation`)：支持对显著 SNP 进行邻近基因检索及功能富集分析（gprofiler2）。
- **[增强] Meta 分析模块** (`run_mr_meta`)：完全集成多队列 Meta 分析逻辑，支持 IVW、Weighted Median 等四种核心方法，并自动生成高质量森林图。
- **[优化] 内存管理**：重构了 `run_nasal_mr` 的数据读取逻辑，采用流式块处理（Chunk-based reading），支持在低内存环境下处理数 GB 级别的 GWAS 大文件。
- **[修复] 命名空间规范化**：修复了 R CMD check 中的所有函数绑定警告，提升了包的稳定性。
- **[安全] 授权体系更新**：强化了激活码验证机制，并更新为 Proprietary 闭源授权。

---

## 核心功能

### 1. 智能数据标准化 (`standardize_gwas`)
一键将来源各异的 GWAS 概括统计数据（Summary Statistics）转换为 MR 分析所需的标准格式。
- **智能特性**: 自动映射列名、自动转换 OR/beta、修复 -log10(P) 格式、清洗异常值。

### 2. 自动化 MR 分析 (`run_nasal_mr`)
利用**内置的鼻黏膜菌群暴露数据**，对一个或多个结局数据进行批量 MR 分析。
- **数据安全**: 核心数据 AES 加密，需激活码解锁。
- **全流程**: 自动对齐 (Harmonize)、执行多种 MR 方法、敏感性分析（异质性、多效性、Steiger、Radial MR）。
- **自动绘图**: 散点图、森林图、漏斗图、留一法图。

### 3. MR 结果 Meta 分析 (`run_mr_meta`)
对多个队列（如不同国家或人群）的 MR 结果进行汇总分析。
- **自动化**: 根据异质性自动选择固定或随机效应模型。
- **输出**: 汇总统计表及 PDF 森林图。

### 4. SNP 注释与映射 (`run_snp_annotation`)
对 MR 发现的显著 SNP 进行生物学背景挖掘。
- **邻近基因**: 自动检索 SNP 上下游指定范围（默认 250kb）内的所有基因。
- **功能富集**: 自动进行 GO/KEGG/Reactome 等通路富集分析。

---

## 安装与激活

### 1. 安装依赖
```r
# 必要依赖环境准备
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
# 部分 Bioconductor 依赖可能需要手动安装
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("GenomicRanges", "IRanges", "S4Vectors", "biomaRt"))
```

### 2. 安装 NMMR
本包为私有闭源软件，仅提供编译后的二进制安装包。请直接下载对应系统的文件，**不要解压**。

```r
# Windows 用户 (.zip)
install.packages("C:/path/to/NMMR_0.1.1.zip", repos = NULL, type = "binary")

# Mac 用户 (.tgz 或 .zip)
install.packages("~/path/to/NMMR_0.1.1.tgz", repos = NULL, type = "binary")
```

### 3. 激活
```r
library(NMMR)
# 1. 获取机器码并发送给作者
get_machine_code() 

# 2. 使用作者提供的激活码进行永久激活
activate_nmmr("YOUR_ACTIVATION_CODE_HERE") 
```

---

## 快速上手示例 (完整版)

### 示例一：GWAS 数据标准化
支持自动识别 IEU VCF 或 普通文本格式。
```r
library(NMMR)

# 场景：将原始 TXT/CSV 转换为 MR 标准格式
standardize_gwas(
  input_file   = "raw_gwas_data.txt.gz", # 支持 .gz 压缩格式
  output_file  = "Outcome_Rhinitis.csv", # 输出路径
  outcome_name = "Rhinitis",             # 结局名称
  sep          = "\t"                    # 原始文件分隔符，默认为制表符
)
```

### 示例二：运行自动化 MR 分析
该函数会自动调取内置的鼻黏膜菌群暴露数据进行分析。
```r
# 场景 A：分析单个结局文件
run_nasal_mr(
  outcome_files = "Outcome_Rhinitis.csv", 
  output_dir    = "Results_Rhinitis",     # 结果存放目录
  chunk_size    = 500000                  # 大文件处理块大小，内存小可调低
)

# 场景 B：批量分析目录下所有标准化后的 CSV 文件
# 此时不传 outcome_files 参数，程序会自动扫描当前目录下所有 .csv 文件
run_nasal_mr(output_dir = "Batch_Results")
```

### 示例三：多队列结果 Meta 分析
当您拥有来自不同来源（如 UKB, FinnGen）的 MR 结果时，可使用此功能汇总。
```r
# 准备结果文件列表和队列名称
res_files <- c(
  "UKB_Results/Outcome_Rhinitis_MR_OR_results.csv",
  "FinnGen_Results/Outcome_Rhinitis_MR_OR_results.csv"
)
cohorts <- c("UKBiobank", "FinnGen")

# 执行 Meta 分析并生成森林图
run_mr_meta(
  input_files  = res_files,
  cohort_names = cohorts,
  output_dir   = "Meta_Analysis_Output"
)
```

### 示例四：显著 SNP 的注释与映射
对 MR 筛选出的显著 SNP 进行生物学意义挖掘。
```r
# 场景：对显著结果进行基因映射和功能富集
run_snp_annotation(
  input_file  = "Batch_Results/Significant_MR_Results.csv", # 显著 SNP 列表
  output_dir  = "SNP_Annotation_Report",
  window_size = 250000,   # 搜索上下游 250kb 范围内的基因
  species     = "hsapiens" # 物种，默认为人类
)
```

---

## 注意事项
1. **数据格式**：`run_nasal_mr` 要求的输入文件必须是经过 `standardize_gwas` 处理后的标准 CSV。
2. **内存建议**：处理超大型 GWAS 文件（>5GB）时，建议将 `chunk_size` 设置为 `200000` 左右以节省内存。
3. **网络连接**：`run_snp_annotation` 功能依赖 `biomaRt` 和 `gprofiler2`，运行时需要稳定的互联网连接以访问 Ensembl 数据库。
4. **版权保护**：请勿尝试破解加密的内置数据，任何未经授权的逆向工程行为都将被追究法律责任。
