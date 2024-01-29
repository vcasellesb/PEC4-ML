FROM ubuntu:latest

RUN groupadd -r user && useradd -m --no-log-init -r -g user user
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    r-base r-cran-randomforest r-cran-kernlab python3.9 python3-pip \
    python3-setuptools python3-dev pandoc libblas-dev liblapack-dev \
    r-cran-mvtnorm gfortran-11 texlive-xetex texlive-fonts-recommended \
    texlive-plain-generic jupyter-nbconvert lmodern
RUN pip3 install --upgrade pip
RUN mkdir -p /app && chown user:user /app
WORKDIR /app

RUN chmod -R 777 /app && chmod a+s /app
COPY requirements.txt /app/requirements.txt
COPY requirements.R /app/requirements.R

RUN Rscript requirements.R
RUN pip3 install -r requirements.txt

USER user

COPY --chown=user:user PEC4-R.Rmd /app
COPY --chown=user:user PEC4-Python.ipynb /app
COPY --chown=user:user R_code/ /app/R_code/
COPY --chown=user:user main.R /app

ENTRYPOINT [ "Rscript", "main.R" ]