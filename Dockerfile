# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/devel/cudnn8/Dockerfile
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /content

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y python3-pip && pip3 install --upgrade pip

RUN apt-get install -y curl gnupg wget htop sudo git git-lfs software-properties-common build-essential libgl1

RUN add-apt-repository ppa:flexiondotorg/nvtop
RUN apt-get upgrade -y
RUN apt-get install -y nvtop

RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get install -y nodejs
RUN npm install
RUN npm install -g configurable-http-proxy

ENV PATH="/home/admin/.local/bin:${PATH}"

RUN pip3 install jupyterhub && \
    pip3 install --upgrade notebook && \
    pip3 install oauthenticator && \
    pip3 install pandas scipy matplotlib && \
    pip3 install --upgrade jupyterlab jupyterlab-git && \
    pip3 install ipywidgets && \
    pip3 install torch torchvision torchaudio && \
    jupyter lab build
    
RUN jupyter nbextension enable --py widgetsnbextension

RUN useradd admin && echo admin:change.it! | chpasswd && mkdir /home/admin && chown -R admin:admin /home/admin

RUN git clone https://github.com/camenduru/jupyter

RUN chown -R admin:admin /content
RUN chmod -R 777 /content
RUN chown -R admin:admin /home
RUN chmod -R 777 /home

USER admin

EXPOSE 7860

CMD jupyter-lab --ip 0.0.0.0 --port 7860 --no-browser --allow-root --NotebookApp.token='mytoken' --NotebookApp.password='mypassword' --NotebookApp.tornado_settings="{'headers': {'X-Frame-Options': 'ALLOW-FROM https://huggingface.co/'}}"
