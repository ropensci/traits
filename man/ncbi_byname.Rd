% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ncbi_byname.R
\name{ncbi_byname}
\alias{ncbi_byname}
\title{Retrieve gene sequences from NCBI by taxon name and gene names.}
\usage{
ncbi_byname(
  taxa,
  gene = "COI",
  seqrange = "1:3000",
  getrelated = FALSE,
  verbose = TRUE,
  batch_size = 100,
  ...
)
}
\arguments{
\item{taxa}{(character) Scientific name to search for.}

\item{gene}{(character) Gene or genes (in a vector) to search for.
See examples.}

\item{seqrange}{(character) Sequence range, as e.g., \code{"1:1000"}. This is the range of
sequence lengths to search for. So \code{"1:1000"} means search for sequences from 1 to 1000
characters in length.}

\item{getrelated}{(logical) If \code{TRUE}, gets the longest sequences of a species
in the same genus as the one searched for. If \code{FALSE}, returns nothing if no match
found.}

\item{verbose}{(logical) If \code{TRUE} (default), informative messages printed.}

\item{batch_size}{An integer specifying the number of names to query per batch.}

\item{...}{Curl options passed on to \link[crul:verb-GET]{crul::verb-GET}}
}
\value{
data.frame
}
\description{
Retrieve gene sequences from NCBI by taxon name and gene names.
}
\details{
Removes predicted sequences so you don't have to remove them.
Predicted sequences are those with accession numbers that have "XM_" or
"XR_" prefixes. This function retrieves one sequences for each species,
picking the longest available for the given gene.
}
\examples{
\dontrun{
# A single species
ncbi_byname(taxa="Acipenser brevirostrum")

# Many species
species <- c("Colletes similis","Halictus ligatus","Perdita californica")
ncbi_byname(taxa=species, gene = c("coi", "co1"), seqrange = "1:2000")
}
}
\seealso{
\code{\link[=ncbi_searcher]{ncbi_searcher()}}, \code{\link[=ncbi_byid]{ncbi_byid()}}
}
\author{
Scott Chamberlain
}
