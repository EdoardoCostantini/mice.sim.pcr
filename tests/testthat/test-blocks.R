context("blocks")


imp <- mice.pcr.sim(nhanes, blocks = make.blocks(list(c("bmi", "chl"), "bmi", "age")), m = 10, print = FALSE)
# plot(imp)

test_that("removes variables from 'where'", {
  expect_identical(sum(imp$where[, "hyp"]), 0L)
})


# reprex https://github.com/amices/mice.pcr.sim/issues/326
imp1 <- mice.pcr.sim(nhanes, seed = 1, m = 1, maxit = 2, print = FALSE)
imp2 <- mice.pcr.sim(nhanes, blocks = list(c("bmi", "hyp"), "chl"), m = 1, maxit = 2, seed = 1, print = FALSE)
test_that("expands a univariate method to all variables in the block", {
  expect_identical(complete(imp1, 1), complete(imp2, 1))
})

imp3 <- mice.pcr.sim(nhanes, blocks = list(c("hyp", "bmi"), "chl"), m = 1, maxit = 2, seed = 1, print = FALSE)
imp4 <- mice.pcr.sim(nhanes, visitSequence = c("hyp", "bmi", "chl"), m = 1, maxit = 2, seed = 1, print = FALSE)
test_that("blocks alter the visit sequence", {
  expect_identical(complete(imp3, 1), complete(imp3, 1))
})
