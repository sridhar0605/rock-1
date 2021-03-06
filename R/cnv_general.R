#' Read CNVkit, FACETS, PURPLE or TitanCNA CNV Segments
#'
#' Reads the CNV segment TSV file output by CNVkit, FACETS, PURPLE or TitanCNA.
#'
#' @param cnv Path to CNV file.
#' @return A `cnv` list containing a dataframe (`tibble`) with the following columns:
#'   * chrom: chromosome
#'   * start: start coordinate
#'   * end: end coordinate
#'   * tot_cn: total copy number estimate
#'
#' @examples
#'
#' fn <- system.file("extdata", "HCC2218_cnvkit-call.cns", package = "pebbles")
#' cnv <- read_cnv(fn)
#'
#' @export
read_cnv <- function(cnv) {
  caller <- get_caller(cnv)
  stopifnot(!is.null(caller))


  fl <- list(facets = prep_facets_seg,
             cnvkit = prep_cnvkit_seg,
             purple = prep_purple_seg,
             titan  = prep_titan_seg)

  fl[[caller]](cnv)

}

# fn <- list.files(system.file("extdata", package = "pebbles"), full.name = TRUE)
# sapply(fn, get_caller)
get_caller <- function(cnv) {
  stopifnot(file.exists(cnv))
  h <- readr::read_lines(cnv, n_max = 1)
  caller <- NULL

  if (grepl("probes", h)) {
    caller <- "cnvkit"
  } else if (grepl("tcn\\.em", h)) {
    caller <- "facets"
  } else if (grepl("segmentStartSupport", h)) {
    caller <- "purple"
  } else if (grepl("TITAN", h)) {
    caller <- "titan"
  } else {
    message("Unknown caller. Make sure you're reading CNV segments ",
            "from\nCNVkit (cnvkit-call.cns),\nFACETS (facets_segs.tsv),\n",
            "PURPLE (purple.cnv), or\nTITAN (titan_segs.tsv).")
  }

  return(caller)
}

#' Prepare CNV Segments for Perl Circos
#'
#' Exports CNV segment coordinates for plotting in Perl Circos.
#'
#' @param cnv Path to CNV call file.
#' @return A dataframe (`tibble`) with the following columns:
#'   * chrom: homo sapiens chromosome
#'   * start: start coordinate
#'   * end: end coordinate
#'   * value: total copy number estimate, minus 2
#'
#' @examples
#' cn <- system.file("extdata", "HCC2218_cnvkit-call.cns", package = "pebbles")
#' prep_cnv_circos(cn)
#'
#' @export
prep_cnv_circos <- function(cnv) {

  cnv <- read_cnv(cnv)$cnv
  cnv %>%
    dplyr::mutate(chrom = paste0("hs", .data$chrom),
                  tot_cn = .data$tot_cn - 2) %>%
    dplyr::rename(value = .data$tot_cn)
}
