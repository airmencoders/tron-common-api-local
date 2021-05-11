#! bash

TOKEN=$1

# first make sure we're in the correct directory
# should be 'tron-common-api-local'
[[ $(pwd) =~ "tron-common-api-local$" ]] || (echo "Doesn't look like you're in the tron-common-api-local dir... Exiting"; exit 1;)

HOME=$(pwd)

mkdir -p ../tron-common-api && cd $_
if [[ $(git remote -v) =~ tron-common-api.git ]]; then
    echo "Updating backend api repo...";
    git pull
else
    echo "Cloning the backend api repo...";
    git clone https://oauth2:${TOKEN}@code.il2.dso.mil/tron/products/tron-common-api/tron-common-api.git .
fi
cd $HOME

mkdir -p ../tron-common-api-dashboard && cd $_
if [[ $(git remote -v) =~ tron-common-api-dashboard.git ]]; then
    echo "Updating dashboard repo...";
    git pull
else 
    echo "Cloning the dashboard repo...";
    git clone https://oauth2:${TOKEN}@code.il2.dso.mil/tron/products/tron-common-api/tron-common-api-dashboard.git .
fi
cd $HOME

mkdir -p ../tron-common-api-seeder && cd $_
if [[ $(git remote -v) =~ tron-common-api-seeder.git ]]; then
    echo "Updating seeder repo...";
    git pull
else 
    echo "Cloning the seeder repo...";
    git clone https://oauth2:${TOKEN}@code.il2.dso.mil/tron/products/tron-common-api/tron-common-api-seeder.git .
fi
cd $HOME

mkdir -p ../tron-common-api-proxy && cd $_
if [[ $(git remote -v) =~ tron-common-api-proxy.git ]]; then
    echo "Updating proxy repo...";
    git pull
else
    echo "Cloning the proxy repo...";
    git clone https://oauth2:${TOKEN}@code.il2.dso.mil/tron/products/tron-common-api/tron-common-api-proxy.git .
fi
cd $HOME

echo "Done"
echo "You can now do 'docker-compose build .' and then 'docker-compose up -d'"