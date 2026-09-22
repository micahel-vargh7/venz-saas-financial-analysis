# Project Background
VenZ is a B2B SaaS company founded in 2022, offering tiered subscription plans (Starter, Growth, Enterprise) to customers across North America, Europe, Latin America, and APAC. The company has experienced strong revenue growth since its founding, but recent financial reporting showed net margin growth decelerating relative to revenue growth. This raised concern among finance leadership heading into the next board meeting, prompting an investigation into where the deceleration is originating and what's driving it — whether specific regions, plan tiers, or cost categories are responsible.

This project analyzes company transaction-level data across regions, plan tiers, and expense categories to identify the source of the margin deceleration and provide a data-driven recommendation on where the company should focus to recover growth.

Insights and recommendations are provided on the following key areas:

- **Overall Revenue & Margin Trend**
- **Regional Performance**
- **Plan Tier Performance**
- **APAC Expense Deep Dive**

The SQL queries used to inspect and clean the data for this analysis can be found [here](https://github.com/micahel-vargh7/venz-saas-financial-analysis/blob/main/Venz%20B2B%20SaaS%20Data%20Cleaning.sql).

Targeted Python EDA code regarding various business questions can be found [here](https://github.com/micahel-vargh7/venz-saas-financial-analysis/blob/main/Venz%20B2B%20SaaS%20EDA.ipynb).

An interactive Power BI dashboard used to report and explore these trends can be found [here](https://app.powerbi.com/groups/me/reports/cc9c0a09-7d70-437e-a50d-eab672314e3d/eb5f4d40a07bec6aa954?experience=power-bi).

# Data Structure & Initial Checks
VenZ’s database structure consists of 2 tables: transactions, customers, with total rows of 74,105 (transactions: 71,605, customers: 2,500)

<img width="1090" height="659" alt="Venz ERD image" src="https://github.com/user-attachments/assets/331b376e-3012-4a46-a4ee-c20a03582300" />

Prior to beginning the analysis, a variety of checks were conducted for quality control and familiarization with the datasets. The SQL queries utilized to inspect and perform quality checks and cleaning can be found [here](https://github.com/micahel-vargh7/venz-saas-financial-analysis/blob/main/Venz%20B2B%20SaaS%20Data%20Cleaning.sql).

# Executive Summary 

### Overview of Findings
VenZ's margin growth decelerated sharply in 2025 — from 623% to 184% year-over-year — even as revenue growth also slowed (313% → 183%). The APAC region was the single largest contributor to this drag, accounting for the swing when isolated (removing APAC alone shifts company-wide margin growth from 184% to 223%). Within APAC, rising marketing expenses was the primary driver. Separately, the Starter subscription tier is unprofitable in every region and its losses are widening year-over-year — a separate issue not connected to the APAC+margin deceleration story.

Below is the overview page from the Power BI dashboard; more detail is included throughout the report. The full interactive dashboard can be downloaded [here](https://app.powerbi.com/groups/me/reports/cc9c0a09-7d70-437e-a50d-eab672314e3d/eb5f4d40a07bec6aa954?experience=power-bi).

<img width="1267" height="711" alt="Venz Executive Summary" src="https://github.com/user-attachments/assets/f4324d7e-99ab-4b40-8792-ce6e23133cd0" />

# Insights Deep Dive
### **Overall Revenue & Margin Trend**
- **Margin growth decelerated more sharply than revenue growth in 2025 (623% → 184%, a 439-point drop, versus revenue's 313% → 183%, a 130-point drop)**. This gap suggests the **deceleration isn't just slower sales — cost pressure is growing faster relative to revenue**, which is why the investigation needed to look beyond top-line growth into specific regions and plan tiers to find where that pressure was concentrated. 

- Despite the deceleration, **revenue and margin grew every year with no decline — 2023 was the company's weakest year but still profitable ($183K revenue, no losses), meaning this is a growth-rate problem, not a company in decline.**

- The sharper deceleration in margin versus revenue was the signal that prompted a **deeper investigation into region and plan tier performance, to isolate where the cost pressure driving that gap was concentrated.**

<img width="1000" height="500" alt="Venz - Overall Revenue   Margin Trend" src="https://github.com/user-attachments/assets/80ebb00c-ce9a-4ff3-9370-a3a365f779c2" />

### **Regional Performance (APAC/Europe deceleration, outlier test)**
- Region **APAC had exponential deceleration in its own growth rate (revenue: 372% - 162%, a 210 point drop versus margin: 417% - 146%, a 207 point drop).** This tells us that the **region does contribute to overall growth rate deceleration**, specifically APAC itself is decelerating in growth, which leads to further investigation on what’s inside APAC that is causing it to drag and is APAC an outlier skewing the company-wide numbers?

- **Region APAC had cost-outpacing-revenue problem, in 2025 revenue grew 162% and expense grew 203%,** this tells us that the deceleration for APAC and for overall company is caused by company spending extra money specifically in the APAC region, which raises the question, what exactly is the company spending on that is causing the expense to rise.

- To test whether APAC was truly an outlier (rather than deceleration being spread evenly across regions), company-wide margin growth was recalculated with APAC excluded — **margin growth jumped from 184% to 223%, a 39-point swing. This confirms APAC is the dominant outlier disproportionately dragging down the company-wide margin growth rate**, not just one contributor among several evenly-distributed factors.

- Europe's margin appeared to show a dramatic deceleration (760%→184%), but this was a small-base statistical artifact, not a real business problem — **Europe's revenue and expense grew at nearly identical rates in 2025 (185.0% vs. 185.3%), meaning costs and revenue are scaling proportionally with no underlying margin issue.** This distinguishes Europe from APAC, where revenue and expense growth diverged — a difference explored further below.

<img width="900" height="400" alt="Region Growth By Margin" src="https://github.com/user-attachments/assets/de2946b8-827c-4d4f-b5fb-4f4795f6409a" />

<img width="900" height="400" alt="Region Growth By Revenue" src="https://github.com/user-attachments/assets/c1c96f69-8b99-4f71-9e50-9c88b372e3bb" />

<img width="900" height="400" alt="Margin Growth % - With vs Without APAC" src="https://github.com/user-attachments/assets/6f903ac1-62ee-4ee2-a43c-c68b27e04672" />

### **Plan Tier Performance (Starter losses)**
- **Starter plan_tier is declining in margin every year ($-383K → $-1.17M → $-3.05M)**, its expenses were increasing YoY, it is the only plan that is actively losing money in every region, this raises the question what's causing it to lose money and does it contribute to company’s overall growth deceleration.

- **Starter's margin drag is driven by rising costs outpacing revenue, especially in 24-25 (expense grew 156% vs revenue's 142%)**, which tells us that Starter’s decline is caused by more expense in the Starter plan, which also mirrors APAC’s expense overtaking revenue problem even though they are different segments, and also raises question is this a outlier skewing the overall company’s margin or is it one among others.

- To test whether Starter's losses were skewing the company-wide margin growth rate, **margin growth was recalculated with Starter excluded — the rate shifted from 184% to 172%, an 11-point move,** much smaller than APAC's 39-point swing. This confirms Starter is a real, worsening structural loss in dollar terms, but it is not a dominant outlier distorting the company-wide growth rate — making it a separate issue from the APAC-driven deceleration.

<img width="1000" height="500" alt="Margin Growth % -- With VS  Without Starter (2025)" src="https://github.com/user-attachments/assets/b54ec082-811c-4aa0-8f81-2bcf5bb83d53" />

<img width="1000" height="500" alt="Plan-Tier Trend Year-By-Year" src="https://github.com/user-attachments/assets/bfd5d6d0-b5aa-49e5-a83b-54b17e3ae0f5" />

<img width="1000" height="500" alt="Starter Plan Rising Costs Trend (2024-2025)" src="https://github.com/user-attachments/assets/6cb1aa04-f8be-4e3b-a4b6-21eeaa86b73b" />

### APAC Expense Deep Dive (Marketing driver)
- In APAC, **the cost-outpacing-revenue problem is concentrated in Marketing, which accelerated in expense growth (225%→275%; $11K→$36K→$135K) while every other category decelerated.** This makes Marketing the direct driver of APAC's rising costs, which in turn drove APAC's regional deceleration and, ultimately, the company-wide margin slowdown.

- While Marketing was identified as the specific category driving APAC's cost increase, **the dataset only captures Marketing as a single lump-sum category, without sub-line-item detail (e.g., channel, campaign, or vendor).** This means **the analysis can identify where the cost problem lives, but not what specifically within Marketing is responsible** — a limitation that defines the boundary of this investigation and the starting point for the recommended next step.

<img width="1000" height="500" alt="APAC Expense Categories Trend (2024-2025)" src="https://github.com/user-attachments/assets/1f87af19-c55f-4f1e-b60f-f0b1c2e8db71" />

# Recommendations:
Based on the insights and findings above, we would recommend the Finance and Marketing teams to consider the following:

- Region APAC is dragging the overall company margin, APAC itself is decelerating in margin due to the rise of expense, and that is concentrated on Marketing. **Since the dataset only captures Marketing as a lump sum, a thorough breakdown of APAC's Marketing spend by channel/vendor is recommended to identify what's driving the increase before deciding whether to cut, reallocate, or justify the spend.**

- Unlike APAC, Starter plan did not have a category accelerating 2024-2025, but **Customer Support remained highest in expense 2025 (182%)**, meaning it’s the largest contributor to rising costs for Starter, but starter’s problem might not be one-item fixable but spread across nearly all categories. 

# Assumptions and Caveats:
- Roughly 0.9% of transactions reference a customer_id not found in the customers table. These rows were kept since they still carry usable region and plan_tier data for most of the analysis, but they couldn't be joined to industry_vertical or signup cohort information.

- A small number of rows (14 in plan_tier, 6 in region) remained blank even after recovering values from the customers table, since those customer_ids also didn't exist there. These were left as null.

- About 3% of category values and 1% of amount values were missing with no reliable way to recover or estimate them, so they were left as-is rather than guessed at.

- Duplicate rows were only fully detectable after formatting was cleaned (trimming whitespace, standardizing casing), since inconsistent formatting was masking some duplicates that looked different but were actually the same record.

- The Marketing expense category only exists as a single lump total in this dataset, with no breakdown by channel, campaign, or vendor. This limits the investigation to identifying Marketing as the driver of APAC's rising costs, without being able to pinpoint what specifically within Marketing is responsible.
