if (suppressWarnings(
  require("testthat") &&
  require("ggeffects") &&
  require("glmmTMB") &&
  require("pscl")
)) {
  data(Salamanders)

  m1 <- zeroinfl(count ~ mined | mined, dist = "poisson", data = Salamanders)
  m2 <- hurdle(count ~ mined | mined, dist = "poisson", zero.dist = "poisson", data = Salamanders)
  m3 <- hurdle(count ~ mined | mined, dist = "poisson", zero.dist = "binomial", data = Salamanders)
  m4 <- hurdle(count ~ mined | mined, dist = "poisson", zero.dist = "binomial", link = "log", data = Salamanders)
  m5 <- zeroinfl(count ~ mined | mined, dist = "negbin", link = "log", data = Salamanders)

  test_that("ggpredict, pscl", {
    ggpredict(m1, "mined", type = "fe")
    ggpredict(m1, "mined", type = "fe.zi")
    ggpredict(m2, "mined", type = "fe")
    ggpredict(m2, "mined", type = "fe.zi")
    ggpredict(m3, "mined", type = "fe")
    ggpredict(m3, "mined", type = "fe.zi")
    ggpredict(m4, "mined", type = "fe")
    ggpredict(m4, "mined", type = "fe.zi")
    ggpredict(m5, "mined", type = "fe")
    ggpredict(m5, "mined", type = "fe.zi")
  })

  test_that("ggpredict, pscl", {
    skip_on_cran()
    set.seed(123)
    pr <- ggpredict(m1, "mined", type = "fe.zi")
    expect_equal(pr$conf.low, c(0.1731, 2.0172), tolerance = 1e-3)

    model <- zeroinfl(count ~ mined * spp | mined * spp, dist = "poisson", data = Salamanders)
    set.seed(123)
    pr <- ggpredict(model, c("mined", "spp"), type = "fe.zi")
    expect_equal(
      pr$conf.low,
      c(0, 0, 0.03704, 1e-05, 1e-05, 0.14815, 0.13418, 1.61886,
        0.04808, 1.81329, 0.48571, 3.07055, 3.1093, 1.33136),
      tolerance = 1e-2
    )
  })

  test_that("ggemmeans, pscl", {
    ggemmeans(m1, "mined", type = "fe")
    ggemmeans(m1, "mined", type = "fe.zi")
    ggemmeans(m2, "mined", type = "fe")
    ggemmeans(m2, "mined", type = "fe.zi")
    ggemmeans(m3, "mined", type = "fe")
    ggemmeans(m3, "mined", type = "fe.zi")
    ggemmeans(m4, "mined", type = "fe")
    ggemmeans(m4, "mined", type = "fe.zi")
    ggemmeans(m5, "mined", type = "fe")
    ggemmeans(m5, "mined", type = "fe.zi")
  })

  test_that("compare, pscl", {
    p1 <- ggemmeans(m1, "mined", type = "fe")
    p2 <- ggpredict(m1, "mined", type = "fe")
    expect_equal(p1$predicted[1], p2$predicted[1], tolerance = 1e-3)

    p1 <- ggemmeans(m1, "mined", type = "fe.zi")
    p2 <- ggpredict(m1, "mined", type = "fe.zi")
    expect_equal(p1$predicted[1], p2$predicted[1], tolerance = 1e-3)

    p1 <- ggemmeans(m2, "mined", type = "fe")
    p2 <- ggpredict(m2, "mined", type = "fe")
    expect_equal(p1$predicted[1], p2$predicted[1], tolerance = 1e-3)

    p1 <- ggemmeans(m2, "mined", type = "fe.zi")
    p2 <- ggpredict(m2, "mined", type = "fe.zi")
    expect_equal(p1$predicted[1], p2$predicted[1], tolerance = 1e-3)

    p1 <- ggemmeans(m5, "mined", type = "fe")
    p2 <- ggpredict(m5, "mined", type = "fe")
    expect_equal(p1$predicted[1], p2$predicted[1], tolerance = 1e-3)

    p1 <- ggemmeans(m5, "mined", type = "fe.zi")
    p2 <- ggpredict(m5, "mined", type = "fe.zi")
    expect_equal(p1$predicted[1], p2$predicted[1], tolerance = 1e-3)
  })

}
