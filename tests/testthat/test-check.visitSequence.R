context("check.visitSequence")

data <- nhanes

test_that("mice.pcr.sim() takes numerical and character visitSequence", {
  expect_silent(imp <- mice.pcr.sim(data, visitSequence = 4:1, m = 1, print = FALSE))
  expect_silent(imp <- mice.pcr.sim(data, visitSequence = rev(names(data)), m = 1, print = FALSE))
})
