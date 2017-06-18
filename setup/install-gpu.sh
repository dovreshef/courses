# This script is designed to work with ubuntu 16.04 LTS

# ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common

# download and install GPU drivers
wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb" -O "cuda-repo-ubuntu1604_8.0.44-1_amd64.deb"

sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
sudo modprobe nvidia
nvidia-smi

sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update
sudo apt-get install python3.6 python3.6-pip tmux

# install Anaconda for current user
mkdir downloads
cd downloads

python3 -m venv ~/.ml
source ~/.ml/bin/activate

pip3 install bcolz==1.1.2
pip3 install h5py==2.7.0
pip3 install jupyter==1.0.0
pip3 install Keras==1.2.2
pip3 install matplotlib==2.0.2
pip3 install pandas==0.20.2
pip3 install Pillow==4.1.1
pip3 install pipdeptree==0.10.1
pip3 install scikit-learn==0.18.1
pip3 install tensorflow-gpu==1.1.0

echo "[global]
device = gpu
floatX = float32

[cuda]
root = /usr/local/cuda" > ~/.theanorc

mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# install cudnn libraries
wget "http://files.fast.ai/files/cudnn.tgz" -O "cudnn.tgz"
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/

# configure jupyter and prompt for password

export CERT_PATH=~/.ssh/cert.pem
export KEY_PATH=~/.ssh/key.pem
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "$KEY_PATH" -out "$CERT_PATH"

jupyter notebook --generate-config
jupass=$(python -c "from notebook.auth import passwd; print(passwd())")
export CONFIG=$HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = u'"$jupass"'" >> $CONFIG
echo "c.NotebookApp.ip = '*'" >> $CONFIG
echo "c.NotebookApp.open_browser = False" >> $CONFIG
echo "c.NotebookApp.open_browser = False" >> $CONFIG
echo "c.NotebookApp.open_browser = False" >> $CONFIG
echo "c.NotebookApp.certfile = '$CERT_PATH'" >> $CONFIG
echo "c.NotebookApp.keyfile = '$KEY_PATH'" >> $CONFIG

# clone the fast.ai course repo and prompt to start notebook
cd ~
git clone https://github.com/fastai/courses.git
echo "\"jupyter notebook\" will start Jupyter on port 8888"
echo "If you get an error instead, try restarting your session so your $PATH is updated"
