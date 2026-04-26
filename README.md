# 🍕 Food Delivery Platform Analytics

A comprehensive data analysis case study investigating operational inefficiencies and revenue decline in a food delivery platform, with actionable recommendations for business improvement.

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/SQL-MySQL-orange.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📊 Project Overview

This project analyzes a food delivery platform experiencing a **30% revenue drop** and identifies critical operational issues including:

- **12% order cancellation rate** (1 in 8 orders)
- **7.4% platform-wide complaint rate**
- **1,492 duplicate orders** in the system
- **2,000 orders with negative values** (data quality issues)
- **Some restaurants with 40%+ cancellation rates**

### Key Findings

- **Revenue Impact**: ₹132 billion GMV converting to only ₹7.8M net revenue (0.006% margin)
- **Geographic Insights**: Delhi leads in cancellations (12.25%), Bangalore has highest complaint rate (7.90%)
- **Channel Performance**: Referral program underperforms YouTube Ads by 4% in revenue per user
- **Data Quality Crisis**: Significant data integrity issues impacting business operations

## 🗂️ Repository Structure

```
food-delivery-analysis/
│
├── data/                          # Raw datasets
│   ├── orders.csv                 # Order transactions (250K+ records)
│   ├── users.csv                  # User information
│   ├── restaurants.csv            # Restaurant details
│   └── complaints.csv             # Customer complaints (18K+ records)
│
├── sql/                           # SQL analysis scripts
│   └── analysis_queries.sql       # Performance metrics, cohort analysis, quality checks
│
├── notebooks/                     # Jupyter notebooks
│   └── data_analysis.ipynb        # Python-based exploratory data analysis
│
├── docs/                          # Documentation
│   ├── problem_statement.docx     # Original case study requirements
│   ├── detailed_insights.docx     # In-depth analysis and findings
│   └── executive_summary.docx     # High-level business recommendations
│
├── insights/                      # Analysis outputs
│   └── visualizations/            # Charts and graphs (to be added)
│
├── requirements.txt               # Python dependencies
├── LICENSE                        # Project license
└── README.md                      # This file
```

## 🔍 Analysis Methodology

### 1. Data Quality Assessment
- Identified and quantified duplicate orders (1,492 instances)
- Detected negative order values (2,000 orders)
- Analyzed missing delivery time data (1,500 records)

### 2. Business Metrics Analysis
**SQL Queries for:**
- Monthly revenue trends and order volume
- City-level performance metrics
- Restaurant performance benchmarking
- User acquisition channel effectiveness
- 3-month cohort revenue analysis

### 3. Python Data Analysis
- Exploratory data analysis (EDA)
- Statistical testing and correlation analysis
- Customer behavior segmentation
- Predictive modeling for churn/cancellation

### 4. Key Performance Indicators (KPIs)
- **Cancellation Rate**: Percentage of cancelled orders
- **Complaint Rate**: Customer complaints per order
- **Average Order Value (AOV)**: Mean transaction size
- **Net Revenue**: Commission + Delivery Fee - Discounts
- **Customer Lifetime Value (CLV)**: 3-month cohort revenue

## 📈 Key Insights

### Revenue Decline Analysis
- **30% drop** from October to December 2025
- Order volume decreased by **6.5%** over the same period
- Top revenue cities: Hyderabad, Kolkata, Lucknow

### Operational Issues

| Issue | Impact | Recommendation |
|-------|--------|----------------|
| High cancellation rates | 12% of orders lost | Implement restaurant quality scoring |
| Data integrity problems | 1,492 duplicates, 2K negative values | Fix backend systems immediately |
| Poor restaurant performance | Some at 40% cancellation | Remove consistently bad performers |
| Suboptimal marketing spend | Referral ROI 4% below YouTube Ads | Reallocate budget to high-performing channels |

### Geographic Performance

