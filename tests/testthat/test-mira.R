context("mira")

imp <- mice.pcr.sim(nhanes, print = FALSE, maxit = 1, seed = 121, m = 1)
fit <- with(imp, sd(bmi))

test_that("list prints without an error", {
  expect_output(print(fit))
})
