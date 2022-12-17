FROM pytorch/pytorch:latest

# for heroku the ports association is dynamic
ARG port
ENV PORT=$port

# if needed you can rename the workdir
WORKDIR /app/analysis

RUN chown -R 1000:1000 /app
RUN chmod -R 755 /app

# Install python, node, npm packages
RUN apt-get upgrade -y && apt-get update -y && apt-get install -y python3-pip && pip3 install --upgrade pip
RUN apt-get -y install curl gnupg
RUN apt-get -y install git
RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get -y install nodejs
RUN npm install
RUN npm install -g configurable-http-proxy

RUN pip3 install jupyterhub && \
    pip3 install --upgrade notebook && \
    pip3 install oauthenticator && \
    pip3 install pandas scipy matplotlib && \
    pip3 install --upgrade jupyterlab jupyterlab-git && \
    jupyter lab build

# add user admin to create login for your jupyterhub
RUN useradd admin && echo admin:change.it! | chpasswd && mkdir /home/admin && chown admin:admin /home/admin

# adding python supporting scripts
ADD jupyterhub_config.py /app/analysis/jupyterhub_config.py
ADD create-user.py /app/analysis/create-user.py

# expose the port
EXPOSE 7860

USER 1000:1000

# run the jupyter hub feel free to add your arguments needed 
CMD jupyterhub --ip 0.0.0.0 --port 7860 --no-ssl --NotebookApp.token='mytoken' --NotebookApp.password='mypassword'