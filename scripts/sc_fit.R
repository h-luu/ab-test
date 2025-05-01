df <- read.csv("../data/city_month.csv")
unique(df$city)

library(Synth)

# Get all city names except the treated one
all_cities <- unique(df$city)
controls <- setdiff(all_cities, "city_0")

df$city_id <- as.numeric(as.factor(df$city))


dataprep.out <- dataprep(
  foo = df,
  predictors = "outcome",            
  predictors.op = "mean",            
  time.predictors.prior = 0:19,
  special.predictors = list(
    list("outcome", 0, "mean"),
    list("outcome", 5, "mean")
  ),
  dependent = "outcome",
  unit.variable = "city_id",
  unit.names.variable = "city",
  time.variable = "month",
  treatment.identifier = 1,
  controls.identifier = controls,
  time.optimize.ssr = 0:19
  time.plot = 0:29
)

synth.out <- synth(dataprep.out)

path.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Main = "Treated Unit vs Synthetic Control",
          Ylab = "Outcome", Xlab = "Time",
          Legend = c("Treated", "Synthetic"),
          Legend.position = "bottomright")

abline(v = 20, lty = 2, col = "red")  # Dashed vertical line at treatment start

