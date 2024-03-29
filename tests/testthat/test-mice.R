context("mice.pcr.sim: complete")

nhanes_mids <- mice.pcr.sim(nhanes, m = 2, print = FALSE)
nhanes_complete <- complete(nhanes_mids)

test_that("No missing values remain in imputed nhanes data set", {
  expect_gt(sum(is.na(nhanes)), 0)
  expect_equal(sum(is.na(nhanes_complete)), 0)
})

test_that("Data set in returned mids object is identical to nhanes data set", {
  expect_identical(nhanes_mids$data, nhanes)
})

context("mice.pcr.sim: blocks")

test_that("blocks run as expected", {
  expect_silent(imp1b <<- mice.pcr.sim(nhanes,
    blocks = list(c("age", "hyp"), chl = "chl", "bmi"),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
  expect_silent(imp2b <<- mice.pcr.sim(nhanes2,
    blocks = list(c("age", "hyp", "bmi"), "chl", "bmi"),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
  # expect_silent(imp3b <<- mice.pcr.sim(nhanes2,
  #                             blocks = list(c("hyp", "hyp", "hyp"), "chl", "bmi"),
  #                             print = FALSE, m = 1, maxit = 1, seed = 1))
  expect_silent(imp4b <<- mice.pcr.sim(boys,
    blocks = list(c("gen", "phb"), "tv"),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
  expect_silent(imp5b <<- mice.pcr.sim(nhanes,
    blocks = list(c("age", "hyp")),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
})

test_that("Block names are generated automatically", {
  expect_identical(names(imp1b$blocks), c("B1", "chl", "bmi"))
})
test_that("Method `pmm` is used for mixed variable types", {
  expect_identical(unname(imp2b$method[1]), "pmm")
})
# test_that("Method `logreg` if all are binary", {
#   expect_identical(unname(imp3b$method[1]), "logreg")
# })
test_that("Method `polr` if all are ordered", {
  expect_identical(unname(imp4b$method[1]), "polr")
})
test_that("Method `polr` works with one block", {
  expect_identical(unname(imp5b$method[1]), "pmm")
})


# check for equality of `scatter` and `collect` for univariate models
# the following models yield the same imputations
imp1 <- mice.pcr.sim(nhanes,
  blocks = make.blocks(nhanes, "scatter"),
  print = FALSE, m = 1, maxit = 1, seed = 123
)
imp2 <- mice.pcr.sim(nhanes,
  blocks = make.blocks(nhanes, "collect"),
  print = FALSE, m = 1, maxit = 1, seed = 123
)
imp3 <- mice.pcr.sim(nhanes,
  blocks = list("age", c("bmi", "hyp", "chl")),
  print = FALSE, m = 1, maxit = 1, seed = 123
)
imp4 <- mice.pcr.sim(nhanes,
  blocks = list(c("bmi", "hyp", "chl"), "age"),
  print = FALSE, m = 1, maxit = 1, seed = 123
)

test_that("Univariate yield same imputes for `scatter` and `collect`", {
  expect_identical(complete(imp1), complete(imp2))
  expect_identical(complete(imp1), complete(imp3))
  expect_identical(complete(imp1), complete(imp4))
})

# potentially, we may also change the visitSequence, but mice.pcr.sim
# is quite persistent in overwriting a user-specified
# visitSequence for complete columns, so this not
# currently not an option. Defer optimizing this to later.

# another trick is to specify where for age by hand, so it forces
# mice.pcr.sim to impute age by pmm, but then, this would need to be
# done in both imp1 and imp2 models.

context("mice.pcr.sim: formulas")

test_that("formulas run as expected", {
  expect_silent(imp1f <<- mice.pcr.sim(nhanes,
    formulas = list(
      age + hyp ~ chl + bmi,
      chl ~ age + hyp + bmi,
      bmi ~ age + hyp + chl
    ),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
  expect_warning(imp2f <<- mice.pcr.sim(nhanes2,
    formulas = list(
      age + hyp + bmi ~ chl + bmi,
      chl ~ age + hyp + bmi + bmi,
      bmi ~ age + hyp + bmi + chl
    ),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
  # expect_silent(imp3f <<- mice.pcr.sim(nhanes2,
  #                             formulas = list( hyp + hyp + hyp ~ chl + bmi,
  #                                              chl ~ hyp + hyp + hyp + bmi,
  #                                              bmi ~ hyp + hyp + hyp + chl),
  #                             print = FALSE, m = 1, maxit = 1, seed = 1))
  expect_silent(imp4f <<- mice.pcr.sim(boys,
    formulas = list(
      gen + phb ~ tv,
      tv ~ gen + phb
    ),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
  expect_silent(imp5f <<- mice.pcr.sim(nhanes,
    formulas = list(age + hyp ~ 1),
    print = FALSE, m = 1, maxit = 1, seed = 1
  ))
})

test_that("Formula names are generated automatically", {
  expect_identical(names(imp1f$blocks), c("F1", "chl", "bmi"))
})
test_that("Method `pmm` is used for mixed variable types", {
  expect_identical(unname(imp2f$method[1]), "pmm")
})
# test_that("Method `logreg` if all are binary", {
#   expect_identical(unname(imp3f$method[1]), "logreg")
# })
test_that("Method `polr` if all are ordered", {
  expect_identical(unname(imp4f$method[1]), "polr")
})
test_that("Method `polr` works with one block", {
  expect_identical(unname(imp5f$method[1]), "pmm")
})


context("mice.pcr.sim: where")

# # all TRUE
imp1 <- mice.pcr.sim(nhanes,
  where = matrix(TRUE, nrow = 25, ncol = 4), maxit = 1,
  m = 1, print = FALSE
)

# # all FALSE
imp2 <- mice.pcr.sim(nhanes,
  where = matrix(FALSE, nrow = 25, ncol = 4), maxit = 1,
  m = 1, print = FALSE
)

# # alternate
imp3 <- mice.pcr.sim(nhanes,
  where = matrix(c(FALSE, TRUE), nrow = 25, ncol = 4),
  maxit = 1, m = 1, print = FALSE
)

# # whacky situation where we expect no imputes for the incomplete cases
imp4 <- mice.pcr.sim(nhanes2,
  where = matrix(TRUE, nrow = 25, ncol = 4),
  maxit = 1,
  meth = c("pmm", "", "", ""), m = 1, print = FALSE
)

test_that("`where` produces correct number of imputes", {
  expect_identical(nrow(imp1$imp$age), 25L)
  expect_identical(nrow(imp2$imp$age), 0L)
  expect_identical(nrow(imp3$imp$age), 12L)
  expect_identical(sum(is.na(imp4$imp$age)), nrow(nhanes2) - sum(complete.cases(nhanes2)))
})


context("mice.pcr.sim: ignore")

# # all TRUE
test_that("`ignore` throws appropriate errors and warnings", {
  expect_error(
    mice.pcr.sim(nhanes, maxit = 1, m = 1, print = FALSE, seed = 1, ignore = TRUE),
    "does not match"
  )
  expect_error(
    mice.pcr.sim(nhanes, maxit = 1, m = 1, print = FALSE, seed = 1, ignore = "string"),
    "not a logical"
  )
  expect_warning(
    mice.pcr.sim(nhanes,
      maxit = 1, m = 1, print = FALSE, seed = 1,
      ignore = c(rep(FALSE, 9), rep(TRUE, nrow(nhanes) - 9))
    ),
    "Fewer than 10 rows"
  )
})


# Check that the ignore argument is taken into account when
# calculating the results
# # all FALSE
imp1 <- mice.pcr.sim(nhanes,
  maxit = 1, m = 1, print = FALSE, seed = 1,
  ignore = rep(FALSE, nrow(nhanes))
)

# # NULL
imp2 <- mice.pcr.sim(nhanes, maxit = 1, m = 1, print = FALSE, seed = 1)

# # alternate
alternate <- rep(c(TRUE, FALSE), nrow(nhanes))[1:nrow(nhanes)]
imp3 <- mice.pcr.sim(nhanes,
  maxit = 0, m = 1, print = FALSE, seed = 1,
  ignore = alternate
)

test_that("`ignore` changes the imputation results", {
  expect_identical(complete(imp1), complete(imp2))
  expect_failure(expect_identical(complete(imp1), complete(imp3)))
})


# Check that rows flagged as ignored are indeed ignored by the
# univariate sampler in mice.pcr.sim
artificial <- data.frame(
  age = c(1, 1),
  bmi = c(NA, 40.0),
  hyp = c(1, 1),
  chl = c(200, 200),
  row.names = paste0("a", 1:2)
)

imp1 <- mice.pcr.sim(
  rbind(nhanes, artificial),
  maxit = 1, m = 1, print = FALSE, seed = 1, donors = 1L, matchtype = 0
)

imp2 <- mice.pcr.sim(
  rbind(nhanes, artificial),
  maxit = 1, m = 1, print = FALSE, seed = 1, donors = 1L, matchtype = 0,
  ignore = c(rep(FALSE, nrow(nhanes)), rep(TRUE, nrow(artificial)))
)

test_that("`ignore` works with pmm", {
  expect_equal(complete(imp1)["a1", "bmi"], 40.0)
  expect_failure(expect_equal(complete(imp2)["a1", "bmi"], 40.0))
})
