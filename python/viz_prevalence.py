import os
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/clean/prevalence_by_ageband_2009.csv")


# order of the age bands
age_order = ["<65", "65-74", "75-84","85+"]
df["age_band"] = pd.Categorical(df['age_band'], categories=age_order, ordered=True)
df = df.sort_values("age_band")

# convert to percent for better readability
for c in ["p_diabetes", "p_chf", "p_copd"]:
    df[c] = df[c] * 100.0

#plot (one axis, multiple series, default colors)
fig, ax = plt.subplots(figsize=(8,5))
x = range(len(df))
ax.plot(x, df["p_diabetes"].values, marker="o", label="Diabetes")
ax.plot(x, df["p_chf"].values,      marker="o", label="CHF")
ax.plot(x, df["p_copd"].values,     marker="o", label="COPD")

ax.set_xlabel("Age band")
ax.set_ylabel("Prevalence (%)")
ax.set_title("2009 Chronic Condition Prevalence by Age Band")
ax.set_xticks(list(x))
ax.set_xticklabels(df["age_band"].astype(str))
ax.legend()

os.makedirs("figures", exist_ok=True)
outpath = "figures/prevalence_by_ageband_2009.png"
plt.tight_layout()
plt.savefig(outpath, dpi=150)
print(f"Saved to {outpath}")