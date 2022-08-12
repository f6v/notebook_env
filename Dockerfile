FROM rocker/r-ver:4.1.0

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
    llvm-10

RUN R --no-echo --no-restore --no-save -e "install.packages(c('BiocManager', 'remotes'))"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'Biobase', 'limma', 'glmGamPoi', 'DelayedArray', 'DelayedMatrixStats', 'lme4', 'batchelor', 'Matrix.utils', 'HDF5Array', 'terra', 'ggrastr', 'tanaylab/metacell'))"

RUN R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools', 'hdf5r', 'Seurat', 'tidyverse', 'viridis'))"

RUN R --no-echo --no-restore --no-save -e "remotes::install_github(c('mojaveazure/seurat-disk', 'satijalab/seurat-data', 'cole-trapnell-lab/monocle3'))"

RUN pip3 install numpy==1.22
RUN pip3 install umap-learn jupyterlab
RUN pip3 install 'scanpy[leiden]'
RUN pip3 install celltypist

RUN R --no-echo --no-restore --no-save -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'uuid', 'digest'))"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('IRkernel/IRkernel')"
RUN R --no-echo --no-restore --no-save -e "IRkernel::installspec(user = F)"

RUN R --no-echo --no-restore --no-save -e "remotes::install_github('satijalab/seurat-wrappers')"

RUN R --no-echo --no-restore --no-save -e "install.packages(c('rstatix', 'ggpubr'))"
RUN R --no-echo --no-restore --no-save -e "install.packages(c('glmnet'))"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('flowCore'))"
WORKDIR /mnt/storage

COPY start-notebook.sh /usr/local/bin/
COPY jupyter_config.json /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings
RUN chmod +x /usr/local/bin/start-notebook.sh
CMD ["start-notebook.sh"]
