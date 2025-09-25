import os
import pandas as pd
import matplotlib.pyplot as plt

# Load the csv 
df = pd.read_csv("data/clean/ageband_sex_counts_2009.csv")

# Label headers
sex_map = {1: "Male", 2: "Female", "1": "Male", "2": "Female"}
df["sex"] = df["sex_code"].map(sex_map).fillna(df["sex_code"].astype(str))

# Enforce age-bad order 
age_order = ["<65", "65-74", "85+"]
df["age_band"] = pd.Categorical(df["age_band"], categories=age_order, ordered=True)

# Tidy up data
wide = df.pivot_table(index="age_band", columns="sex", values="n",aggfunc="sum").fillna(0)

# Plot
fig, ax = plt.subplots(figsize=(8,5))
x = range(len(wide.index))
bar_width = 0.35

# Get series names in a stable order
series = list(wide.columns)
for i, s in enumerate(series):
    ax.bar([xi + i * bar_width for xi in x], wide[s].values, width=bar_width, label=s)

# label and ticks
ax.set_xlabel("Age band")
ax.set_ylabel("Beneficiaries (count)")
ax.set_title("2009 Cohort - Counts by Age Band x Sex")
ax.set_xticks([xi + (bar_width*(len(series)-1))/2 for xi in x])
ax.set_xticklabels(wide.index.astype(str), rotation=0)
ax.legend(title="Sex")

# save to folders
os.makedirs("figures" ,exist_ok=True)
outpath = "figures/ageband_sex_counts_2009.png"
plt.tight_layout()
plt.savefig(outpath, dpi=150)
print(f"Saved to {outpath}")