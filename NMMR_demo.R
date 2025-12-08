# ==============================================================================
# NMMR 包完整功能演示脚本
# 作者：沧溟
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. 安装与加载
# ------------------------------------------------------------------------------

# 步骤 A：下载安装包
# 请先从 GitHub 仓库下载对应系统的二进制包（.zip 或 .tgz）

# 步骤 B：本地安装（请修改为您下载文件的实际路径）
# install.packages("~/Downloads/NMMR-binary-macos-latest.zip", repos = NULL, type = "binary")

# 加载包
library(NMMR)

# ------------------------------------------------------------------------------
# 2. 激活（首次使用必须）
# ------------------------------------------------------------------------------

# 第一步：获取机器码
my_machine_code <- get_machine_code()
message("您的机器码是：", my_machine_code)
# 请将此机器码发送给作者获取激活码

# 第二步：永久激活（只需运行一次，替换为您收到的真实激活码）
# activate_nmmr("YOUR_ACTIVATION_CODE_HERE")

# ------------------------------------------------------------------------------
# 3. 核心功能展示
# ------------------------------------------------------------------------------

# --- 功能 A：标准化 GWAS 数据 ---
# 将原始数据（如 vcf, txt, csv）转换为 MR 标准格式
# 示例：将 "raw_gwas.txt" 转换为 "outcome_std.csv"
# standardize_gwas(
#   input_file = "raw_gwas.txt", 
#   output_file = "outcome_std.csv", 
#   outcome_name = "Rhinitis"
# )


# --- 功能 B：运行 MR 分析（基于内置鼻黏膜菌群暴露）---
# 方式 1：分析单个文件
# run_nasal_mr(outcome_files = "outcome_std.csv")

# 方式 2：批量分析当前目录下所有 CSV 文件（推荐）
# setwd("path/to/your/csv/folder")
# run_nasal_mr()

# 结果将生成在当前目录下的同名文件夹中（包含结果表格和图片）


# --- 功能 C：MR 结果 Meta 分析 ---
# 当您有多个队列（如中国、日本、韩国）的结果时，进行汇总分析

# 定义结果文件路径
# files <- c(
#   "China/outcome_china_MR_OR_results.csv",
#   "Japan/outcome_japan_MR_OR_results.csv",
#   "Korea/outcome_korea_MR_OR_results.csv"
# )
# 
# 定义队列名称
# cohorts <- c("China", "Japan", "Korea")
# 
# 运行 Meta 分析
# run_mr_meta(input_files = files, cohort_names = cohorts)

# 结果生成：mr_meta_summary.csv 和 森林图 PDF
