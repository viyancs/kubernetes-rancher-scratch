#check environemnt to make sure longhorn storage supported
=============
- run to check
``` chmod +x environment_check.sh && ./environment_check.sh```
- patch the package
```chmod +x fix_package.sh && ./fix_package.sh```
- after everything supported from checking go to dashboard rancher and install longhorn using helm