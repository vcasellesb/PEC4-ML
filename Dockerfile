FROM ubuntu:latest

RUN groupadd -r user && useradd -m --no-log-init -r -g user user
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest r-cran-kernlab python3.9 python3-pip python3-setuptools python3-dev pandoc libblas-dev liblapack-dev r-cran-mvtnorm gfortran-11 texlive-xetex texlive-fonts-recommended texlive-plain-generic jupyter-nbconvert
RUN pip3 install --upgrade pip
RUN mkdir -p /app && chown user:user /app
WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN chmod 777 /app && chmod a+s /app
RUN Rscript -e "install.packages(c('ggplot2', 'reshape2', 'patchwork', 'caret', 'class', 'e1071', 'kernlab', 'C50', 'randomForest', 'knitr', 'rmarkdown'))"
RUN pip3 install -r requirements.txt

USER user

COPY --chown=user:user PEC4-R.Rmd /app
COPY --chown=user:user PEC4-Python.ipynb /app
COPY --chown=user:user R_code/ /app/R_code/
COPY --chown=user:user ECGCvdata.csv /app
COPY --chown=user:user main.R /app