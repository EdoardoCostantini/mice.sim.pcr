context("mice.pcr.sim.impute.2l.norm")

d1 <- brandsma[1:200, c("sch", "lpo")]
pred <- make.predictorMatrix(d1)
pred["lpo", "sch"] <- -2

test_that("mice.pcr.sim::mice.pcr.sim.impute.2l.norm() runs empty model", {
  expect_silent(imp <- mice.pcr.sim(d1, method = "2l.norm", print = FALSE, pred = pred, m = 1, maxit = 1))
  expect_false(anyNA(complete(imp)))
})
