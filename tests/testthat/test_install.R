context("Install packages")
Sys.setenv("R_TESTS" = "")
tmp <- file.path(tempdir(), "tmplib")
suppressWarnings(dir.create(tmp))

test_that("Install a single package", {
    expect_true(length(i1 <- suppressWarnings(install_github("cloudyr/ghit", lib = tmp, verbose = TRUE))) == 1)
})

test_that("Install a single package, removing old install", {
    expect_true(length(i1 <- suppressWarnings(install_github("cloudyr/ghit", lib = tmp, uninstall = TRUE, verbose = TRUE))) == 1)
    remove.packages("ghit", lib = tmp)
})

test_that("Install a single package w/o vignettes", {
    expect_true(length(i2 <- suppressWarnings(install_github("cloudyr/ghit", build_vignettes = FALSE, lib = tmp))) == 1)
    remove.packages("ghit", lib = tmp)
})

test_that("Install from a branch", {
    expect_true(length(i4 <- install_github("cloudyr/ghit[kitten]", lib = tmp)) == 1)
    if ("anRpackage" %in% installed.packages(lib = tmp)[, "Package"]) {
        remove.packages("anRpackage", lib = tmp)
    }
})

test_that("Install from a commit ref", {
    expect_true(length(i5 <- suppressWarnings(install_github("cloudyr/ghit@6d118d08", lib = tmp))) == 1)
    remove.packages("ghit", lib = tmp)
})

test_that("Install from a tag", {
    expect_true(length(i6 <- suppressWarnings(install_github("cloudyr/ghit@v0.1.1", lib = tmp))) == 1)
    remove.packages("ghit", lib = tmp)
})

test_that("Install from a pull request", {
    if (packageVersion("git2r") > "0.13.1.9000") {
        expect_true(length(i7 <- suppressWarnings(install_github("cloudyr/ghit#13", lib = tmp))) == 1)
    } else {
        expect_true(TRUE)
    }
    remove.packages("ghit", lib = tmp)
})

test_that("An invalid reponame returns informative error", {
    expect_error(install_github("missinguser"), "Invalid 'repo' string")
})

# cleanup
if ("ghit" %in% installed.packages(lib.loc = tmp)[, "Package"]) {
    remove.packages("ghit", lib = tmp)
}
unlink(tmp)
