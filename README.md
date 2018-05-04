* * *

**H**ello World
---------------

_Step-by-step walkthrough to help you get started. You should be able to adapt this into your CI/CD flow regardless of what technology you are using._

### Preparation

1.  [Sign up](http://www.ioncube.com/encoder_eval_download.php) for the ionCube Encoder trial and copy the download link (will be emailed to your inbox)
2.  Set up [public key authentication](https://www.ssh.com/ssh/copy-id) to the remote server

### Let's go

1.  Copy git repo on local machine
```sh
git clone git@github.com:HendrikPrinsZA/ssh-ioncube.git && cd ssh-ioncube
```

2.  Copy git repo on remote machine
```sh
git clone git@github.com:HendrikPrinsZA/ssh-ioncube.git && cd ssh-ioncube
```

3.  Install ionCube PHP Encoder on remote machine
```sh
wget http://downloads3.ioncube.com/eval_download_packages/ioncube_encoder/linux_i686/en/ioncube_encoder_evaluation.tar.gz
tar -zxvf ioncube_encoder_evaluation.tar.gz
```

4.  Trigger encoding from local machine
```sh
./local.sh --host="devops.example.com" \
           --user="administrator" \
           --exec="/var/www/html/ssh-ioncube/remote.sh" \
           --source="/var/www/html/ssh-ioncube/raw" \
           --target="/var/www/html/ssh-ioncube/encoded" \
           --dir="example-app" \
           --encoder="/home/administrator/ioncube_encoder_evaluation/ioncube_encoder.sh" \
           --verbose
```
