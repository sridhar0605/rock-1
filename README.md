
# Rocking R at UMCCR

[![Travis build
status](https://travis-ci.org/umccr/rock.svg?branch=master)](https://travis-ci.org/umccr/rock)
[![Coverage
status](https://codecov.io/gh/umccr/rock/branch/master/graph/badge.svg)](https://codecov.io/github/umccr/rock?branch=master)

`rock` is an R package that (hopefully) helps with the day to day
bioinformatics life at UMCCR (UniMelb Centre for Cancer Research).

## Installation

You can install the development version of `rock` from
[GitHub](https://github.com/umccr/rock) with:

``` r
# install.packages("devtools") # if not pre-installed
devtools::install_github("umccr/rock") # master version
devtools::install_github("umccr/rock@v1.2.3") # release v1.2.3
devtools::install_github("umccr/rock@abcd") # commit abcd
```

## Circos Plots

  - We can generate circos plots using the
    [OmicCircos](https://bioconductor.org/packages/release/bioc/html/OmicCircos.html)
    Bioconductor R package.

<!-- end list -->

``` r
library(rock)
```

  - Start by preparing the SV and CNV
calls:

<!-- end list -->

``` r
manta <- system.file("extdata", "HCC2218_manta.vcf", package = "pebbles")
cnvkit <- system.file("extdata", "HCC2218_cnvkit-call.cns", package = "pebbles")
facets <- system.file("extdata", "HCC2218_facets_cncf.tsv", package = "pebbles")
sv_manta <- prep_manta_vcf(manta)
cn_facets <- prep_facets_seg(facets)
cn_cnvkit <- prep_cnvkit_seg(cnvkit)
```

  - Now we can generate a circos plot with Manta links and FACETS/CNVkit
    segments:

<!-- end list -->

``` r
plot_circos(sv = sv_manta, cnv = cn_cnvkit)
```

<img src="man/figures/README-circos-plot-manta-cnvkit-1.png" width="100%" />

``` r
plot_circos(sv = sv_manta, cnv = cn_facets)
```

<img src="man/figures/README-circos-plot-manta-facets-1.png" width="100%" />
