# from jupyterhub.spawner import SimpleLocalProcessSpawner

# c.ServerApp.ip = '0.0.0.0'
# c.JupyterHub.ip = '0.0.0.0'
# c.JupyterHub.proxy_api_ip = '0.0.0.0'
# c.JupyterHub.hub_ip = '0.0.0.0'

# c.Spawner.notebook_dir = '~/notebooks'
# c.Spawner.args = ['--NotebookApp.default_url=/notebooks/Welcome.ipynb']
# c.JupyterHub.port = 443

# setting a dummy user admin for now
c.JupyterHub.authenticator_class = "dummy"
c.DummyAuthenticator.password = "admin"

# using simplelocalspawner for now
# c.JupyterHub.spawner_class = SimpleLocalProcessSpawner
# c.Spawner.cmd = ['jupyter-labhub']

headers = {'Content-Security-Policy': 'frame-ancestors *'}
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_credentials = True
c.NotebookApp.tornado_settings = {'headers': headers}
c.NotebookApp.open_browser = False

# for creating new users
c.LocalAuthenticator.add_user_cmd = ['python3','/app/analysis/create-user.py','USERNAME']
c.LocalAuthenticator.create_system_users = True