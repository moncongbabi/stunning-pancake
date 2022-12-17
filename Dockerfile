FROM pytorch/pytorch:latest

WORKDIR /app

RUN chown -R 1000:1000 /app
RUN chmod -R 755 /app

RUN chown -R 1000:1000 /home
RUN chmod -R 755 /home

RUN apt-get upgrade -y && apt-get update -y && apt-get install -y python3-pip && pip3 install --upgrade pip
RUN apt-get -y install git curl gnupg wget nvidia-cuda-dev
RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get -y install nodejs
RUN npm install
RUN npm install -g configurable-http-proxy

ENV PATH="/home/admin/.local/bin:${PATH}"

RUN pip3 install jupyterhub && \
    pip3 install --upgrade notebook && \
    pip3 install oauthenticator && \
    pip3 install pandas scipy matplotlib && \
    pip3 install --upgrade jupyterlab jupyterlab-git && \
    pip3 install ipywidgets && \
    jupyter lab build

RUN jupyter nbextension enable --py widgetsnbextension
RUN useradd admin && echo admin:change.it! | chpasswd && mkdir /home/admin && chown admin:admin /home/admin

EXPOSE 7860
USER 1000:1000

CMD jupyter-lab --ip 0.0.0.0 --port 7860 --no-browser --allow-root --NotebookApp.token='mytoken' --NotebookApp.password='mypassword' --NotebookApp.allow_origin='*' --NotebookApp.headers='{"Content-Security-Policy": "frame-ancestors self *"}'