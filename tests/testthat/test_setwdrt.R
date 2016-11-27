
# these tests only work on my computer, they require the directory '/media/richard/Files/Dropbox/Proj/dismisc/' contain the proj
# replace proj.dir at the top with the project directory for dismisc to run on your computer

library(dismisc)

context("Testing if setwdrt works as expected")

proj.dir <- '/media/richard/Files/Dropbox/Proj/dismisc'

test_that("setwdrt can go to 'R' dir", {
  setrt(proj.dir)
  setwdrt("R")
  getwd() -> setwdrtapproach
  setwd(paste0(proj.dir,'/R'))
  getwd() -> baseapproach
  expect_equal(setwdrtapproach, baseapproach)
})


test_that("setwdrt can go to 'R' dir using a project named 'anotherProj'", {
  setrt(proj.dir,name='anotherProj')
  setwdrt("R",name='anotherProj')
  getwd() -> setwdrtapproach
  setwd(paste0(proj.dir,'/R'))
  getwd() -> baseapproach
  expect_equal(setwdrtapproach, baseapproach)
})

