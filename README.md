## Docker Compose for Tron Common API Local Testing

This repository hosts the docker compose file to get a full, local testing instance running
in your dev environment for integrating/testing with Common API.

![Overview](images/compose.png)

_BEFORE_ cloning this repo, follow the steps below to get an environment setup.

1. Create or identify a local directory that will hold all of the Common API repositories (i.e. ~/tron-common)

2. `cd` into that directory and clone the following repositories from https://code.il2.dso.mil/tron/products/tron-common-api
    
    + tron-common-api-local (this repo)
    + tron-common-api
    + tron-common-api-dashboard
    + tron-common-api-proxy
    + tron-common-api-seeder

    NOTE: You can also run the `get-common.sh` script from the `tron-common-api-local` directory.  It will make the repos needed one-level up and/or update those if they already exist.  You can run the script with `./get-common.sh <TOKEN>` where `<TOKEN>` is your IL2 Gitlab Access Token (note this script will not run on Windows, unless you run it in the WSL (Subsystem for Linux shell))

3. Once the repos are cloned into your directory of choosing (and again, the above folders/repos must be on the same directory level like shown above), login into the code IL2 GitLab's container registry with the following command:

    `docker login registry.il2.dso.mil -u gitlab_ci_token -p <token>`

    where `<token>` is your GitLab token string (token must have registry access attributes chosen, if you're not sure, you can check in your GitLab account settings.  If it does not have these, simply create a new token that does)

4. Once you get a successful login into the container registry, `cd tron-common-api-local` and issue the following commands:

    `docker-compose build`

    then

    `docker-compose up -d`

    This will build and start all the needed containers (after pulling the images it needs from both Docker Hub and the code IL2 registry).  Note for the first build and start-up, this could take **several** minutes. Subsequent starts should only require `docker-compose up -d` and take considerably less time.  You should see something like this:

    ![Image of bootup](images/started.png)

5.  Once the bootup completes, navigate to http://localhost:8080 to access the Tron Common API Dashboard as the default admin user (John Tester - jt@test.mil).  If you set `FRONTEND_PORT` env var, then replace `8080` with whatever you used.

6.  Configurable options lie with the environment variables.  The overall diagram of the compose setup above shows the ENV VARS that are intended to be configured.  The default values are show in black and the other/alternate values are shown in red.

    *FRONTEND_PORT* - what localhost port to serve the Dashboard UI from - defaults to 8080

    *PROXY_PORT* - what localhost port to listen for traffic in which to proxy to the API - defaults to 9000

    *PROXY_CONFIG* - what localhost port to serve the proxy configuration page from - defaults to 9001

    *BACKEND_PORT* - what localhost port to open for direct API access (unproxied) - defaults to 8088

    *RUN_SEEDER* - runs the seeder script on startup.  The seed data is an entire Wing with its subordinate groups, squadrons and flights + members.

    *ENABLE_PROXY* - enables the proxy (if disabled traffic still flows through this but no headers are injected).  The proxy injects the currently selected JWT (defaults to admin.jwt in the Proxy container which has the email address of the default admin - jt@test.mil).  Proxy can be configured over its web interface on the localhost's 9001 port.

    *SECURITY_ENABLED* - enables Spring security (default to ON) where the backend applies roles and privileges based on JWT and/or the Istio X-forwarded-client-cert header (for app to app communication).  
    
    + Note that if security is enabled and settings are set to use the H2 db (see below), the H2 console still cannot be accessed from the web console - this is due to the H2 setting to refuse remote connections.
    + Also note that with security disabled, the dashboard will not work correctly either since the client app looks for a role back from the db - which it will not receive since it pays no attention to JWTs in this mode.

    *DROP_DB* - if enabled, the Postgres DB is first dropped on startup before any migrations

    *ACTIVE_PROFILE* - defaults to `production` which looks to use the postgres db container to persist data across sessions.  If set to `development` the backend will use a temporary Java-H2 in-mem database.

7. To configure the proxy during runtime, navigate a web browser to http://localhost:9001 (or substitute the port number with whatever you set the PROXY_CONFIG env var to) and the following screen will display

    ![Proxy Config](images/proxy.png)

    On the proxy config screen, you can choose to enable/disable proxy and choose with JWT token is actively being injected into the inbound requests.  The active JWT can be edited from here as well and JWTs can be created/deleted too.

8. To stop the stack, issue command:

    `docker-compose down`

    This will result in something like this:

    ![Image of teardown](images/ended.png)

    If you used a postgres db then the data inside it will still be there on the next `docker-compose up -d`.  Your configured JWTs you configured (if any) on the PROXY web config page, will also persist across sessions by default.
