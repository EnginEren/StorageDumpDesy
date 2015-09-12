# StorageDumpDesy
When one's proxy is expired in my-proxy server,

in nafhh : 
  Destroy myproxy server proxy : myproxy-destroy -d
  export GT_PROXY_MODE=rfc
  voms-proxy-init --voms cms   (or if you have proper role --> voms-proxy-init --voms cms:/cms/dcms/Role=cmsphedex)
  myproxy-init -s grid-px.desy.de -d -n -t 48 -c 720
  myproxy-info -d

connect to vobox:
  vobox-proxy --vo cms --proxy-safe 3600 --myproxy-safe 259200 --email yourEmail register
  ln -s PATH ~/k5-ca-proxy.pem  
  
  (One example PATH is : /var/lib/vobox/cms/proxy_repository/+2fC+3dDE+2fO+3dGermanGrid+2fOU+3dDESY+2fCN+3dEngin+20Eren+2fCN+3dproxy-voms+20cms)
  
