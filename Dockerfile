FROM rocker/r-ver:4.2

RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site
ENV RETICULATE_MINICONDA_ENABLED=FALSE

RUN apt-get update 
RUN apt-get install -y \
    libhdf5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    libboost-all-dev \
    libxml2-dev \
    libgeos-dev \
    openjdk-8-jdk \
    python3-dev \
    python3-pip \
    wget \
    git \
    libfftw3-dev \
    libgsl-dev \
    libcairo2-dev \
    libudunits2-dev \
    libgdal-dev \
    libproj-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    cmake \
    llvm-11 \
    libmagick++-dev \
    libsuitesparse-dev

RUN pip3 install numpy==1.22
RUN pip3 install umap-learn jupyterlab
RUN pip3 install 'scanpy[leiden]'
RUN pip3 install celltypist

RUN R --no-echo --no-restore --no-save -e "install.packages(c('remotes'))" 
RUN R --no-echo --no-restore --no-save -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'uuid', 'digest'))"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('IRkernel/IRkernel')"
RUN R --no-echo --no-restore --no-save -e "IRkernel::installspec(user = F)"

RUN R --no-echo --no-restore --no-save -e "install.packages(c('BiocManager'))"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'Biobase', 'limma', 'glmGamPoi', 'DelayedArray', 'DelayedMatrixStats', 'lme4', 'batchelor', 'Matrix.utils', 'HDF5Array', 'terra', 'ggrastr', 'Linnorm'))"

RUN R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools', 'hdf5r', 'tidyverse', 'viridis', 'harmony', 'rstatix', 'ggpubr','glmnet', 'stringdist', 'usethis', 'gprofiler2', 'magick'))"

RUN R --no-echo --no-restore --no-save -e "remotes::install_github(c('jokergoo/ComplexHeatmap'))"

RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('scDblFinder', 'DropletUtils'))"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('affy', 'limma', 'pd.clariom.s.mouse'))"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install('oligo', configure.args='--disable-threading', force = TRUE)"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('clariomsmousetranscriptcluster.db', 'biomaRt'))"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('satijalab/seurat', 'seurat5', quiet = TRUE)"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('satijalab/seurat-data', 'seurat5', quiet = TRUE)"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('satijalab/azimuth', 'seurat5', quiet = TRUE)"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('satijalab/seurat-wrappers', 'seurat5', quiet = TRUE)"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('bnprks/BPCells', quiet = TRUE)"

WORKDIR /mnt/storage

COPY start-notebook.sh /usr/local/bin/
COPY jupyter_config.json /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings
RUN chmod +x /usr/local/bin/start-notebook.sh
CMD ["start-notebook.sh"]
