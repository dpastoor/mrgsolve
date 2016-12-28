##' Set the \code{data} argument for \code{mrgsim}.
##'
##'
##' @export
##' @param x model object
##' @param data data set
##' @param ... passed along
setGeneric("data_set", function(x,data,...) standardGeneric("data_set"))
##' @export
##' @rdname data_set
##' @param subset passed to \code{dplyr::filter_}; retain only certain rows in the data set
##' @param select passed to \code{dplyr::select_}; retain only certain columns in the data set
##'
##'
##' @details
##' Input data sets are \code{R} data frames that can include columns with any valid name, however columns with selected names are recognized by \code{mrgsolve} and incorporated into the simulation.
##'
##' \code{ID} specifies the subject ID and is required for every input data set.
##'
##' When columns have the same name as parameters (\code{$PARAM} in the model specification file), the values in those columns will be used to update the corresponding parameter as the simulation progresses.
##'
##' Input data set may include the following columns related to PK dosing events: \code{time}, \code{cmt}, \code{amt}, \code{rate},
##' \code{ii}, \code{addl}, \code{ss}.  \code{time} and \code{cmt} (and \code{ID}) are required columns in the input data set.  \code{time} is the observation or event time, \code{cmt} is the compartment number (see \code{\link{init}}), \code{amt} is the dosing amount, \code{rate} is the infusion rate, \code{ii} is the dosing interval, \code{addl} specifies additional doses to administer, and \code{ss} is a flag for steady state dosing.  These column names operate similarly to other non-linear mixed effects modeling software, but note that (except for \code{ID}) the column names related to PK dosing must be lower case.
##'
##' Only numeric data can be brought in to the problem.  Any non-numeric data columns will be dropped with warning.
##'
##' See \code{\link{exdatasets}} for different example data sets.
##'
##'
##' @examples
##'
##' mod <- mrgsolve:::house()
##' 
##' data <- expand.ev(ID=1:3, amt=c(10,20))
##'
##' mod %>% data_set(data, ID > 1) %>% mrgsim
##'
##'
##'
setMethod("data_set",c("mrgmod", "data.frame"), function(x,data,subset=TRUE,select=TRUE,...) {
  if(exists("data", x@args)) stop("data already has been set.")
  if(!missing(subset)) data <- dplyr::filter_(data,.dots=lazy(subset))
  if(!missing(select)) data <- dplyr::select_(data,.dots=lazy(select))

  if(nrow(data) ==0) stop("Zero rows in data after filtering.", call.=FALSE)
  data <- mrgindata(m=x,x=as.data.frame(data),...)
  x@args <- merge(x@args,list(data=data), open=TRUE)
  return(x)
})

##' @export
##' @rdname data_set
setMethod("data_set",c("mrgmod", "ANY"), function(x,data,...) {
  return(data_set(x,as.data.frame(data),...))
})


##' Convert select upper case column names to lower case to conform to \code{mrgsolve} data expectations.
##'
##'
##' @param data an nmtran-like data frame
##'
##' @return A data.frame with renamed columns.
##'
##' @details
##' Columns that will be renamed with lower case versions: \code{AMT}, \code{II}, \code{SS}, \code{CMT}, \code{ADDL}, \code{RATE}, \code{EVID}, \code{TIME}.  If a lower case version
##' of these names exist in the data set, the column will not be renamed.
##' @export
lctran <- function(data) {
  n <- names(data)
  infrom <- is.element(n,tran_upper)
  haslower <- is.element(tolower(n),n)
  change <- infrom & !haslower
  if(sum(change) > 0) names(data)[change] <- tolower(n[change])
  data
}