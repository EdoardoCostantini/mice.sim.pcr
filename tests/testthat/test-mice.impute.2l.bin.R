context("mice.pcr.sim.impute.2l.bin")

# toenail: outcome is factor
data("toenail2")
data <- tidyr::complete(toenail2, patientID, visit) %>%
  tidyr::fill(treatment) %>%
  dplyr::select(-time) %>%
  dplyr::mutate(patientID = as.integer(patientID))
summary(data)
# fit1 <- glm(outcome ~ treatment * month, data = toenail2, family = binomial)
# fit2 <- glm(outcome ~ treatment * visit, data = toenail2, family = binomial)
# fit3 <- lme4::glmer(outcome ~ treatment * visit + (1 | ID), data = data, family = binomial)

pred <- make.predictorMatrix(data)
pred["outcome", "patientID"] <- -2

test_that("mice.pcr.sim::mice.pcr.sim.impute.2l.bin() accepts factor outcome", {
  expect_silent(imp <- mice.pcr.sim(data, method = "2l.bin", print = FALSE, pred = pred, m = 1, maxit = 1))
  expect_false(anyNA(complete(imp)))
})

# toenail: outcome is 0/1
data("toenail")
data <- tidyr::complete(toenail, ID, visit) %>%
  tidyr::fill(treatment) %>%
  dplyr::select(-month)
summary(data)
pred <- make.predictorMatrix(data)
pred["outcome", "ID"] <- -2

test_that("mice.pcr.sim::mice.pcr.sim.impute.2l.bin() accepts 0/1 outcome", {
  expect_silent(imp <- mice.pcr.sim(data, method = "2l.bin", print = FALSE, pred = pred, m = 1, maxit = 1))
  expect_false(anyNA(complete(imp)))
})