```
City          | Avg Order Value | Cancellation % | Complaint % | Net Revenue
--------------|-----------------|----------------|-------------|-------------
Hyderabad     | High            | Moderate       | Moderate    | Top 3
Kolkata       | High            | Moderate       | Low         | Top 3
Bangalore     | Moderate        | Low            | 7.90%       | Moderate
Delhi         | Moderate        | 12.25%         | Moderate    | Underperforming
```

## 🛠️ Technologies Used

- **Database**: MySQL / SQL Server
- **Programming**: Python 3.8+
- **Libraries**: 
  - `pandas` - Data manipulation
  - `numpy` - Numerical computing
  - `matplotlib` / `seaborn` - Visualization
  - `scipy` - Statistical analysis
- **Tools**: Jupyter Notebook, SQL Server Management Studio

## 🚀 Getting Started

### Prerequisites

```bash
# Python 3.8 or higher
python --version

# SQL Database (MySQL/PostgreSQL/SQL Server)
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Mansha0805/food-delivery-case-study.git
cd food-delivery-case-study
```

2. **Install Python dependencies**
```bash
pip install -r requirements.txt
```

3. **Set up database**
```bash
# Import CSV files into your SQL database
# Update connection strings in analysis scripts
```

4. **Run SQL queries**
```sql
-- Execute queries in sql/analysis_queries.sql
-- Adjust database name as needed
USE fooddeliveryplatform;
```

5. **Open Jupyter notebook**
```bash
jupyter notebook notebooks/data_analysis.ipynb
```

## 📋 Analysis Workflow

1. **Data Import & Cleaning** (`data/`)
   - Load raw CSV files
   - Handle missing values
   - Remove duplicates
   - Fix data type issues

2. **SQL Analysis** (`sql/`)
   - Run monthly performance queries
   - City-level aggregations
   - Restaurant benchmarking
   - Cohort analysis

3. **Python Deep Dive** (`notebooks/`)
   - Statistical analysis
   - Correlation studies
   - Visualizations
   - Predictive modeling

4. **Report Generation** (`docs/`)
   - Executive summary
   - Detailed findings
   - Actionable recommendations

## 💡 Key Recommendations

### Immediate Actions (Week 1-2)
1. **Fix Data Quality Issues**
   - Eliminate duplicate order IDs
   - Investigate and resolve negative order values
   - Fill missing delivery times (1,500 records)
   - Implement automated data validation

2. **Address Critical Restaurant Issues**
   - Give ultimatum to restaurants with 30%+ cancellation rates
   - Create visible quality scores for customers
   - Weekly performance reports to all restaurants

### Short-term Improvements (Week 3-4)
3. **Optimize Commission Structure**
   - Test performance-based commission: +3% for poor performers, -2% for top performers
   - Incentivize quality service

4. **Reallocate Marketing Budget**
   - Reduce Referral program spend by 30%
   - Increase investment in YouTube Ads
   - Investigate Delhi market specifically

### Ongoing Monitoring
5. **Daily/Weekly KPI Tracking**
   - Cancellation rate by city (daily)
   - Restaurant complaint rates (weekly)
   - Data quality metrics (automated)
   - Revenue trends and forecasts

## 📊 Results & Impact

**Projected Improvements:**
- Reduce cancellation rate from 12% to <7% (5% improvement = ₹2.1M additional revenue)
- Decrease complaint rate by 30% through restaurant quality control
- Improve marketing ROI by 15% through channel optimization
- Eliminate data quality issues, enabling better decision-making

## 📸 Screenshots

*Add visualizations and dashboard screenshots here*

## 🤝 Contributing

This is a case study project for portfolio purposes. However, suggestions and feedback are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Mansha**
- GitHub: [@Mansha0805](https://github.com/Mansha0805)
- Email: mansha0805@gmail.com

## 🙏 Acknowledgments

- Dataset provided as part of a data analyst case study assignment
- Analysis methodology inspired by industry best practices
- Special thanks to the data analytics community

---

**⭐ If you found this project helpful, please consider giving it a star!**

*Last Updated: March 2026*
